create procedure MES_BackWipToPrev_2
(
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
        set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
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
        set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
        set RespData = CONCAT(RespData,'|1|退还数量必须|0');				    
        set RespData = CONCAT(RespData,'|2|小于等于移库数量|0');				    
        
        leave top;	 
    end if;
	 	 
    set RespData=	'2|1|2';
	set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
	set RespData = CONCAT(RespData,'|1|请接收人刷工卡确认|0');				    	 
	 
	set Success = 0;
end;