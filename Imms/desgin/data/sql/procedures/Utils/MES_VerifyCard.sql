drop procedure if exists MES_VerifyCard;

create procedure MES_VerifyCard
(
    in  RfidNo      varchar(20),
    out CardType    int,
    out CardStatus  int,
    out CardId      bigint,
    out RespData    varchar(200)
)
begin    
    select -1,-1,-1,'' into CardType,CardStatus,CardId,RespData;	    
    call MES_GetCardType(RfidNo,CardType,CardStatus,CardId);
		   
    if not CardType in(1,2,3) then
	    set RespData = '2';                         
		set RespData = CONCAT(RespData, '|1|卡',RfidNo,'没注册|0'); 
		set RespData = CONCAT(RespData, '|2|请联系管理员注册卡|0');
    end if; 
end;