create procedure MES_IssueCard_2(
    in SessionId     bigint,    
    in CurrentStep   int,				
    in ReqDataType   int,
    in ReqData       varchar(20),
    out Success      int,
    out RespData     varchar(200)
)
begin
	declare RfidNo varchar(20);
	declare IssueQty int;
    declare CardId,TheNewSessionId bigint;	 
    declare CreateTime,LastProcessTime,ExpireTime datetime default Now();
	 
	select -1,'' into Success,RespData;
	 
	select s.req_data into RfidNo
	  from workstation_session_step s
	where s.workstation_session_id = SessionId
	  and s.step = 1;

    select record_id,issue_qty into CardId,IssueQty
      from rfid_card
     where rfid_no = RfidNo
       and card_status <> 255;
    
	if (ReqDataType = 4) and (ReqData <> '') then
         set IssueQty = cast(ReqData as UNSIGNED);	
	end if; 
	 
	select employee_card_no into RfidNo from workstation_session where record_id = SessionId;
		
    update rfid_card
	   set issue_qty = IssueQty,
           card_status = 1,
		   stock_qty = 0
	where record_id = CardId;

    set ExpireTime = DATE_ADD(CreateTime,interval 1 minute);
    insert into workstation_session(workstation_id,session_type,current_step,operator_id,employee_id,employee_name,employee_card_no,GID,DID,create_time,last_process_time,expire_time) 
      select workstation_id,session_type,0,operator_id,employee_id,employee_name,employee_card_no,GID,DID,CreateTime,LastProcessTime,ExpireTime
         from workstation_session ws
        where record_id = SessionId;

    set TheNewSessionId = LAST_INSERT_ID();
   
    insert into workstation_session_step(workstation_session_id,step,req_time,req_data_type,req_data,resp_data,resp_time)
      values (TheNewSessionId,0,CreateTime,1,RfidNo,RespData,Now());      
			
    set RespData=	'2|1|4';
	set RespData = CONCAT(RespData, '|210|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
	set RespData = CONCAT(RespData,'|1|已给',RfidNo,'|0');				    	 
    set RespData = CONCAT(RespData,'|2|派发',IssueQty,'个.|0');				    	 
    set RespData = CONCAT(RespData,'|3|继续请刷其他看板.|0');		
end;