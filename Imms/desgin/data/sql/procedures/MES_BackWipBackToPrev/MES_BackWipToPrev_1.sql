create procedure MES_BackWipToPrev_1
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
        call MES_BackWipToPrev_0(Success,RespData);
        leave top;
    end if;
    
    select card_status into CardStatus
     from rfid_card
    where record_id = CardId;
    
    if(CardStatus<>20) then
        set RespData=	'2|1|3';
        set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
        set RespData = CONCAT(RespData,'|1|只有移库了的卡|0');					   
        set RespData = CONCAT(RespData,'|2|才可以退数.|0');					   
        
        leave top;
    end if;	
    
    set RespData=	'2|1|2';
    set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
    set RespData = CONCAT(RespData,'|1|请输入退还数量|0');			
    
    set Success = 0;
end;