create procedure MES_CloseSession(
    in     SessionId    bigint,
    out    RespData     varchar(200)
)
begin
    update workstation_session
       set current_step = 255
    where record_id = SessionId;

    set RespData = '9|1|1|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0';
end;