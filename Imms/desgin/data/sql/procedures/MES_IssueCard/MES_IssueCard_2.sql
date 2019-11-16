drop procedure MES_IssueCard_2;

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
  declare CreateTime,LastProcessTime,ExpireTime datetime;
  declare ProductionName varchar(50);
	 
	select -1,'' into Success,RespData;
	 
	select s.req_data into RfidNo
	  from workstation_session_step s
	where s.workstation_session_id = SessionId
	  and s.step = 1
    order by s.record_id desc
    limit 1;

    select c.record_id,c.issue_qty,c.production_name into CardId,IssueQty,ProductionName
      from rfid_card c
    where c.rfid_no = RfidNo
       and c.card_status <> 255;
    
	if (ReqDataType = 4) and (ReqData <> '') then
         set IssueQty = cast(ReqData as UNSIGNED);	
	end if; 
	 
	select employee_card_no into RfidNo from workstation_session where record_id = SessionId;
		
    update rfid_card
	   set issue_qty = IssueQty,
           card_status = 1,
		   stock_qty = 0
	where record_id = CardId;

    set CreateTime = Now();
    set LastProcessTime = Now();
    set ExpireTime = DATE_ADD(Now(),interval 1 minute);
    insert into workstation_session(workstation_id,session_type,current_step,operator_id,employee_id,employee_name,employee_card_no,GID,DID,create_time,last_process_time,expire_time) 
      select workstation_id,session_type,0,operator_id,employee_id,employee_name,employee_card_no,GID,DID,CreateTime,LastProcessTime,ExpireTime
         from workstation_session ws
        where record_id = SessionId;

    set TheNewSessionId = LAST_INSERT_ID();
   
    insert into workstation_session_step(workstation_session_id,step,req_time,req_data_type,req_data,resp_hint,resp_data,resp_time)
      values (TheNewSessionId,0,CreateTime,1,RfidNo,'请刷看板',RespData,Now());   
    
    set RespData= '4';  	
	  set RespData = CONCAT(RespData,'|1|已给看板',RfidNo,'|0');				    	 
    set RespData = CONCAT(RespData,'|2|派发',ProductionName,'|0');				    	 
    set RespData = CONCAT(RespData,'|3|',IssueQty,'个.|0');
    set RespData = CONCAT(RespData,'|4|继续请刷其他看板.|0');    

    set Success = 0;
end;