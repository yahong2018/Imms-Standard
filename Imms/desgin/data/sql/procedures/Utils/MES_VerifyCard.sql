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
        set RespMessage = CONCAT(RespMessage, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
        set RespMessage = CONCAT(RespMessage, '|1|卡没注册:|0');            
		    set RespMessage = CONCAT(RespMessage, '|2|',RfidNo,'|0'); 
		    set RespMessage = CONCAT(RespMessage, '|3|请联系管理员注册卡|0');            
    end if;     
end;