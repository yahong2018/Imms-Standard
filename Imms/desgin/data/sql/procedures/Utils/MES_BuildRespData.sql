drop procedure MES_BuildRespData;

create procedure MES_BuildRespData(
    in     TemplateIndex    int,
    inout  RespData         varchar(200)
)
begin    
    if (ifnull(TemplateIndex,-1) = -1) then
        set TemplateIndex = 4;   -- 设置为4,所有的工位机都可以显示
    end if;
    set RespData = CONCAT(TemplateIndex,'|1|',RespData);

    call MES_Debug(CONCAT('MES_BuildRespData :',RespData));
end;