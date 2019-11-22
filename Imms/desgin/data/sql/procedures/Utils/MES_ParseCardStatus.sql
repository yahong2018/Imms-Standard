drop procedure MES_ParseCardStatus;

create procedure MES_ParseCardStatus(
    in     StatusCode    int,
    out    StatusName    varchar(20)
)
begin
    if StatusCode = 0 then
       set StatusName = '未派发';
    elseif(StatusCode = 1) then 
       set StatusName = '已派发';
    elseif(StatusCode = 2) then
       set StatusName = '已退回';
    elseif(StatusCode = 3) then
       set StatusName = '已绑定';
    elseif(StatusCode = 10) then
       set StatusName = '已报工';
    elseif(StatusCode = 20) then
       set StatusName = '已移库';
    elseif(StatusCode = 30) then
       set StatusName = '已回厂';
    elseif(StatusCode = 255) then
       set StatusName = '已作废';
    else
       set StatusName = '未注册';
    end if;
end;