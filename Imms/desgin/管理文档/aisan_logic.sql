-- --
-- -- 判断工位机是否已经登录，如果已经登录，则返回登录的记录编号
-- --
-- create procedure WorkstationIsLogin(
--     GID     int,   -- 组号
--     DID     int,   -- 工位机号
--     RecordTime datetime,  --  记录的时间
--     RESULT  bigint output -- 当前登录的记录号
-- )
-- begin
--     declare _today datetime;    
--     set _today = DATE_FORMAT(RecordTime,'%Y/%m/%d');
--     /*
--       员工登录： 上班前必须刷卡。
--           1. 每天必须刷卡，即一旦过了0:00，就要重新刷卡。
--           2. 每隔4个小时必须重新刷卡。
--     */    
--     set RESULT = ifnull((select record_id
--             from workstation_login
--             where rfid_terminator_id = DID
--               and rfid_controller_group_id = GID
--               and login_time >= _today   -- 必须今天
--               and login_time >= DATE_SUB(RecordTime,interval 4 hour)  -- 必须在4个小时以内有登录记录
--             order by login_time
--             limit 1
--     ),-1);
-- end;

--
-- 判断卡的类别
--
create procedure  MES_GetCardType(
 in  CardNo     varchar(20),
 out CardType   int, 
 out CardId     bigint
)
begin
   set CardType = 1;
   set CardId = ifnull((
       select record_id 
         from rfid_card
         where rfid_no = CardNo
          and card_status = 0
        limit 1
   ),-1);

   if(CardId = -1) then  
      set CardId = ifnull((
        select record_id
          from operator
         where employee_card_no = CardNo
         limit 1
      ),-10);
			
      set CardType = if(CardId = -10, -10 ,10);    
   end if;           
end;

--
-- 根据产品编号获取生产计划
--
create procedure MES_GetProductionOrder(
  in  ProductionId   bigint,  -- 产品编号
  in  PlanDate       date,    -- 计划日期
  out RESULT         bigint   -- 记录编号
)
begin   
   set RESULT = ifnull((
     select record_id
       from production_order po
       where po.production_id = ProductionId
         and po.plan_date = PlanDate       
   ),-1);
end;

--
-- 获取某个产品的最后一道工艺车间
--
create procedure MESGetLastWorkshopId(
  in   WorkshopId bigint,
  out  RESULT     bigint
)
begin
    declare LAST_RESULT bigint;

    set RESULT = WorkshopId;
    set LAST_RESULT = RESULT;
    
    set RESULT = ifnull(( select w.next_workshop_id
                     from work_organization_unit w
                    where w.workshop_id = WorkshopId
    ),-1);
		
    while (RESULT <> -1) do
      set LAST_RESULT = RESULT;

      set RESULT = ifnull(( select w.next_workshop_id
                        from work_organization_unit w
                        where w.workshop_id = RESULT
      ),-1);         
    end while;

    set RESULT = LAST_RESULT;    
end;

--
-- 处理工位机数据:目前没有考虑脱机数据
--
create procedure MES_ProcessDeviceData(
  IsNewData int,        
	GID INT,
	DID INT,
	IsOffLineData INT, 		
	DataType int, 				
	DataGatherTime DATETIME,
	DataMakeTime DATETIME,
	StrPara1 varchar(200), 
  Resp  varchar(200)     
)
top:begin  
  declare RfidNo varchar(20); 
  declare CardType,ReportQty int;
  declare CardId,OperatorId bigint;
  declare EmployeeId varchar(20);
  declare EmployeeName varchar(50);
	declare code varchar(5) default '00000';
  declare msg text;
  
  declare exit handler for sqlexception
  begin
    rollback;
		
    get diagnostics condition 1 code = returned_sqlstate, msg = message_text;
		
    set Resp = '|2|1|2|';
    set Resp = CONCAT(Resp,'系统出现异常:',msg,'[',code,'],请联系系统管理员。');
    set Resp = CONCAT(Resp,'210|255|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次    
  end;      
	
	set Resp = '|2|1|2|';

  if(DataType = 1) then  -- 如果是刷卡输入
    set RfidNo = StrPara1;
    call GetCardType(RfidNo,CardType,RfidId);
    if(RfidId = -1) then
      set Resp = CONCAT(Resp,'非法卡，请联系系统管理员注册卡:',RfidNo);      
      set Resp = CONCAT(Resp,'210|255|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次
      leave top;
    end if;    

    if (CardType = 10 ) then -- 如果是员工卡，则新建尾数记录，如果尾数记录已经存在，则更新记录的的相关数据
        if (IsOffLineData = 1 or IsNewData = 0 ) then 
           set Resp = '';
           leave top;
        end if;

        if exists(select * from production_order_progress  where opt_flag = 64 and rfid_terminator_id = DID  and rfid_controller_id = GID) then
          set OperatorId = CardId;
          select EmployeeId = o.employee_id,EmployeeName = o.employee_name
            from operator o 
            where record_id = OperatorId;

          update production_order_progress
            set operator_id = OperatorId, employee_id = EmployeeId, employee_name = EmployeeName,
                create_by_id = OperatorId, create_by_code = EmployeeId, create_by_name = EmployeeName, create_time = Now()
          where opt_flag = 64
            and rfid_terminator_id = DID
            and rfid_controller_id = GID ;
        else
           insert into production_order_progress(operator_id,employee_id,employee_name,
                  rfid_terminator_id,rfid_controller_id,
                  create_by_id,create_by_name,create_time,opt_flag)
            values(OperatorId,EmployeeId,EmployeeName,
                   DID,GID,
                   OperatorId,EmployeeId,EmployeeName,Now(),64);
        end if;

        set Resp = CONCAT(Resp,'请输入尾数数量');      
        set Resp = CONCAT(Resp,'210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 打开键盘，将键盘的模式设置为多键输入，发声一次
    elseif(CardType = 1) then  -- 如果是数量卡        
        call MES_ReportProductionOrder(GID,DID,GatherTime,RfidNo,Resp);
    end if;
  elseif(DataType = 3) then -- 如果是键盘输入 , 则进行尾数报工
        if ((select count(*) from production_order_progress  where opt_flag = 64 and rfid_terminator_id = DID  and rfid_controller_id = GID) = 0) then
          set Resp = CONCAT(Resp,'请先刷员工卡');          
        else
          set ReportQty = cast(StrPara1 as unsigned);
          update production_order_progress
             set report_qty = ReportQty,
                 opt_flag = 65
           where opt_flag = 64 and rfid_terminator_id = DID  and rfid_controller_id = GID;

          set Resp = CONCAT(Resp,'已报[',ReportQty,']');                    
        end if;

        set Resp = CONCAT(Resp,'210|255|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次    
  end if;
end;


--
-- 刷数量卡：进行整数报工或者移库
--

create procedure MES_ReportProductionOrder(
    in RfidNo          varchar(20),
    in RfidId          bigint,    
    in GID              int,
    in DID              int,
    in GatherTime       datetime,     
    out Resp             varchar(500))
top:begin
  declare LoginRecordId,ProductionOrderId,WorkshopId,WorkstationId,ProductionId,OperatorId bigint;
  declare ProductionOrderNo,WorkshopCode,WorkstationCode,ProductionCode,EmployeeId varchar(20);
  declare ProductionName,WorkshopName,WorkstationName,EmployeeName varchar(50);  
  declare ReportQty int;
  declare LoginWorkshopId,LoginWorkstationId bigint;
  declare LoginWorkshopCode,LoginWorkstationCode varchar(20);
  declare LoginWorkshopName,LoginWorkstationName  varchar(50);
  declare LastWorkshopId,FirstWorkshopId  bigint;
  declare IsMove,CardStatus int;  
	declare Code varchar(5) default '00000';
	declare Msg text;
  
  declare exit handler for sqlexception
  begin
    rollback;   
    
    get diagnostics condition 1 Code = returned_sqlstate, Msg = message_text;		
    set Resp = CONCAT('系统出现异常:',Msg,'[',Code,'],请联系系统管理员。');
  end;    
	
	set IsMove = 0;	

  /*车间校验*/
  select ProductionId = c.production_id, ProductionCode = c.production_code, ProductionName = c.production_name,
         ReportQty = c.qty, WorkshopId = c.workshop_id,WorkshopCode = c.workshop_code,WorkshopName = c.workshop_name,
         CardStatus = c.card_status
    from rfid_card c
   where record_id = RfidId;

  select WorkstationId = w.record_id, WorkstationCode =  w.org_code, WorkstationName = w.org_name, 
        LoginWorkshopId = w.parent_id,LoginWorkshopCode = w.parent_code, LoginWorkshopName = w.parent_name
    from work_organization_unit w
    where w.org_type = 'ORG_WORK_STATION'
      and w.rfid_controller_id = GID
      and w.rfid_terminator_id = DID; 

  if(WorkshopId <> LoginWorkshopId) then
      if ((CardStatus = 1 /*已经报工*/) and  ((select w.nextworkshop_id from work_organization_unit w
        where w.workshop_id = WorkshopId) = LoginWorkshopId)) then
          set IsMove = 1; /*如果刷卡工序是卡的下一道工序，则说明本次刷卡是移库*/ 
      else         
         set Resp = CONCAT('当前工位是[',LoginWorkshopName,']','不能刷属于[',WorkshopName,']的卡!');
         leave top;
      end if;
  end if;

  /*检查生产计划*/
  call MES_GetProductionOrder(ProductionId,GatherTime,ProdutionOrderId);
  if(ProductionOrderId = -1) then
     set Resp = CONCAT('没有下达日期为[', DATE_FORMAT(GatherTime,'%Y/%m/%d'),']的生产计划');
     leave top;
  end if;
  /*获取生产计划信息*/
  select ProductionOrderNo = po.order_no 
     from production_order po
    where record_id = ProductionOrderId;

  /*进行报工或者处理,开始事务*/
  start transaction;
 
  if( IsMove = 1 /*进行报工处理*/) then  
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
      ProductionOrderId,ProductionOrderNo,ProductionId,ProductionCode,ProductionName,
      WorkshopId,WorkshopCode,WorkshopName,
      WorkstationId,WorkstationCode,WorkstationName,
      DID,GID,
      FfidNo,0,
      OperatorId,EmployeeId,EmployeeName,
      OperatorId,EmployeeId,EmployeeName,Now(),
      null,null,null,null,0,
      DataGatherTime,ReportQty,0,ReportQty
    );

    /*更新实际生产数量*/
    select FirstWorkshopId = p.first_workshop_id 
      from material p
      where p.record_id = ProductionId; 
    if(FirstWorkshopId = WorkshopId) then
        update production_order
          set qty_actual = ifnull(qty_actual,0) + ReportQty
        where record_id = ProductionOrderId ;
    end if;
    
    /*更新完工数量*/
    call MES_GetLastWorkshopId(FirstWorkshopId,LastWorkshopId);
    if (WorkshopId = LastWorkshopId) then
        update production_order
          set qty_good = ifnull(qty_good,0) + ReportQty
        where record_id = ProductionOrderId ;       
    end if;

    /*修改卡的状态为已报工*/
    update rfid_card
      set card_status = 1
      where record_id = RfidId;

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
       ProductionOrderId,ProductionOrderNo,ProductionId,ProductionCode,ProductionName,
       RfidNo,RfidId,DID,GID,QtyReport,
       OperatorId,EmployeeId,EmployeeName,GatherTime,
       WorkstationId,WorkstationCode,WorkstationName,WorkshopId,WorkshopCode,WorkshopName,
       OperatorId,EmployeeId,EmployeeName,Now(),
       null,null,null,null,0
     );

     /*修改卡的状态为未报工的状态*/
    update rfid_card
      set card_status = 0
      where record_id = RfidId;

  end if;

  /*提交事务*/
  commit;

  if (IsMove = 0) then
    set Resp = CONCAT('已报工[',ReportQty,']个产品');
  else
    set Resp = CONCAT('已移库[',ReportQty,']个产品');
  end if;

end;