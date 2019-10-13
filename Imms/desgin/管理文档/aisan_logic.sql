--
-- 判断工位机是否已经登录，如果已经登录，则返回登录的记录编号
--
create procedure WorkstationIsLogin(
    GID     int,   -- 组号
    DID     int,   -- 工位机号
    RecordTime datetime,  --  记录的时间
    RESULT  bigint output -- 当前登录的记录号
)
begin
    declare _today datetime;    
    set _today = DATE_FORMAT(RecordTime,'%Y/%m/%d');
    /*
      员工登录： 上班前必须刷卡。
          1. 每天必须刷卡，即一旦过了0:00，就要重新刷卡。
          2. 每隔4个小时必须重新刷卡。
    */    
    set RESULT = ifnull((select record_id
            from workstation_login
            where rfid_terminator_id = DID
              and rfid_controller_group_id = GID
              and login_time >= _today   -- 必须今天
              and login_time >= DATE_SUB(RecordTime,interval 4 hour)  -- 必须在4个小时以内有登录记录
            order by login_time
            limit 1
    ),-1);
end;

--
-- 判断卡是否是正确的卡
--
create procedure CardNoIsValid(
  card_no   varchar(20),   -- 卡号
  RESULT    bigint output  -- 记录号
)
begin
   set RESULT = ifnull((
       select record_id 
         from rfid_card
         where rfid_no = card_no
          and card_status = 0
   ),-1);
end;


--
-- 根据产品编号获取生产计划
--
create procedure GetProductionOrder(
  production_id   bigint,  -- 产品编号
  plan_date       date,    -- 计划日期
  RESULT          bigint output   -- 记录编号
)
begin   
   set RESULT = ifnull((
     select record_id
       from production_order po
       where po.production_id = production_id
         and po.plan_date = plan_date       
   ),-1);
end;

--
-- 获取某个产品的最后一道工艺车间
--
create procedure GetLastWorkshopId(
    workshop_id bigint,
    RESULT      bigint output
)
begin
    declare LAST_RESULT bigint;

    set RESULT = workshop_id;
    set LAST_RESULT = RESULT;
    
    set RESULT = ifnull(( select w.next_workshop_id
                     from work_organization_unit w
                    where w.workshop_id = workshop_id
    ),-1);
    while (RESULT!=-1) do
      set LAST_RESULT = RESULT;

      set RESULT = ifnull(( select w.next_workshop_id
                        from work_organization_unit w
                        where w.workshop_id = RESULT
      ),-1);         
    end while;

    set RESULT = LAST_RESULT;    
end;

--
-- 刷数量卡：进行整数报工或者移库
--
create procedure ReportProductionOrder(
    rfid_no          varchar(20),
    GID              int,
    DID              int,
    GatherTime       datetime, 
    Resp             varchar(500) output
)
top:begin  
  declare login_record_id,rfid_id,production_order_id,workshop_id,workstation_id,production_id,operator_id bigint;
  declare production_order_no,workshop_code,workstation_code,production_code,employee_id varchar(20);
  declare production_name,workshop_name,workstation_name,employee_name varchar(50);  
  declare report_qty int;
  declare login_workshop_id,login_workstation_id bigint;
  declare login_workshop_code,login_workstation_code varchar(20);
  declare login_workshop_name,login_workstation_name  varchar(50);
  declare last_workshop_id,first_workshop_id  bigint;
  declare is_move,card_status int;
   
  set Resp='|2|1|1';
  set is_move = 0;

  declare exit handler for sqlexception
  begin
    rollback;
    
    declare code varchar(5) default '00000';
    declare msg text;
    get diagnostics condition 1 code = returned_sqlstate, msg = message_text;
    set Resp = CONCAT(Resp,'系统出现异常:',msg,'[',code,'],请联系系统管理员。');

    leave top;
  end;  

  /*判断工位是否已登录(现在先不进行身份判断)*/
  -- call WorkstationIsLogin(GID,DID,GatherTime,login_record_id);
  -- if(login_record_id = -1) then    
  --   set Resp = CONCAT(Resp,'在报工之前，请先刷工卡登录!');
  --   leave top;
  -- end if;
 
  -- select login_workshop_id = l.workshop_id,login_workshop_code = l.workshop_code,login_workshop_name = l.workshop_name,
  --        login_workstation_id = l.workstation_id,login_workstation_code = l.workstation_code,login_worksation_name = l.workstation_name,
  --        operator_id = l.operator_id,employee_id = l.employee_id,employee_name = l.employee_name
  --   from workstation_login l
  -- where record_id = login_record_id;
 
  /*卡校验*/
  call CardNoIsValid(rfid_no,rfid_id);
  if(rfid_id = -1) then
    set Resp = CONCAT(Resp,'非法卡，请联系系统管理员注册卡:',rfid_no);
    leave top;
  end if;
  
  /*车间校验*/
  select production_id = c.production_id, production_code = c.production_code, production_name = c.production_name,
         report_qty = c.qty, workshop_id = c.workshop_id,workshop_code = c.workshop_code,workshop_name = c.workshop_name,
         card_status = c.card_status
    from rfid_card c
   where record_id = rfid_id;

   -- 判断是否是尾数
   

  select workstation_id = w.record_id, workstation_code =  w.org_code, workstation_name = w.org_name, 
        login_workshop_id = w.parent_id,login_workshop_code = w.parent_code, login_workshop_name = w.parent_name
    from work_organization_unit w
    where w.org_type = 'ORG_WORK_STATION'
      and w.rfid_controller_id = GID
      and w.rfid_terminator_id = DID; 

  if(workshop_id <> login_workshop_id) then
      if ((card_status = 1 /*已经报工*/) and  ((select w.nextworkshop_id from work_organization_unit w
        where w.workshop_id = workshop_id) = login_workshop_id)) then
          set is_move = 1; /*如果刷卡工序是卡的下一道工序，则说明本次刷卡是移库*/ 
      else         
         set Resp = CONCAT(Resp,'当前工位是[',login_workshop_name,']','不能刷属于[',workshop_name,']的卡!');
         leave top;
      end if
  end if;
  
  /*检查生产计划*/
  call GetProductionOrder(production_id,GatherTime,prodution_order_id);
  if(production_order_id == -1) then
     set Resp = CONCAT(Resp,'没有下达日期为[', DATE_FORMAT(GatherTime,'%Y/%m/%d'),']的生产计划');
     leave top;
  end if;
  /*获取生产计划信息*/
  select production_order_no = po.order_no 
     from production_order po
    where record_id = production_order_id;
  
  /*进行报工或者处理,开始事务*/
  begin tran;
 
  if( is_move = 1 /*进行报工处理*/ ) then  
    /*生产进度*/
    insert into production_order_progress(
      production_order_id,production_order_no,production_id,production_code,production_name,
      workshop_id,workshop_code,workshop_name,
      workstation_id,workstation_code,workstation_name,
      rfid_terminator_id,rfid_controller_id,
      rfid_card_no,report_type,
      operator_id,employee_id,employee_name,
      create_by_id,create_by_code,create_by_name,create_time,
      update_by_id,update_by_code,update_by_name,update_time,opt_flag,
      report_time,good_qty,bad_qty,report_qty    
    ) values (
      production_order_id,production_order_no,production_id,production_code,production_name,
      workshop_id,workshop_code,workshop_name,
      workstation_id,workstation_code,workstation_name,
      DID,GID,
      rfid_no,0,
      operator_id,employee_id,employee_name,
      operator_id,employee_id,employee_name,Now(),
      null,null,null,null,0,
      DataGatherTime,qty,0,report_qty
    );

    /*更新实际生产数量*/
    select first_workshop_id = p.first_workshop_id 
      from material p
      where p.record_id = production_id; 
    if( first_workshop_id = workshop_id) then
        update production_order
          set qty_actual = ifnul(qty_actual,0) + report_qty
        where record_id = production_order_id ;
    end if;
    
    /*更新完工数量*/
    call GetLastWorkshopId(first_workshop_id,last_workshop_id);
    if (workshop_id = last_workshop_id) then
        update production_order
          set qty_good = ifnul(qty_good,0) + report_qty
        where record_id = production_order_id ;       
    end if;

    /*修改卡的状态为已报工*/
    update rfid_card
      set card_status = 1
      where record_id = rfid_id;

  else /*进行移库处理*/
     /*移库记录*/ 
     insert into production_order_moving(
       production_order_id,production_order_no,production_id,production_code,production_name,
       rfid_no,rfid_card_id,rfid_terminator_id,rfid_controller_group_id,qty,
       operator_id,employee_id,employee_name,moving_time,
       workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,
       create_by_id,create_by_code,create_by_name,create_time,
       update_by_id,update_by_code,update_by_name,update_time,opt_flag
     )values(
       production_order_id,production_order_no,production_id,production_code,production_name,
       rfid_no,rfid_card_id,rfid_terminator_id,rfid_controller_group_id,qty_report,
       operator_id,employee_id,employee_name,GatherTime,
       workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,
       operator_id,employee_id,employee_name,Now(),
       null,null,null,null,0
     );

     /*修改卡的状态为未报工的状态*/
    update rfid_card
      set card_status = 0
      where record_id = rfid_id;

  end if;

  /*提交事务*/
  commit;

  if (is_move = 0) then
    set Resp = CONCAT(Resp,'已报工[',report_qty,']个产品');
  else
    set Resp = CONCAT(Resp,'已移库[',report_qty,']个产品');
  end if;
end;


/*
 刷员工卡： 进行尾数报工
     流程:
          1. 刷工卡
          2. 输入尾数数量
          3. 刷数量卡
          4. 结果表示： 数量卡上的数量 = 原卡数量 - 尾数数量
*/
