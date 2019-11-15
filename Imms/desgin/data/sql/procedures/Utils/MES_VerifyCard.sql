drop procedure MES_VerifyCard;

create procedure MES_VerifyCard
(
    in  RfidNo      varchar(20),
    out CardType    int,
    out CardId      bigint,
    out RespData varchar(200)
)
begin
    declare LogId bigint;
		
    select -1,-1,'' into CardType,CardId,RespData;	

    call MES_Debug('MES_GetCardType',LogId);	
    call MES_GetCardType(RfidNo,CardType,CardId);
		   
    if not CardType in(1,2,3) then
	    set RespData = '4';        
        set RespData = CONCAT(RespData, '|1|卡没注册:|0');            
		set RespData = CONCAT(RespData, '|2|',RfidNo,'|0'); 
		set RespData = CONCAT(RespData, '|3|请联系管理员注册卡|0'); 
        call MES_Error(RespData);
    end if;     
end;