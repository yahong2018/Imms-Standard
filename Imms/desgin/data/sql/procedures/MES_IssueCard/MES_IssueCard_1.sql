create procedure MES_IssueCard_1
(    
    in ReqDataType   int,	
    in CardId        bigint,		
    out Success      int,
    out RespData     varchar(200)
)
top:begin
    -- 1.校验数量卡
    -- 2.提示派发数量    
    declare CardStatus,DefaultIssueQty int default -1;
    select -1,'' into Success,RespData;		
    
    if(ReqDataType <> 2) then
        call MES_ProcessIssuePlanToPrevProcedure_0(Success,RespData);
        leave top;
    end if;
    
    select card_status,issue_qty into CardStatus,DefaultIssueQty
        from rfid_card
        where record_id = CardId;
    
    if(CardStatus<>20) then
        set RespData=	'2|1|3';
        set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
        set RespData = CONCAT(RespData,'|1|只有移库了的看板|0');					   
        set RespData = CONCAT(RespData,'|2|才需要派发.|0');					   
        
        leave top;
    end if;	
    
    set RespData=	'2|1|5';
    set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
    set RespData = CONCAT(RespData,'|1|按确定使用上次数量:|0');			
    set RespData = CONCAT(RespData,'|2|',DefaultIssueQty,'|0');			
	set RespData = CONCAT(RespData,'|3|如需自定义派发数量|0');			
    set RespData = CONCAT(RespData,'|4|先按数字键，再按确定|0');			
		
	set Success = 0;
end;
