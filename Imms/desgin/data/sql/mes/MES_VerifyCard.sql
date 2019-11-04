create procedure MES_VerifyCard
(
    in  RfidNo      varchar(20),
    out CardType    int,
    out CardId      bigint,
    out RespMessage varchar(500))
begin
    call MES_GetCardType(RfidNo,CardType,CardId);		

    if not CardId in(0,1,2) then
	    set RespMessage=	'2|1|4';
        set RespMessage = CONCAT(RespMessage, '|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次
        set RespMessage = CONCAT(RespMessage, '|1|卡没注册:|0');            
		set RespMessage = CONCAT(RespMessage, '|2|',RfidNo,'|0'); 
		set RespMessage = CONCAT(RespMessage, '|3|请联系管理员注册卡|0');                    
    end if;   
end;