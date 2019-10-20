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
   set CardType = 1; -- 数量卡
   set CardId = ifnull((
       select record_id 
         from rfid_card
         where rfid_no = CardNo
          and (card_status = 0 or card_status = 1) -- 未报工或者已报工的卡
        limit 1
   ),-1);

   if(CardId = -1) then   -- 员工卡
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
  in  ProductionId              bigint,  -- 产品编号
  in  PlanDate                  datetime,    -- 计划日期
  out ProductionOrderId         bigint,   -- 记录Id
  out ProductionOrderNo         varchar(20) -- 计划单号
)
begin   
   declare PlanDateBegin,PlanDateEnd date;
   set PlanDateBegin = DATE_FORMAT(PlanDate,'%Y/%m/%d');
   set PlanDateEnd = DATE_ADD(PlanDateBegin,interval 1 day);
   
   select record_id,order_no into ProductionOrderId,ProductionOrderNo
    from production_order po
   where po.production_id = ProductionId
     and po.plan_date >= PlanDateBegin
     and po.plan_date < PlanDateEnd;

   set ProductionOrderId = ifnull(ProductionOrderId,-1);
   set ProductionOrderNo = ifnull(ProductionOrderNo,'');
end;

--
-- 获取某个产品的最后一道工艺车间
--
create procedure MES_GetLastWorkshopId(
  in   WorkshopId bigint,
  out  RESULT     bigint
)
begin
    declare LAST_RESULT bigint;
    declare MAX_TIME,CUR_TIME int;

    set RESULT = WorkshopId;
    set LAST_RESULT = RESULT;
    set MAX_TIME = 1000,CUR_TIME=0;
    
    set RESULT = ifnull(( select w.next_workshop_id
                     from work_organization_unit w
                    where w.record_id = WorkshopId
    ),-1);
		
    while ((RESULT <> -1) and (CUR_TIME < MAX_TIME)) do
      set LAST_RESULT = RESULT;

      set RESULT = ifnull(( select w.next_workshop_id
                        from work_organization_unit w
                        where w.record_id = RESULT
      ),-1);     

      set CUR_TIME = CUR_TIME + 1;    
    end while;

    set RESULT = LAST_RESULT;    

    if(CUR_TIME >= MAX_TIME) then
       set RESULT = -10;
    end if;
end;

--
-- 处理工位机数据:目前没有考虑脱机数据
--
create procedure MES_ProcessDeviceData(
in IsNewData int,        
 in	GID INT,
 in	DID INT,
 in	IsOffLineData INT, 		
 in	DataType int, 				
 in	DataGatherTime DATETIME,
 in	DataMakeTime DATETIME,
 in	StrPara1 varchar(200), 
 out Resp  varchar(4000)     
)
top:begin  
  declare RfidNo varchar(20); 
  declare CardType,ReportQty int;
  declare CardId,OperatorId,WorkshopId,WorkStationId,ProductionId bigint;
  declare EmployeeId,WorkshopCode,WorkstationCode,ProductionCode varchar(20);
  declare EmployeeName,WorkstationName,WorkshopName,ProductionName varchar(50);
	declare code varchar(5) default '00000';
  declare msg text;
 
  declare exit handler for sqlexception
  begin
    get diagnostics condition 1 code = returned_sqlstate, msg = message_text;
		
    set Resp = '|2|1|2';
    set Resp = CONCAT(Resp,'|1|系统出现异常:',msg,'[',code,'],请联系系统管理员。');
    set Resp = CONCAT(Resp,'|210|255|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次    
  end;      
	
	set Resp = '|2|1|2';
  if(DataType = 1) then  -- 如果是刷卡输入
    set RfidNo = StrPara1;
    call MES_GetCardType(RfidNo,CardType,CardId);		

		call MES_Debug(CONCAT('卡的类型是:[',CardType,']'));

    if(CardId = -1) then
      set Resp = CONCAT(Resp,'|1|非法卡，请联系系统管理员注册卡:',RfidNo);      
      set Resp = CONCAT(Resp,'210|255|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次
      leave top;
    end if;    

    if (CardType = 10 ) then -- 如果是员工卡，则新建尾数记录，如果尾数记录已经存在，则更新记录的的相关数据        
        if (IsOffLineData = 1 or IsNewData = 0 ) then 
           set Resp = '';
           leave top;
        end if;
				
				set OperatorId = CardId;				
				select o.employee_id,o.employee_name into EmployeeId,EmployeeName
            from operator o 
            where record_id = OperatorId;			
						
        if exists(select * from production_order_progress  where opt_flag = 64 and rfid_terminator_id = DID  and rfid_controller_id = GID) then          
          update production_order_progress
            set operator_id = OperatorId, employee_id = EmployeeId, employee_name = EmployeeName,
                create_by_id = OperatorId, create_by_code = EmployeeId, create_by_name = EmployeeName, create_time = Now()
          where opt_flag = 64
            and rfid_terminator_id = DID
            and rfid_controller_id = GID ;
        else
					 select record_id,org_code,org_name,parent_id,parent_code,parent_name 
					         into WorkstationId,WorkstationCode,WorkstationName,WorkshopId,WorkshopCode,WorkshopName
						  from work_organization_unit w
							  where w.rfid_controller_id = GID
								  and w.rfid_terminator_id = DID;
									
           insert into production_order_progress(production_order_id,production_order_no,production_id,production_code,production_name,
					        workshop_id,workshop_code,workshop_name,workstation_id,workstation_code,workstation_name,rfid_terminator_id,rfid_controller_id,									
									report_time,report_qty,rfid_card_no,report_type,good_qty,bad_qty,card_qty,operator_id,employee_id,employee_name,
                  create_by_id,create_by_code,create_by_name,create_time,opt_flag)
            values(-1,'',-1,'','',
						       WorkshopId,WorkshopCode,WorkshopName,WorkstationId,WorkstationCode,WorkstationName,DID,GID,                   
									 DataGatherTime,-1,'',1,-1,-1,0,OperatorId,EmployeeId,EmployeeName,
                   OperatorId,EmployeeId,EmployeeName,Now(),64);
        end if;

        set Resp = CONCAT(Resp,'|1|请输入尾数数量');      
        set Resp = CONCAT(Resp,'|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 打开键盘，将键盘的模式设置为多键输入，发声一次
    elseif(CardType = 1) then  -- 如果是数量卡    
        call MES_ReportProductionOrder(RfidNo,CardId,GID,DID,DataGatherTime,Resp);
        set Resp = CONCAT(Resp,'210|255|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次    
    end if;
  elseif(DataType = 3) then -- 如果是键盘输入 , 则进行尾数报工
        if ((select count(*) from production_order_progress  where opt_flag = 64 and rfid_terminator_id = DID  and rfid_controller_id = GID) = 0) then
          set Resp = CONCAT(Resp,'|1|请先刷员工卡');          
        else
          set ReportQty = cast(StrPara1 as unsigned);
          update production_order_progress
             set report_qty = ReportQty,
                 opt_flag = 65
           where opt_flag = 64 and rfid_terminator_id = DID  and rfid_controller_id = GID;

          set Resp = CONCAT(Resp,'|1|已报尾数[',ReportQty,']个,请刷数量卡.');
        end if;

        set Resp = CONCAT(Resp,'210|255|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次    
  end if;
end;

--
-- 刷数量卡：进行整数报工或者移库
--
create procedure MES_ReportProductionOrder(
    in RfidNo           varchar(20),
    in RfidId           bigint,    
    in GID              int,
    in DID              int,
    in GatherTime       datetime,     
    out Resp            varchar(500)
)
top:begin
  declare LoginRecordId,ProductionOrderId,WorkshopId,WorkstationId,ProductionId,OperatorId,SurplusRecordId,PrevProgressRecordId bigint;
  declare ProductionOrderNo,WorkshopCode,WorkstationCode,ProductionCode,EmployeeId varchar(20);
  declare ProductionName,WorkshopName,WorkstationName,EmployeeName varchar(50);  
  declare ReportQty,SurplusQty,CardQty int;
  declare LoginWorkshopId,LoginWorkstationId bigint;
  declare LoginWorkshopCode,LoginWorkstationCode varchar(20);
  declare LoginWorkshopName,LoginWorkstationName  varchar(50);
  declare LastWorkshopId,FirstWorkshopId  bigint;
  declare IsMove,CardStatus int;  
	declare ErrorCode varchar(5) default '00000';
	declare Msg text;
  declare InTran int default 0;
  
  declare exit handler for sqlexception
  begin			
    get diagnostics condition 1 ErrorCode = returned_sqlstate, Msg = message_text;		
    set Resp = CONCAT('系统出现异常:',ifnull(Msg,'NULL'),'[',ifnull(ErrorCode,'00000'),'],请联系系统管理员。');
		
    if (InTran = 1) then		
      rollback;   
    end if;
  end;    
	
	set IsMove = 0,InTran = 0;	

  -- 验证刷的数量卡是否是属于当前车间的卡
  select c.production_id, c.production_code, c.production_name, c.qty, c.workshop_id, c.workshop_code, c.workshop_name,c.card_status
    into ProductionId,ProductionCode,ProductionName,CardQty,WorkshopId,WorkshopCode,WorkshopName,CardStatus
    from rfid_card c
   where record_id = RfidId;
  
  select w.record_id, w.org_code, w.org_name, w.parent_id,w.parent_code, w.parent_name
    into WorkstationId,WorkstationCode,WorkstationName,LoginWorkshopId,LoginWorkshopCode,LoginWorkshopName
    from work_organization_unit w
    where w.org_type = 'ORG_WORK_STATION'
      and w.rfid_controller_id = GID
      and w.rfid_terminator_id = DID; 
	
  -- 如果卡工序不是登录工序
  if(WorkshopId <> LoginWorkshopId) then	    
      if (CardStatus = 1 ) then
           set IsMove = 1; -- 如果刷卡已经报工，则说明本次操作是移库，否则，不能刷其他地方刷卡
      else         
         set Resp = CONCAT('当前工位是[',LoginWorkshopName,']','不能刷属于[',WorkshopName,']的卡!');
         leave top;
      end if;
  elseif(CardStatus = 1 ) then -- 如果卡已经报工，则不能重复报工
      set Resp = CONCAT('本看板已经报工，必须移库以后才可以继续报工！');
      leave top;     
  end if;

  --
  -- 2019.10.18 决定不使用生产计划
  -- -- 检查生产计划	
  -- call MES_GetProductionOrder(ProductionId,GatherTime,ProductionOrderId,ProductionOrderNo);
  -- if(ProductionOrderId = -1) then
  --    set Resp = CONCAT('没有下达日期为[', DATE_FORMAT(GatherTime,'%Y/%m/%d'),']的生产计划');
  --    leave top;
  -- end if;
  --
  set ProductionOrderId = -1,ProductionOrderNo='';
	
	-- 进行报工或者处理,开始事务
  start transaction;
  set InTran = 1;
	
  if(IsMove = 0) then   -- 进行报工处理	  
    -- 获取尾数
    select record_id,report_qty,operator_id,employee_id,employee_name 
		  into SurplusRecordId,SurplusQty,OperatorId,EmployeeId,EmployeeName
      from production_order_progress
    where report_type = 1 and opt_flag = 65
        and workstation_id = WorkstationId
     order by create_time desc
      limit 1;
    set SurplusRecordId = ifnull(SurplusRecordId,-1);
    set SurplusQty = ifnull(SurplusQty,0);
    set ReportQty = CardQty - SurplusQty;
		
		set OperatorId = ifnull(OperatorId,-1),EmployeeId = ifnull(EmployeeId,''),EmployeeName = ifnull(EmployeeName,'');

    -- 生产进度
    insert into production_order_progress(
      production_order_id,production_order_no,production_id,production_code,production_name,
      workshop_id,workshop_code,workshop_name,
      workstation_id,workstation_code,workstation_name,			
      rfid_terminator_id,rfid_controller_id,			
      rfid_card_no,report_type,			
      operator_id,employee_id,employee_name,			
      create_by_id,create_by_code,create_by_name,create_time,			
      update_by_id,update_by_code,update_by_name,update_time,opt_flag,
      report_time,good_qty,bad_qty,report_qty,card_qty    
    ) values (
      ProductionOrderId,ProductionOrderNo,ProductionId,ProductionCode,ProductionName,
      WorkshopId,WorkshopCode,WorkshopName,			
      WorkstationId,WorkstationCode,WorkstationName,			
      DID,GID,			
      RfidNo,0,			
      OperatorId,EmployeeId,EmployeeName,			
      OperatorId,EmployeeId,EmployeeName,Now(),			
      null,null,null,null,if(SurplusRecordId = -1, 0,127),
      GatherTime,ReportQty,0,ReportQty,CardQty
    );

    -- 修改卡的状态为已报工
    update rfid_card
      set card_status = 1
      where record_id = RfidId;

    -- 修改尾数报工记录的状态
    update production_order_progress
       set opt_flag = 66
      where record_id = SurplusRecordId;      

  else -- 进行移库处理	   
		 set OperatorId = -1,EmployeeId = '',EmployeeName = '';
     select report_qty,record_id into ReportQty,PrevProgressRecordId
       from production_order_progress
      where rfid_card_no = RfidNo
      order by create_time desc
      limit 1;    
     set ReportQty = ifnull(ReportQty,0);
		      
     -- 移库记录
     insert into production_moving(
       production_order_id,production_order_no,production_id,production_code,production_name,
       rfid_no,rfid_card_id,rfid_terminator_id,rfid_controller_group_id,qty,
       operator_id,employee_id,employee_name,moving_time,
       workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,
       create_by_id,create_by_code,create_by_name,create_time,
       update_by_id,update_by_code,update_by_name,update_time,opt_flag,prev_progress_record_id
     )values(
       ProductionOrderId,ProductionOrderNo,ProductionId,ProductionCode,ProductionName,
       RfidNo,RfidId,DID,GID,ReportQty,
       OperatorId,EmployeeId,EmployeeName,GatherTime,
       WorkstationId,WorkstationCode,WorkstationName,WorkshopId,WorkshopCode,WorkshopName,
       OperatorId,EmployeeId,EmployeeName,Now(),
       null,null,null,null,0,PrevProgressRecordId
     );

     -- 修改卡的状态为未报工的状态
    update rfid_card
      set card_status = 0
      where record_id = RfidId;

  end if;
  
  commit;

  if (IsMove = 0) then
    set Resp = CONCAT('已报工[',ReportQty,']个产品');
  else
    set Resp = CONCAT('已移库[',ReportQty,']个产品');
  end if;
end;


--
-- 存储过程日志
--
create procedure MES_Debug
(  
  Content varchar(500)
)
begin
  declare LogLevel int;
  declare StrLogLevel varchar(50);

  select parameter_value into StrLogLevel
    from system_parameter
    where parameter_code='LOG_LEVEL'
      and parameter_class_id = 0;
  set LogLevel = cast(ifnull(StrLogLevel,'0') as unsigned);

  if(LogLevel <= 5) then
     insert into system_logs(user_id,log_time,log_type,log_level,log_value)
         values(0,Now(),'SYS_DB',0,Content);
  end if;
end;