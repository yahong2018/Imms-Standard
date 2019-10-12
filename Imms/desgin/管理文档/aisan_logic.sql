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


create procedure ReportProductionOrder(
    rfid_no          varchar(20),
    GID              int,
    DID              int,
    GatherTime       datetime,
    Resp             varchar(500) output
)
top:begin  
  declare login_record_id,rfid_id,production_order_id,workshop_id,workstation_id,production_id,operator_id bigint;
  declare production_order_no,workshop_code,workstation_code,production_code,operator_code varchar(20);
  declare production_name,workshop_name,workstation_name,operator_name varchar(50);  
  declare qty int;
  declare login_workshop_id,login_workstation_id bigint;
  declare login_workshop_code,login_workstation_code varchar(20);
  declare login_workshop_name,login_workstation_name  varchar(50);
   
  set Resp='|2|1|1';

  declare exit handler for sqlexception
  begin
    rollback;
    
    declare code varchar(5) default '00000';
    declare msg text;
    get diagnostics condition 1 code = returned_sqlstate, msg = message_text;
    set Resp = CONCAT(Resp,'系统出现异常:',msg,'[',code,'],请联系系统管理员。');

    leave top;
  end;  

  /*判断工位是否已登录*/
  call WorkstationIsLogin(GID,DID,GatherTime,login_record_id);
  if(login_record_id = -1) then    
    set Resp = CONCAT(Resp,'在报工之前，请先刷工卡登录!');
    leave top;
  end if;
  select login_workshop_id = l.workshop_id,login_workshop_code = l.workshop_code,login_workshop_name = l.workshop_name,
         login_workstation_id = l.workstation_id,login_workstation_code = l.workstation_code,login_worksation_name = l.workstation_name,
         operator_id = l.operator_id,operator_code = l.operator_code,operator_name = l.opertor_name
    from workstation_login l
   where record_id = login_record_id;

  /*卡校验*/
  call CardNoIsValid(rfid_no,rfid_id);
  if(rfid_id = -1) then
    set Resp = CONCAT(Resp,'非法卡，请联系系统管理员注册卡:',rfid_no);
    leave top;
  end if;

  /*获取与卡相关的资料*/  
  select production_id = c.production_id, production_code = c.production_code, production_name = c.production_name,
         qty = c.qty, workshop_id = c.workshop_id,workshop_code = c.workshop_code,workshop_name = c.workshop_name,
    from rfid_card c
   where record_id = rfid_id;
  
  /*车间校验*/
  if(workshop_id <> login_workshop_id) then
     set Resp = CONCAT(Resp,'当前登录工位是[',login_workshop_name,']','不能刷属于[',workshop_name,']的卡!');
     leave top;
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
  
  /*进行报工处理*/
  begin tran;

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
    operator_id,opeator_code,operator_name,
    operator_id,opeator_code,operator_name,Now(),
		null,null,null,null,0,
		DataGatherTime,qty,0,qty
  );
  /*TODO: 更新计划的最新生产车间，和最新的生产数量*/
  

  /*TODO: 修改卡的状态为已报工*/
  commit;

  set Resp = CONCAT(Resp,'已报工[',qty,']');
end;