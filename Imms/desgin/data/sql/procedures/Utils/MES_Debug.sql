create procedure MES_Debug(  
    in Content varchar(500),
    out LogId  bigint
)
begin
    declare LogLevel int;
    declare StrLogLevel varchar(50);

    select parameter_value into StrLogLevel
    from system_parameter
    where parameter_code='LOG_LEVEL'
        and parameter_class_code = 'B001';
    set LogLevel = cast(ifnull(StrLogLevel,'0') as unsigned);
    set LogLevel  = -1;

    if(LogLevel <= 5) then
        insert into system_logs(user_id,log_time,log_type,log_level,log_value)  values(0,Now(),'SYS',0,Content);                    
        set LogId = LAST_INSERT_ID();
    end if;
end