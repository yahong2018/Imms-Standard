
create procedure MES_PartialReport_2(        
        in  SessionId     bigint,    
        in  CurrentStep   int,		
        in  ReqDataType   int,
        in  ReqData       varchar(20),
        in  ReqTime       datetime,
        out Success      int,    
        out RespData     varchar(200)
)
begin
    declare RfidNo varchar(20);
    declare CardType,CardStatus,WorkshopType,ReportQty int;
    declare CardId,WorkstationId,LastBusinessId,OperatorId bigint;	 
    declare EmployeeId varchar(20);
    declare EmployeeName varchar(50);
     
    select -1,'' into Success,RespData;
     
    select s.req_data into RfidNo
        from workstation_session_step s
    where s.workstation_session_id = SessionId
        and s.step = 1
        order by s.record_id desc
        limit 1;

    select c.record_id,c.card_type,c.card_status into CardId,CardType,CardStatus
        from rfid_card c
    where c.rfid_no = RfidNo
      and c.card_status <> 255;
   
    set ReportQty = cast(ReqData as UNSIGNED);	   
     
    select ws.operator_id,ws.employee_id,ws.employee_name,ws.workstation_id 
        into OperatorId,EmployeeId,EmployeeName,WorkstationId
       from workstation_session ws 
       where record_id = SessionId;

    select wss.workshop_type into WorkshopType
       from work_organization_unit wst join work_organization_unit wss on wst.parent_id = wss.record_Id
      where wst.record_id = WorkstationId;
        
    call MES_ReportWip(WorkstationId,WorkshopType,CardId,CardType,CardStatus,ReqTime,ReportQty,LastBusinessId,Success,RespData);

    update production_order_progress
       set operator_id = OperatorId,
           employee_id = EmployeeId,
           employee_name = EmployeeName
     where record_id = LastBusinessId;
end;