create procedure MES_BackWipToPrev_3
(    
	in SessionId     bigint,
	in CurrentStep   int,				
	in ReqDataType   int,
	in ReqData       varchar(20),
	in CardId        bigint,
	in CurGID        int,
	in CurDID        int,
	in WorkstationId bigint,
	in ReqTime       datetime,
	out Success      int,
	out RespData     varchar(200)
)
top:begin
    -- 接收人工卡确认
    -- 1. 必须是工卡
	-- 2. 接收人和退还人不能是同一个人 
	declare CreatorOperatorId,ReceiveOperatorId,LogId,LastBusinessId,ProductionId,WorkshopId,WorkshopIdFrom bigint;
    declare TargetQtyCardId bigint;
	declare CreatorCardNo,ReceiveCardNo,CreatorEmployeeId,TargetCardNo,ReceiveEmployeeId,WorkstationCode varchar(20);
	declare CreatorEmployeeName,ReceiveEmployeeName,WorkstationName varchar(50);
	declare BackQty,ShiftId int;
	declare TimeOfOriginWork datetime;
	
	select -1,'',ReqData into Success,RespData,ReceiveCardNo;
	
	if ReqDataType <> 1 then
        set RespData=	'2|1|2';
        set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
        set RespData = CONCAT(RespData,'|1|接收人刷工卡确认|0');				    
        
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
		set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
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
			
	select record_id,last_business_id,production_id,workshop_id,workshop_id_from 
	   into TargetQtyCardId,LastBusinessId,ProductionId,WorkshopId,WorkshopIdFrom
 	from rfid_card c
    where c.rfid_no = TargetCardNo
	  and c.card_status <> 255;

	call MES_DoMoveWip_1(   TargetQtyCardId,TargetCardNo,CurDID,CurGID,BackQty,
							ProductionId,ProductionCode,ProductionName,
							WorkstationId,WorkstationCode,WorkstationName,
							WorkshopId,WorkshopCode,WorkshopName,
							WorkshopIdFrom,WorkshopCodeFrom,WorkshopNameFrom,
							ReceiveOperatorId,ReceiveEmployeeId,ReceiveEmployeeName,
							OutOperatorId,OutEmployeeId,OutEmployeeName,								
							ReqTime,
							2, -- 从下部门退回上部门
							LastBusinessId
	);				
	
	set RespData=	'2|1|2';
	set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
	set RespData = CONCAT(RespData,'|1|已退还',BackQty,'个工件|0');				

	set Success = 0;
end