create procedure MES_Light(
    in   LightIndex  int,
    inout  RespData    varchar(200)
)
begin
    if LightIndex = 3 then
        set RespData = CONCAT(RespData,'|210|128|129|3|3|1000|2|2|0|1|2|0|0|0|0|0|0|0|0|0|0|5|100');
    else
        set RespData = CONCAT(RespData,'|210|128|129|3|2|0|2|3|1000|1|2|0|0|0|0|0|0|0|0|0|0|1|100');
    end if;
end;

create procedure MES_Error(
    inout RespData  varchar(200)
)
begin
   declare LogId bigint;
   call MES_Debug(CONCAT('Before Error :',RespData),LogId);

   call MES_Light(3,RespData);   -- 红灯亮

   call MES_Debug(CONCAT('After Error :',RespData),LogId);
end;


create procedure MES_OK(
    inout RespData varchar(200)
)
begin
   call MES_Light(2,RespData);  -- 绿灯亮
end;
