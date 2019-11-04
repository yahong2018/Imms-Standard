/*
  工位机的业务处理
      1. 验证工位机
      2. 如果是刷卡，则验证卡
      3. 获取session
      4. 根据session_type、expire_time 进行业务处理


  目前需要用到session管理的业务，主要就是工件退还和后工序发卡。
  工件退还流程：
      1. 退件人刷工卡
      2. 系统菜单显示:  1.工件退还    2.发前工程看板      
      3. 退件人 按1键，按确定
      4. 系统提示 请刷看板卡                             0
      5. 退件人刷 看板卡
      6. 系统提示 请输入退还数量                         1 
      7. 退件人 输入退还数量
      8. 系统提示 请接收人刷工卡                         2
      9. 接收人刷工卡
      10. 系统 进行退还处理，提示已成功退还xxx件          3

  Tower卡的收容数，就是筐的数量。
  每刷一次看板卡，就要扣除一次Tower卡的收容数，当筐的数量达到最大数以后，该Tower卡就不可以再报工。
*/

create table workstation_session
(
  record_id              bigint      auto_increment      not null,
  workstation_id         bigint                          not null,
  session_type           int                             not null, -- session的类别: -1. 未知 0. 刷工卡退还工件    1.刷工卡发前工程看板    2. 刷数量卡报工  3.刷数量卡移库   4.刷委外加工卡计数  5.刷委外加工卡外发 6.刷委外加工卡回厂 
  current_step           int                             not null, -- 当前步骤：-1.新建 0.确定session_type  1~250. 当前步骤   253.已过期  254.已取消   255.已完成 
                                                                   --  session_type  的session，只有一个步骤，就是255,因为不需要交互。                                                                   

  operator_id            bigint                          not null, -- 操作员Id
  employee_id            varchar(20)                     not null,
  employee_name          varchar(50)                     not null,
  employee_card_no       varchar(20)                     not null,

  GID                    int                             not null, 
  DID                    int                             not null,  

  create_time            datetime                        not null,
  last_process_time      datetime                        not null,   -- 最后处理时间
  expire_time            datetime                        not null,   -- 过期时间，目前过期时间，就是最后处理时间后的一分钟，如果一分钟内没有任何处理，就默认为过期了。

  primary key(record_Id)
);

create table workstation_session_step
(
  record_id                    bigint       auto_increment     not null,
  workstation_session_id       bigint                          not null,
  step                         int                             not null,
  
  req_time                     datetime                        not null, -- 请求时间
  req_data_type                int                             not null, -- 1. 工卡    2.数量卡   3.委外加工卡    4.键盘输入   
  req_data                     varchar(20)                     not null, -- 请求的数据
    
  resp_data                    varchar(200)                    not null, -- 从服务器返回的结果
  resp_time                    datetime                        not null, -- 返回时间

  primary key(record_id)
);

create table outsource_workstation_bind
(
    record_id               bigint       auto_increment   not null,
    outsource_card_id       bigint                        not null,
    outsource_card_no       varchar(20)                   not null,    
    workstation_id          bigint                        not null,
    workstation_code        varchar(20)                   not null,
    workstation_name        varchar(50)                   not null,
    workshop_id             bigint                        not null,
    workshop_code           varchar(20)                   not null,
    workshop_name           varchar(50)                   not null,
    attach_time             datetime                      not null,
    out_time                datetime                      null,           -- 外发时间
    back_time               datetime                      null,           -- 回厂时间
    bind_status             int                           not null,       -- 1.已绑定    2.已外发    3.已回厂

    primary key(record_id)
);

create table outsource_card_bind(
    record_id               bigint       auto_increment   not null,
    outsource_card_id       bigint                        not null,       -- 外发卡
    outsource_card_no       varchar(20)                   not null,
    qty_report_id           bigint                        not null,       -- 报工记录号
    qty_card_id             bigint                        not null,       -- 数量卡
    qty_card_no             varchar(20)                   not null,
    attach_time             datetime                      not null,       -- 绑定时间
    workstation_bind_id     bigint                        not null,

    primary key(record_id)
);

drop procedure MES_HandleErrorReq;
create procedure MES_HandleErrorReq(
  in     ReqData       varchar(20),
  out    RespData      varchar(200)
)
begin
  set RespData = '|2|1|3';
  set RespData = CONCAT(RespData,'|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
  set RespData = CONCAT(RespData,'|1|无效输入:|0');	 
  set RespData = CONCAT(RespData,'|2|',ReqData,'|0');   
end;

drop procedure MES_SqlExceptionHandler;
create procedure MES_SqlExceptionHandler(
    in StrPara1         varchar(20),    
    in GID              int,
    in DID              int,
    in DataType         int,
    in GatherTime       datetime,   
    in ErrorCode        varchar(5),
    in ErrorMsg         varchar(500),
    out RespMessage     varchar(500)
)
begin
    declare LogMessage varchar(4000);
    declare LogId bigint;
    set LogId = -1;    

    set LogMessage = CONCAT('StrPara1:',StrPara1,'DataType:',DataType,',GID:',GID,',DID:',DID,',GatherTime:',GatherTime,'ErrorCode:',ErrorCode,',ErrorMessage:',ErrorMsg);
    call MES_Debug(LogMessage,LogId);

    set RespMessage = '2|1|3';
    set RespMessage = CONCAT(RespMessage,'|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
    set RespMessage = CONCAT(RespMessage,'|1|系统异常:',LogId,'|0');
    set RespMessage = CONCAT(RespMessage,'|2|请联系管理员|0');	   
end;


drop procedure MES_VerifyWorkstation;
create procedure MES_VerifyWorkstation(
    in GID              int,
    in DID              int,
    out WorkstationId   int,
    out RespMessage varchar(500)
)
top:begin
  select -1,'' into WorkstationId,RespMessage;
	
	if (select count(*)  from work_organization_unit w
    where w.org_type = 'ORG_WORK_STATION'
      and w.rfid_controller_id = GID
      and w.rfid_terminator_id = DID )>1 then
		
		set RespMessage = '2|1|4';
		set RespMessage = CONCAT(RespMessage,'|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
		set RespMessage = CONCAT(RespMessage,'|1|组号:',GID,',机号:',DID,'|0');
		set RespMessage = CONCAT(RespMessage,'|2|工位重复注册|0');			
		set RespMessage = CONCAT(RespMessage,'|3|请联系管理员|0');	

		leave top;
	end if;	  

  select record_id into WorkstationId
    from work_organization_unit w
    where w.org_type = 'ORG_WORK_STATION'
      and w.rfid_controller_id = GID
      and w.rfid_terminator_id = DID;

  if (WorkstationId = -1) then		
		set RespMessage = '2|1|3';
		set RespMessage = CONCAT(RespMessage,'|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
		set RespMessage = CONCAT(RespMessage,'|1|组号:',GID,',机号:',DID,'|0');
		set RespMessage = CONCAT(RespMessage,'|2|请联系管理员注册|0');			
    
	end if;	   
end;


drop procedure MES_GetCardType;
create procedure  MES_GetCardType(
 in  CardNo     varchar(20),
 out CardType   int, 
 out CardId     bigint
)
begin
   select -1,-1 into CardType,CardId;

   select record_id,card_type into CardId,CardType
      from rfid_card
      where rfid_no = CardNo;

   if(CardId = -1) then   -- 员工卡
      select record_id,1 into CardId,CardType 
         from  operator
         where employee_card_no = CardNo;
   end if;           
end;



drop procedure MES_VerifyCard;
create procedure MES_VerifyCard
(
    in  RfidNo      varchar(20),
    out CardType    int,
    out CardId      bigint,
    out RespMessage varchar(500))
begin
    declare LogId bigint;
		
    select -1,-1,'' into CardType,CardId,RespMessage;		
    call MES_GetCardType(RfidNo,CardType,CardId);		
		
		-- call MES_Debug(CONCAT('MES_VerifyCard, CardId:',CardId,',CardType:',CardType),LogId);
    if not CardType in(1,2,3) then
	      set RespMessage=	'2|1|4';
        set RespMessage = CONCAT(RespMessage, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次
        set RespMessage = CONCAT(RespMessage, '|1|卡没注册:|0');            
		    set RespMessage = CONCAT(RespMessage, '|2|',RfidNo,'|0'); 
		    set RespMessage = CONCAT(RespMessage, '|3|请联系管理员注册卡|0');            
    end if;     
end;

drop procedure MES_GetWorkstationSessionId;
create procedure MES_GetWorkstationSessionId(
  in     WorkstationId        bigint,
  out    SessionId            int,
  out    PrevStep             int,
  out    SessionType          int
)
begin
  select -1,-1,-1 into SessionId,PrevStep,SessionType;
  select record_id,current_step,session_type into SessionId,PrevStep,SessionType
     from workstation_session s
     where s.workstation_id = WorkstationId
       and s.current_step <= 250
       and s.expire_time >= Now()
       order by s.create_time desc
     limit 1;
end;

drop procedure MES_CreateNewSession;
create procedure MES_CreateNewSession(
    in   WorkstationId        bigint,
    in   GID                  int,
    in   DID                  int,
    in   ReqDataType          int,          -- 1. 工卡    2.数量卡   3.委外加工卡    4.键盘输入    
    in   ReqData              varchar(20),  -- 卡号或者键盘输入的数字    
    in  CardId                bigint,        -- 如果ReqDataType是 [1,2,3]，则表示卡的Id,
    in   ReqTime              datetime,
    out  SessionId            bigint
)
begin
  declare OperatorId bigint default -1;
  declare EmployeeId,EmployeeCardNo varchar(20) default '';
  declare EmployeeName varchar(50) default '';
  declare CreateTime,LastProcessTime,ExpireTime datetime default Now();
  declare SessionType,CurrentStep int default -1; -- -1表示未知

  set ExpireTime = DATE_ADD(CreateTIme,interval 1 minute);

  if (ReqDataType = 1) then
    select o.record_id,o.employee_id,o.employee_name,ReqData into OperatorId,EmployeeId,EmployeeName,EmployeeCardNo
       from operator o
       where record_id = CardId;
  end if;

  insert into workstation_session(workstation_id,session_type,current_step,
                                  operator_id,employee_id,employee_name,employee_card_no,
                                  GID,DID,create_time,last_process_time,expire_time) 
                           values(WorkstationId,SessionType,CurrentStep,
                                  OperatorId,EmployeeId,EmployeeName,EmployeeCardNo,
                                  GID,DID,CreateTime,LastProcessTime,ExpireTime);
  set SessionId = LAST_INSERT_ID();                                    
end;

drop procedure MES_CreateSessionTypeSelectMenu;
create procedure MES_CreateSessionTypeSelectMenu(  
  out    RespData              varchar(200)
)
begin
  set RespData = '|2|1|4';
  set RespData = CONCAT(RespData,'|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
  set RespData = CONCAT(RespData,'|1|请选择功能：|0');	 
  set RespData = CONCAT(RespData,'|2|1.工件退回|0');	 
  set RespData = CONCAT(RespData,'|3|2.给前工程发卡|0');	 
end;


drop procedure MES_DoBindOutsourceCard;
create procedure MES_DoBindOutsourceCard
(
  in      WorkstationId        bigint,
  in      WorkstationCode      varchar(20),
  in      WorkstationName      varchar(50),
  in      CardId               bigint,
  in      CardNo               varchar(20),
  out     RespData             varchar(200)
)
begin
  insert into outsource_workstation_bind(outsource_card_id,outsource_card_no,workstation_id,workstation_code,workstation_name,attach_time,bind_status)
                                 values (CardId,CardNo,WorkstationId,WorkstationCode,WorkstationName,Now(),1);
																 
  update rfid_card
	   set card_status = 2
	 where record_id = CardId;
  
  set RespData=	'2|1|2';
  set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
  set RespData = CONCAT(RespData,'|1|已绑定外发看板|0');  
end;


drop procedure MES_DoMoveWip;
create procedure MES_DoMoveWip(  
  in    LoginedWorkshopId           bigint,
  in    LoginedWorkshopCode         varchar(20),
  in    LoginedWorkshopName         varchar(50),
  in    CardWorkshopId              bigint,
  in    CardWorkshopCode            varchar(20),
  in    CardWorksopName             varchar(50),
  in    WorkstationBindId    bigint,
  in    WorkstationBindStatus  int,  
  in    GID                  int,
  in    DID                  int,
  in    WorkstationId        bigint,  
  in    WorkstationCode      varchar(20),
  in    WorkstationName      varchar(50),
  in    WocgCode             varchar(20),
  in    ProductionId         bigint,
  in    ProductionCode       varchar(20),
  in    ProductionName       varchar(50),
  in    RfidNo               varchar(20),
  in    CardId               bigint,  
  in    StockQty             int,
  in    CardType             int,
  in    CardStatus           int,
  in    ReqTime              datetime,
  out   RespData             varchar(200)
)
begin  
    declare ShiftId,BindStatus,BasketCount,TotalQty int;
    declare TimeOfOriginWork datetime;	
		
		select '' into RespData;
    
    call MES_GetWorkDayAndShiftId(ReqTime,TimeOfOriginWork,ShiftId);

    -- 移库记录
    if CardType = 2 then
        insert into production_moving(
						production_order_id,production_order_no,production_id,production_code,production_name,
						rfid_no,rfid_card_id,rfid_terminator_id,rfid_controller_group_id,qty,
						operator_id,employee_id,employee_name,time_of_origin,time_of_origin_work,shift_id,
						workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,
						operator_id_from,employee_id_from,employee_name_from,workshop_id_from,workshop_code_from,workshop_name_from,
						create_by_id,create_by_code,create_by_name,create_time,
						update_by_id,update_by_code,update_by_name,update_time,opt_flag,prev_progress_record_id
        )select  
            -1,'',p.production_id,p.production_code,p.production_name,
            RfidNo,CardId,DID,GID,StockQty,
            -1,'','',ReqTime,TimeOfOriginWork,ShiftId,
            WorkstationId,WorkstationCode,WorkstationName,LoginedWorkshopId,LoginedWorkshopCode,LoginedWorkshopName,
            -1,'','',p.workshop_id,p.workshop_code,p.workshop_name,
             1,'SYS','数据采集平台',Now(),			
            null,null,null,null,0,p.record_id
        from production_order_progress p       
        where p.rfid_card_id = CardId 
          order by create_time desc
          limit 1;   
					
				-- 返回结果
				set RespData=	'2|1|2';
				set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次
				set RespData = CONCAT(RespData,'|1|已移库',StockQty,'个|0');  						

    else 
		   	select count(*),sum(qty) into BasketCount,TotalQty
        from production_order_progress p
        where p.record_id in(
            select qty_report_id from outsource_card_bind
              where workstation_bind_id = WorkstationBindId
        );  			  
				
				-- 返回结果
				set RespData=	'2|1|2';
				set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次
				set RespData = CONCAT(RespData,'|1|已移库:',BasketCount,'项,|0');  			
				set RespData = CONCAT(RespData,'|2|共计',TotalQty,'个,|0');  			
				
		    if (WorkstationBindStatus = 2) then -- 如果是外发
						insert into production_moving(
								production_order_id,production_order_no,production_id,production_code,production_name,
								rfid_no,rfid_card_id,rfid_terminator_id,rfid_controller_group_id,qty,
								operator_id,employee_id,employee_name,time_of_origin,time_of_origin_work,shift_id,
								workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,
								operator_id_from,employee_id_from,employee_name_from,workshop_id_from,workshop_code_from,workshop_name_from,
								create_by_id,create_by_code,create_by_name,create_time,
								update_by_id,update_by_code,update_by_name,update_time,opt_flag,prev_progress_record_id
						)select 
								-1,'',p.production_id,p.production_code,p.production_name,
								RfidNo,CardId,DID,GID,p.qty,
								-1,'','',ReqTime,TimeOfOriginWork,ShiftId,
								WorkstationId,WorkstationCode,WorkstationName,WorkshopId,WorkshopCode,WorkshopName,
								-1,'','',p.workshop_id,p.workshop_code,p.workshop_name,
								1,'SYS','数据采集平台',Now(),
								null,null,null,null,0,p.record_id
						from production_order_progress p
						where p.record_id in(
								select qty_report_id from outsource_card_bind
									where workstation_bind_id = WorkstationBindId
						);   
        elseif (WorkstationBindStatus = 3) then -- 如果是外发回厂
						insert into production_order_progress(
							production_order_id,production_order_no,production_id,production_code,production_name,
							workshop_id,workshop_code,workshop_name,
							workstation_id,workstation_code,workstation_name,	wocg_code,		
							rfid_terminator_id,rfid_controller_id,			
							rfid_card_id,rfid_card_no,report_type,			
							operator_id,employee_id,employee_name,			
							create_by_id,create_by_code,create_by_name,create_time,			
							update_by_id,update_by_code,update_by_name,update_time,opt_flag,
							time_of_origin,time_of_origin_work,shift_id,qty,card_qty    
						) select 
									-1,'',p.production_id,p.production_code,p.production_name,
									CardWorkshopId,CardWorkshopCode,CardWorkshopName,
									-1,'','','',
									DID,GID,			
									CardId,RfidNo,0,
									-1,'','',			
									1,'SYS','数据采集平台',Now(),			
									null,null,null,null,0,
									ReqTime,TimeOfOriginWork,ShiftId,p.qty,p.card_qty
						 from production_order_progress p
						 where p.record_id in(
								select qty_report_id from outsource_card_bind
									where workstation_bind_id = WorkstationBindId
						 );           

						insert into production_moving(
								production_order_id,production_order_no,production_id,production_code,production_name,
								rfid_no,rfid_card_id,rfid_terminator_id,rfid_controller_group_id,qty,
								operator_id,employee_id,employee_name,time_of_origin,time_of_origin_work,shift_id,
								workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,
								operator_id_from,employee_id_from,employee_name_from,workshop_id_from,workshop_code_from,workshop_name_from,
								create_by_id,create_by_code,create_by_name,create_time,
								update_by_id,update_by_code,update_by_name,update_time,opt_flag,prev_progress_record_id
						)select 
								-1,'',ProductionId,ProductionCode,ProductionName,
								RfidNo,CardId,DID,GID,p.qty,
								-1,'','',ReqTime,TimeOfOriginWork,ShiftId,
								WorkstationId,WorkstationCode,WorkstationName,LoginedWorkshopId,LoginedWorkshopCode,LoginedWorkshopName,
								-1,'','',CardWorkshopId,CardWorkshopCode,CardWorkshopName,
								1,'SYS','数据采集平台',Now(),
								null,null,null,null,0,p.record_id
						from production_order_progress p
						where p.record_id in(
								select qty_report_id from outsource_card_bind
									where workstation_bind_id = WorkstationBindId
						);
		   end if;					
    end if;

    -- 更新状态和卡的库存数量
    if CardType = 2 then
        update rfid_card
          set card_status = 20  -- 0. 未使用   1. 已派发     10. 已报工   20. 已移库收货         
        where record_id = CardId;        
    else 
        update rfid_card
          set card_status = 20  
        where record_id in(
            select qty_card_id from outsource_card_bind
              where workstation_bind_id = WorkstationBindId          
        );
    end if;

    if CardType = 3 then  
       if WorkstationBindStatus = 1 then   -- 外发
          update outsource_workstation_bind
              set out_time = Now(),
                  bind_status = bind_status + 1
          where record_id = WorkstationBindId;
        else   -- -- 回厂
          update outsource_workstation_bind
              set back_time = Now(),
                  bind_status = bind_status + 1
          where record_id = WorkstationBindId;        
        end if;
    end if;	     
end;

drop procedure MES_GetWorkDayAndShiftId;
create procedure MES_GetWorkDayAndShiftId(
   in  ReqTime              datetime,
   out TimeOfOriginWork     datetime,
   out ShiftId              int
)
begin
  declare ReqYear,ReqMonth,ReqDay,ReqHour,ReqMinute int;
  -- 设置工作班次和工作日
  select Year(ReqTime),Month(ReqTime),Day(ReqTime),Hour(ReqTime),Minute(ReqTime)   into ReqYear,ReqMonth,ReqDay,ReqHour,ReqMinute;
  set TimeOfOriginWork = ReqTime;
	set ShiftId = 0;
	
  if (ReqHour <= 8) and (ReqMinute<30) then
    set TimeOfOriginWork = date_add(ReqTime, interval -1 day);    
    set ShiftId = 1;
  end if;
  if (ReqHour > 20) then
    set ShiftId = 1;
  end if;
  select Year(TimeOfOriginWork),Month(TimeOfOriginWork),Day(TimeOfOriginWork)   into ReqYear,ReqMonth,ReqDay;    
  set TimeOfOriginWork = cast(CONCAT(ReqYear,'/',ReqMonth,'/',ReqDay) as datetime);   
end;

drop procedure MES_DoReportWip;
create procedure MES_DoReportWip(  
  in    WorkshopId           bigint,
  in    WorkshopCode         varchar(20),
  in    WorkshopName         varchar(50),
  in    MoveCardType         int,
  in    MoveCardId           bigint,
  in    MoveCardNo           varchar(20),
  in    WorkstationBindId    bigint,
  in    GID                  int,
  in    DID                  int,
  in    WorkstationId        bigint,  
  in    WorkstationCode      varchar(20),
  in    WorkstationName      varchar(50),
  in    WocgCode             varchar(20),
  in    ProductionId         bigint,
  in    ProductionCode       varchar(20),
  in    ProductionName       varchar(50),
  in    RfidNo               varchar(20),
  in    CardId               bigint,
  in    IssueQty             int,
  in    StockQty             int,
  in    CardType             int,
  in    CardStatus           int,
  in    ReqTime              datetime,
  out   RespData             varchar(200)
)
begin  
  declare ReportQty,ShiftId int;
  declare TimeOfOriginWork datetime;
  declare ReportRecordId bigint;
	
	select '' into RespData;

  set ReportQty = IssueQty - StockQty; 
  call MES_GetWorkDayAndShiftId(ReqTime,TimeOfOriginWork,ShiftId);
    
  -- 生产进度
  insert into production_order_progress(
    production_order_id,production_order_no,production_id,production_code,production_name,
    workshop_id,workshop_code,workshop_name,
    workstation_id,workstation_code,workstation_name,	wocg_code,		
    rfid_terminator_id,rfid_controller_id,			
    rfid_card_id,rfid_card_no,report_type,			
    operator_id,employee_id,employee_name,			
    create_by_id,create_by_code,create_by_name,create_time,			
    update_by_id,update_by_code,update_by_name,update_time,opt_flag,
    time_of_origin,time_of_origin_work,shift_id,qty,card_qty    
  ) values (
    -1,'',ProductionId,ProductionCode,ProductionName,
    WorkshopId,WorkshopCode,WorkshopName,			
    WorkstationId,WorkstationCode,WorkstationName,WocgCode,
    DID,GID,			
    CardId,RfidNo,0,
    -1,'','',			
    1,'SYS','数据采集平台',Now(),			
    null,null,null,null,0,
    ReqTime,TimeOfOriginWork,ShiftId,ReportQty,IssueQty
  );
  set ReportRecordId = LAST_INSERT_ID();
  
  -- 更新状态和卡的库存数量
  update rfid_card
    set card_status = 10  -- 0. 未使用   1. 已派发     10. 已报工   20. 已移库收货 
       ,stock_qty = IssueQty 
  where record_id = CardId;

  if MoveCardType = 3 then  -- 如果是以外发卡的方式移动，则更新本工位外发卡的库存数与状态
      insert into outsource_card_bind(outsource_card_id,outsource_card_no,qty_report_id, qty_card_id,qty_card_no,attach_time,workstation_bind_id)
                              values (MoveCardId,MoveCardNo,ReportRecordId,CardId,CardNo,Now(),WorkstationBindId);     
      update rfid_card
        set stock_qty = stock_qty + 1,
            card_status = 10
      where card_id = MoveCardId;
  end if;

  -- 返回结果
	set RespData=	'2|1|2';
	set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次
  set RespData = CONCAT(RespData,'|1|已报工',ReportQty,'个|0');  	 
end;

drop procedure MES_CheckCardAndWorkstation;
create procedure MES_CheckCardAndWorkstation(
  in   WorkstationId             int,
  in   CardStatus                int,
  in   CardType                  int,
  in   CardProcedureIndex        int,
  in   LoginedProcedureIndex     int,
  in   LoginedPrevProcedureIndex int,
  in   WorkshopName              varchar(50),
  in   NextWorkshopName          varchar(50),
  in   WorkshopMoveCardType      int,
  in   MoveCardId                bigint,
  in   WorkstationBindStatus     int,
  in   BindWorkshopId            int,
	in   BindWorkshopCode          varchar(20),
	in   BindWorkshopName	         varchar(50),
  in   CheckType                 int,   -- 检查类型: 0. 报工、移库  1.绑定  2.退库   3.派发
  out  RespData                  varchar(200)
)
begin
   select '' into RespData;
   if (CheckType = 1) and (CardType = 3) and (WorkshopMoveCardType <> 3) then
      set RespData=	'2|1|3';
      set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
      set RespData = CONCAT(RespData,'|1|不可以在本车间|0');
      set RespData = CONCAT(RespData,'|2|绑定外发看板|0');      
  elseif (CheckType = 3) and not CardStatus in (0,20) then
      set RespData=	'2|1|4';
      set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
      set RespData = CONCAT(RespData,'|1|本看板已经派发|0');
      set RespData = CONCAT(RespData,'|2|报工移库之前|0');
      set RespData = CONCAT(RespData,'|3|不可以重复派发|0');      
  elseif (CardStatus = 0 and CheckType <> 3) or (CardStatus = 20 and CheckType <> 2 ) then
      set RespData=	'2|1|3';
      set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
      set RespData = CONCAT(RespData,'|1|本看板没有派发,|0');
			set RespData = CONCAT(RespData,'|2|或者已经移库.|0');      
  elseif (CheckType = 2 ) then
      if  (CardStatus <> 20)  then
          set RespData=	'2|1|3';
          set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
          set RespData = CONCAT(RespData,'|1|看板还没有移库|0');
          set RespData = CONCAT(RespData,'|2|不需要退还|0');      
      elseif (CardProcedureIndex <> LoginedProcedureIndex) and (CardProcedureIndex <> LoginedPrevProcedureIndex) then
          set RespData=	'2|1|3';
          set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
          set RespData = CONCAT(RespData,'|1|退还操作只能在|0');
          set RespData = CONCAT(RespData,'|2|上下车间操作|0');
      end if;
  elseif (CheckType = 0)  and (CardType = 3) and (WorkstationBindStatus >= 3)then
      set RespData=	'2|1|3';
      set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
      set RespData = CONCAT(RespData,'|1|外发看板已回厂,|0');
      set RespData = CONCAT(RespData,'|2|派发以后才可以操作|0');           
  elseif (CheckType = 0) then 
      -- 数量卡不可以重复报工，只可以在上下工序之间流动。
      -- 外发卡每次刷卡，自动将该卡转入下一个处理流程；暂时外发卡不检查车间位置。
      if (CardStatus in(1,2))  then
			    if (WorkshopMoveCardType = 3) and (MoveCardId = -1)  and (CardType = 2)  then
							set RespData=	'2|1|2';
							set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|5|150');
							set RespData = CONCAT(RespData,'|1|先刷外发卡再报工|0');
          elseif (CardProcedureIndex <> LoginedProcedureIndex)  and (CardType = 2) and (CardStatus = 1)  then
							set RespData=	'2|1|3';
							set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
							set RespData = CONCAT(RespData,'|1|本看板可报工车间:|0');
							set RespData = CONCAT(RespData,'|2|',WorkshopName,'|0');	  
					elseif (CardProcedureIndex <> LoginedPrevProcedureIndex) and (CardType = 2) and (CardStatus = 2) then -- 退件以后再次移库
              if NextWorkshopName <> '' then -- 半成品车间
                  set RespData=	'2|1|3';
                  set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');      
                  set RespData = CONCAT(RespData,'|1|本看板可移库车间:|0');
                  set RespData = CONCAT(RespData,'|2|',NextWorkshopName,'|0');
              else  -- 完成品车间(最后一道工序的车间)
                  set RespData=	'2|1|3';
                  set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');      
                  set RespData = CONCAT(RespData,'|1|本看板只可以由工务|0');          
                  set RespData = CONCAT(RespData,'|2|进行完成品移库|0');          
              end if;  
					end if;
      elseif (CardStatus = 10) and (CardType = 2) then           
			    if (CardProcedureIndex = LoginedProcedureIndex)  then					    
									set RespData=	'2|1|3';
									set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
									set RespData = CONCAT(RespData,'|1|本看板已经报工|0');
									set RespData = CONCAT(RespData,'|2|请移库后再报工|0');								
		      elseif(CardProcedureIndex = LoginedPrevProcedureIndex) and (WorkshopMoveCardType = 3) then					    
              set RespData=	'2|1|5';
              set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|5|150');
              set RespData = CONCAT(RespData,'|1|外发前工程的看板|0'); 
              set RespData = CONCAT(RespData,'|2|不可以进行移库操作;|0'); 
              set RespData = CONCAT(RespData,'|3|只有外发看板才可以|0'); 
              set RespData = CONCAT(RespData,'|4|进行移库操作.|0'); 
          elseif (CardProcedureIndex <> LoginedPrevProcedureIndex) then -- 不同车间刷卡
              if NextWorkshopName <> '' then -- 半成品车间
                  set RespData=	'2|1|3';
                  set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');      
                  set RespData = CONCAT(RespData,'|1|本看板可移库车间:|0');
                  set RespData = CONCAT(RespData,'|2|',NextWorkshopName,'|0');
              else  -- 完成品车间(最后一道工序的车间)
                  set RespData=	'2|1|3';
                  set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');      
                  set RespData = CONCAT(RespData,'|1|本看板只可以由工务|0');          
                  set RespData = CONCAT(RespData,'|2|进行完成品移库|0');          
              end if;   
          end if;			    
      end if;    
  end if;	 
end;


drop procedure MES_ProcessWipCardInput;
create procedure MES_ProcessWipCardInput(   
   in     WorkstationId       bigint,
   in     GID                 int,
   in     DID                 int,
   in     RfidNo              varchar(20),
   in     CardId              bigint,
   in     ReqTime             datetime,
   out    RespData            varchar(200)
)
top:begin    
  declare CardWorkshopId,LoginedWorkshopId,ProductionId,MoveCardId,WorkstationBindId,BindWorkshopId,LogId  bigint default -1;
  declare CardStatus,CardType,CardProcedureIndex,LoginedProcedureIndex,LoginedPrevProcedureIndex,WorkshopMoveCardType,IssueQty,StockQty int default -1;
  declare ProductionCode,LoginedWorkshopCode,CardWorkshopCode,WorkstationCode,WocgCode,BindWorkshopCode,NextWorkshopCode,MoveCardNo varchar(20);
  declare ProductionName,LoginedWorkshopName,CardWorkshopName,WorkstationName,NextWorkshopName,BindWorkshopName varchar(50);
  declare ProcessIndex,CheckType,WorkstationBindStatus int default 1;
	
	select '' into RespData;
  
  select w.record_id,w.operation_index,c.card_type,c.card_status,c.issue_qty,c.stock_qty,c.production_id,c.production_code,c.production_name,c.workshop_code,c.workshop_name
    into CardWorkshopId,CardProcedureIndex,CardType,CardStatus,IssueQty,StockQty,ProductionId,ProductionCode,ProductionName,CardWorkshopCode,CardWorkshopName
  from work_organization_unit  w join rfid_card  c on w.record_id = c.workshop_id
  where c.record_id =  CardId;
    
  select wss.record_id,wss.org_code,wss.org_name,wss.operation_index,wss.prev_operation_index,wss.move_card_type,wst.org_code,wst.org_name,wst.wocg_code
    into LoginedWorkshopId,LoginedWorkshopCode,LoginedWorkshopName,LoginedProcedureIndex,LoginedPrevProcedureIndex,WorkshopMoveCardType,WorkstationCode,WorkstationName,WocgCode
  from work_organization_unit wst join work_organization_unit wss on wst.parent_id = wss.record_id
  where wst.record_id = WorkstationId;

  select w.org_code,w.org_name into NextWorkshopCode,NextWorkshopName
    from work_organization_unit w
    where w.prev_operation_index = CardProcedureIndex;
  
  select b.outsource_card_id,b.outsource_card_no,b.record_id,b.bind_status,b.workshop_id,b.workshop_code,b.workshop_name
  	into MoveCardId,MoveCardNo,WorkstationBindId,WorkstationBindStatus,BindWorkshopId,BindWorkshopCode,BindWorkshopName
   from outsource_workstation_bind b
   where b.workstation_id = WorkstationId
  order by attach_time desc
   limit 1;

  -- 检查类型: 0. 报工、移库  1.绑定  2.退库   3.派发
  if CardType = 3 and CardStatus in(1,2,20) then
     set CheckType = 1;
  else 
     set CheckType = 0; 
  end if;
	-- call MES_Debug(CONCAT('MES_CheckCardAndWorkstation CardType:',CardType,',CardStatus:',CardStatus,',CheckType:',CheckType,',CardProcedureIndex:',CardProcedureIndex,',LoginedProcedureIndex:',LoginedProcedureIndex), LogId);
	
  call MES_CheckCardAndWorkstation(WorkstationId,CardStatus,CardType,CardProcedureIndex,LoginedProcedureIndex,LoginedPrevProcedureIndex,CardWorkshopName,NextWorkshopName,WorkshopMoveCardType,MoveCardId,WorkstationBindStatus,BindWorkshopId,BindWorkshopCode,BindWorkshopName,CheckType,RespData);
  if( RespData <> '') then
      leave top;
  end if;
  
  if (CardStatus = 1) then  
      if CardType = 2 then  -- 工程内报工    
          call MES_DoReportWip(LoginedWorkshopId,LoginedWorkshopCode,LoginedWorkshopName,WorkshopMoveCardType,MoveCardId,MoveCardNo,WorkstationBindId,GID,DID,WorkstationId,WorkstationCode,WorkstationName,WocgCode,ProductionId,ProductionCode,ProductionName,RfidNo,CardId,IssueQty,StockQty,CardType,CardStatus,ReqTime,RespData);       					
      elseif CardType = 3 then  -- 外发卡绑定
          call MES_DoBindOutsourceCard(WorkstationId,WorkstationCode,WorkstationName,CardId,CardNo,RespData);
					call MES_Debug('MES_DoBindOutsourceCard',LogId);
      end if;
  elseif(CardStatus = 2 ) and (LoginedProcedureIndex = CardProcedureIndex) and (CardType = 2) then -- 补数
      call MES_DoReportWip(LoginedWorkshopId,LoginedWorkshopCode,LoginedWorkshopName,WorkshopMoveCardType,MoveCardId,MoveCardNo,WorkstationBindId,GID,DID,WorkstationId,WorkstationCode,WorkstationName,WocgCode,ProductionId,ProductionCode,ProductionName,RfidNo,CardId,IssueQty,StockQty,CardType,CardStatus,ReqTime,RespData);       						    
	else -- 移库
      call MES_DoMoveWip(LoginedWorkshopId,LoginedWorkshopCode,LoginedWorkshopName,CardWorkshopId,CardWorkshopCode,CardWorkshopName,WorkstationBindId,WorkstationBindStatus,GID,DID,WorkstationId,WorkstationCode,WorkstationName,WocgCode,ProductionId,ProductionCode,ProductionName,RfidNo,CardId,StockQty,CardType,CardStatus,ReqTime,RespData);      	
  end if;	 
end;

drop procedure MES_ProcessReturnWipBackToPrevProcedure;
create procedure MES_ProcessReturnWipBackToPrevProcedure
(
    in SessionId     bigint,
		in CurrentStep   int,
		in WorkstationId bigint,
		in GID           int,
		in DID           int,
		in ReqDataType   int,
		in ReqData       varchar(20),
		in CardId        bigint,
		in ReqTime       datetime,
		out RespData     varchar(200)
)
begin
    declare Success int;
    select -1,'' into Success,RespData;		
		
    if (CurrentStep = 0) then  
        call MES_ProcessReturnWipBackToPrevProcedure_0(Success,RespData);		
	  elseif CurrentStep = 1 then --  保存看板
		    call MES_ProcessReturnWipBackToPrevProcedure_1(ReqDataType,CardId,Success,RespData);		
		elseif CurrentStep = 2 then -- 保存退还数量
        call MES_ProcessReturnWipBackToPrevProcedure_2(SessionId,CurrentStep,ReqDataType,ReqData,Success,RespData);
		elseif CurrentStep = 3 then -- 保存接收人工卡
		    call MES_ProcessReturnWipBackToPrevProcedure_3(SessionId,CurrentStep,ReqDataType,ReqData,CardId,GID,DID,WorkstationId,ReqTime,Success,RespData);
		end if;
		
		if( Success = 0 ) then
				if CurrentStep = 3 then
					 update workstation_session
						 set current_step = 255	
					 where record_id = SessionId;
				else 
					 update workstation_session
						 set current_step = CurrentStep
					 where record_id = SessionId;		
				end if;		
		end if;
end;

drop procedure MES_ProcessReturnWipBackToPrevProcedure_3;
create procedure MES_ProcessReturnWipBackToPrevProcedure_3
(    
    in SessionId     bigint,
		in CurrentStep   int,				
		in ReqDataType   int,
		in ReqData       varchar(20),
		in CardId        bigint,
		in GID           int,
		in DID           int,
		in WorkstationId bigint,
		in ReqTime       datetime,
		out Success      int,
		out RespData     varchar(200)
)
top:begin
    -- 接收人工卡确认
    -- 1. 必须是工卡
	  -- 2. 接收人和退还人不能是同一个人 
	  declare CreatorOperatorId,ReceiveOperatorId,LogId bigint;
	  declare CreatorCardNo,ReceiveCardNo,CreatorEmployeeId,TargetCardNo,ReceiveEmployeeId,WorkstationCode varchar(20);
	  declare CreatorEmployeeName,ReceiveEmployeeName,WorkstationName varchar(50);
	  declare BackQty,ShiftId int;
	  declare TimeOfOriginWork datetime;
   	 
	  select -1,'',ReqData into Success,RespData,ReceiveCardNo;
	 
	  if ReqDataType <> 1 then
			 set RespData=	'2|1|2';
			 set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
			 set RespData = CONCAT(RespData,'|1|请接收人刷工卡确认|0');				    
			 
			 leave top;
	  end if;
					 
	  select o.record_id,o.employee_id,o.employee_name into ReceiveOperatorId,ReceiveEmployeeId,ReceiveEmployeeName
	  	from operator  o
			where o.employee_card_no = ReceiveCardNo;	 
	  	  
	  select operator_id,employee_id,employee_name into CreatorOperatorId,CreatorEmployeeId,CreatorEmployeeName
	   from workstation_session 
		 where record_id = SessionId;
	   		 
	  if(CreatorOperatorId = ReceiveOperatorId) then
			 set RespData=	'2|1|3';
			 set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
			 set RespData = CONCAT(RespData,'|1|接收人和退还人|0');				    
			 set RespData = CONCAT(RespData,'|2|不能是同一个人|0');				    
			 
       leave top;	     
	  end if;
	 	 
	 
	  select cast(s.req_data as UNSIGNED) into BackQty
	    from workstation_session_step  s 
		  where s.workstation_session_id = SessionId
			  and s.step = 2;	 
    		
	  select s.req_data into TargetCardNo
	    from workstation_session_step  s 
		  where s.workstation_session_id = SessionId
			  and s.step = 1;
			  			
		select org_code,org_name into WorkstationCode,WorkstationName
		   from work_organization_unit
			 where record_id = WorkstationId;
	  	 			
		/**
			 库存 = 移入数 + 报工数 - 移出数 
		*/	 	 
		call MES_GetWorkDayAndShiftId(ReqTime,TimeOfOriginWork,ShiftId);
		insert into production_moving(
			production_order_id,production_order_no,production_id,production_code,production_name,
			rfid_no,rfid_card_id,rfid_terminator_id,rfid_controller_group_id,qty,
			operator_id,employee_id,employee_name,time_of_origin,time_of_origin_work,shift_id,
			workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,
			operator_id_from,employee_id_from,employee_name_from,workshop_id_from,workshop_code_from,workshop_name_from,
			create_by_id,create_by_code,create_by_name,create_time,
			update_by_id,update_by_code,update_by_name,update_time,opt_flag,prev_progress_record_id
		)select 
			m.production_order_id,m.production_order_no,m.production_id,m.production_code,m.production_name,
			m.rfid_no,m.rfid_card_id,DID,GID,BackQty,
			ReceiveOperatorId,ReceiveEmployeeId,ReceiveEmployeeName,m.time_of_origin,TimeOfOriginWork,ShiftId,
			WorkstationId,WorkstationCode,WorkstationName,m.workshop_id_from,m.workshop_code_from,m.workshop_name_from,
			CreatorOperatorId,CreatorEmployeeId,CreatorEmployeeName,m.workshop_id,m.workshop_code,m.workshop_name, -- 移入移出部门倒过来
			m.create_by_id,m.create_by_code,m.create_by_name,Now(),
			m.update_by_id,m.update_by_code,m.update_by_name,m.update_time,m.opt_flag,m.record_id
	 	from production_moving m
	 	 where m.rfid_no = TargetCardNo
	 	  order by create_time desc 
		  limit 1;			
					
		update rfid_card
		  set stock_qty = BackQty,
			    card_status = 2
			where rfid_no = TargetCardNo;			
	
	 set RespData=	'2|1|2';
	 set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
	 set RespData = CONCAT(RespData,'|1|已退还',BackQty,'个工件|0');				
   
	 set Success = 0;
end;



drop procedure MES_ProcessReturnWipBackToPrevProcedure_2;
create procedure MES_ProcessReturnWipBackToPrevProcedure_2(
    in SessionId     bigint,
		in CurrentStep   int,				
		in ReqDataType   int,
		in ReqData       varchar(20),
		out Success      int,
		out RespData     varchar(200)
)
top:begin
   --  校验数量，退还的数量不能大于移库的数量	 
	 declare RfidNo varchar(20);
	 declare IssueQty,StockQty,BackQty int;	 
	 
	 select -1,'' into Success,RespData;
	 
	 if (ReqDataType <> 4) or (ReqData = '') then
				set RespData=	'2|1|2';
				set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
				set RespData = CONCAT(RespData,'|1|请输入退还数量|0');				    
				
				leave top;
	 end if;
	 
	 set BackQty = cast(ReqData as UNSIGNED);	
	 select s.req_data,c.issue_qty,c.stock_qty into RfidNo,IssueQty,StockQty
	    from workstation_session_step  s join rfid_card c on s.req_data = c.rfid_no
		  where s.workstation_session_id = SessionId
			  and s.step = 1;
		
	 if (BackQty > StockQty) then
				set RespData=	'2|1|3';
				set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
				set RespData = CONCAT(RespData,'|1|退还数量必须|0');				    
				set RespData = CONCAT(RespData,'|2|小于等于移库数量|0');				    
				
				leave top;	 
	 end if;
	 	 
   set RespData=	'2|1|2';
	 set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
	 set RespData = CONCAT(RespData,'|1|请接收人刷工卡确认|0');				    	 
	 
	 set Success = 0;
end;



drop procedure MES_ProcessReturnWipBackToPrevProcedure_1;
create procedure MES_ProcessReturnWipBackToPrevProcedure_1
(    
		in ReqDataType   int,	
		in CardId        bigint,		
		out Success      int,
		out RespData     varchar(200)   
)
top:begin
    -- 1.校验数量卡
		-- 2.提示输入退还数量
		
		declare CardStatus int default -1;
		select -1,'' into Success,RespData;		
		
		if(ReqDataType <> 2) then
		   call MES_ProcessReturnWipBackToPrevProcedure_0(Success,RespData);
		   leave top;
		end if;
		
		select card_status into CardStatus
		  from rfid_card
			where record_id = CardId;
		
		if(CardStatus<>20) then
				set RespData=	'2|1|3';
				set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
				set RespData = CONCAT(RespData,'|1|只有移库了的卡|0');					   
				set RespData = CONCAT(RespData,'|2|才可以退数.|0');					   
				
				leave top;
		end if;	
		
		set RespData=	'2|1|2';
		set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
		set RespData = CONCAT(RespData,'|1|请输入退还数量|0');			
		
		set Success = 0;
end;


drop procedure MES_ProcessReturnWipBackToPrevProcedure_0;
create procedure MES_ProcessReturnWipBackToPrevProcedure_0(
    out Success      int,
		out RespData     varchar(200)
)
begin
		set RespData=	'2|1|2';
		set RespData = CONCAT(RespData, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
		set RespData = CONCAT(RespData,'|1|请刷看板|0');		
		
		set Success = 0;
end;


drop procedure MES_ProcessIssuePlanToPrevProcedure;
create procedure MES_ProcessIssuePlanToPrevProcedure(
    in SessionId     bigint,
		in CurrentStep   int,
		in WorkstationId bigint,
		in GID           int,
		in DID           int,
		in ReqDataType   int,
		in ReqData       varchar(20),
		in CardId        bigint,
		in ReqTime       datetime,
		out RespData     varchar(200)
)
begin
   select '给前工程发看板 第0 步' into RespData;		
end;


drop procedure MES_ProcessSessionStep;
create procedure MES_ProcessSessionStep(
    in   SessionId            bigint,       -- Session的Id
    in   SessionType          int,          
    inout  PrevStep             int,          -- 前一步骤
    in   WorkstationId        bigint,       -- 工位
    in   GID                  int,
    in   DID                  int,
    in   ReqDataType          int,          -- 1. 工卡    2.数量卡   3.委外加工卡    4.键盘输入    
    in   ReqData              varchar(20),  -- 卡号或者键盘输入的数字    
    in   CardId               bigint,        -- 如果ReqDataType是 [1,2,3]，则表示卡的Id,
    in   ReqTime              datetime,        
    out  RespData             varchar(200)
)
top:begin  
   declare SessionStepId,LogId bigint;
     
	 select '' into RespData;	
	
   -- 如果是新Session,就要确定Session的类别
   if (PrevStep = -1) then
			if ReqDataType = 1 then -- 如果是刷工卡，则提示菜单 1.退件  2.发前工程看板       
					call MES_CreateSessionTypeSelectMenu(RespData);			
					leave top;
			elseif (ReqDataType in (2,3)) then
					update workstation_session  set current_step = 255 where record_id = SessionId; -- 这些Session只有一步      
					call MES_ProcessWipCardInput(WorkstationId,GID,DID,ReqData,CardId,ReqTime,RespData);   
					set PrevStep = 0;
					
					leave top;
			elseif (ReqDataType = 4) then			    
					if ReqData in ('1','2') then -- 确定Session类型
						 if ReqData = '1' then
								 set SessionType = 0;
						 elseif ReqData = '2' then
								 set SessionType = 1;
						 end if;
						 
						 update workstation_session  
						    set current_step = 0,
								    session_type = SessionType 
							where record_id = SessionId;       					 													
					end if;
			end if;
	  end if;
  
	  set PrevStep = PrevStep + 1;
  	-- 如果已经确定了session的类别，则根据PrevStep来确定本次的行动
    if SessionType = 0 then   -- 如果是"退件"		 
        call MES_ProcessReturnWipBackToPrevProcedure(SessionId,PrevStep,WorkstationId,GID,DID,ReqDataType,ReqData,CardId,ReqTime,RespData);				
    elseif SessionType = 1 then -- 如果是"给前工程发卡"
       call MES_ProcessIssuePlanToPrevProcedure(SessionId,PrevStep,WorkstationId,GID,DID,ReqDataType,ReqData,CardId,ReqTime,RespData);
			 call MES_Debug('MES_ProcessIssuePlanToPrevProcedure', LogId);
    end if;  
end;


drop procedure MES_ProcessSession;
create procedure MES_ProcessSession(
    in   WorkstationId        bigint,
    in   GID                  int,
    in   DID                  int,
    in   ReqDataType          int,          -- 1. 工卡    2.数量卡   3.委外加工卡    4.键盘输入    
    in   ReqData              varchar(20),  -- 卡号或者键盘输入的数字    
    in   CardId               bigint,        -- 如果ReqDataType是 [1,2,3]，则表示卡的Id,
    in   ReqTime              datetime,       
    out  RespData             varchar(200)
) 
top:begin
  declare PrevStep,Step int default 0;  
  declare SessionType int default -1;
	declare LogId,SessionId  bigint;

  select -1,-1,'' into SessionId,Step,RespData;	
	
  call MES_GetWorkstationSessionId(WorkstationId,SessionId,PrevStep,SessionType);	
  if (SessionId = -1) and ReqDataType in(1,2,3) then    
      call MES_CreateNewSession(WorkstationId,ReqDataType,GID,DID,ReqData,CardId,ReqTime,SessionId);			
      set PrevStep = -1;    
  end if;  
  
	if (SessionId <> -1) then
      call MES_ProcessSessionStep(SessionId,SessionType,PrevStep,WorkstationId,GID,DID,ReqDataType,ReqData,CardId,ReqTime,RespData); 				
	    
			insert into workstation_session_step(workstation_session_id,step,req_time,req_data_type,req_data,resp_data,resp_time)
													 values(SessionId,PrevStep,ReqTime,ReqDataType,ReqData,RespData,Now());    				
	end if;
		
  if(RespData = '') then
    call MES_HandleErrorReq(ReqData,RespData);
  end if; 
end;



drop procedure MES_ProcessDeviceDataEx;
create procedure MES_ProcessDeviceDataEx( 
 in	GID            int,
 in	DID            int,
 in	DataType       int, 				
 in	DataGatherTime datetime,
 in	DataMakeTime   datetime,
 in	StrPara1       varchar(20),  
 out RespData      varchar(200)
)
top:begin    
  declare WorkstationId,CardId,LogId bigint default -1;
  declare CardType,ReqDataType int default -1;

	declare ErroCode varchar(5) default '00000';
  declare ErrorMsg text;	
	
  declare exit handler for sqlexception
  begin
    get diagnostics condition 1 ErroCode = returned_sqlstate, ErrorMsg = message_text;		
		
    call MES_SqlExceptionHandler(StrPara1,DataType,GID,DID,DataGatherTime,ErroCode,ErrorMsg,RespData);
  end;  
	
	select '' into RespData;	
  call MES_VerifyWorkstation(GID,DID,WorkstationId,RespData);	
  if WorkstationId = -1 then     
     leave top;
  end if;
	
  if(DataType = 1) then  -- 刷卡输入    
    call MES_VerifyCard(StrPara1,CardType,CardId,RespData);		
    if not (CardType in(0,1,2,3)) then		  
      leave top;
    end if;         
    set ReqDataType = CardType;
  elseif(DataType in(2,3)) then
    set ReqDataType = 4;   -- 键盘输入
  end if;
  
  call MES_ProcessSession(WorkstationId,GID,DID,ReqDataType,StrPara1,CardId,DataGatherTime,RespData);
end;