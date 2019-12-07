drop procedure if exists MES_Light;
create procedure MES_Light(
    in   LightIndex  int,
    inout  RespData    varchar(200)
)
begin
    declare LigthMessage varchar(200);

    if LightIndex = 3 then
        set LigthMessage = '|210|128|129|3|3|1000|2|2|0|1|2|0|0|0|0|0|0|0|0|0|0|3|100';
    else
        set LigthMessage = '|210|128|129|3|2|0|2|3|1000|1|2|0|0|0|0|0|0|0|0|0|0|3|100';
    end if;

    call MES_AddRespMessage(LigthMessage,RespData);
end;

drop procedure  if exists MES_AddRespMessage;
create procedure MES_AddRespMessage(
    in    TheLine     varchar(200),
    inout RespData    varchar(200)
)
begin
    declare LineLength int;    
    set LineLength = cast(SUBSTRING(RespData,1,1) as UNSIGNED) + 1;    
    set RespData = CONCAT(LineLength,TheLine,SUBSTRING(RespData,2));
end;

drop procedure  if exists MES_Error;
create procedure MES_Error(
    inout RespData  varchar(200)
)
begin   
   call MES_Light(3,RespData);   -- 红灯亮
end;

drop procedure  if exists MES_OK;
create procedure MES_OK(
    inout RespData varchar(200)
)
begin
   call MES_Light(2,RespData);  -- 绿灯亮
end;
