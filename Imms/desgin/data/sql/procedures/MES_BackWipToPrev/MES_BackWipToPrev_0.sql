drop procedure MES_BackWipToPrev_0;

create procedure MES_BackWipToPrev_0(
    out Success      int,
    out RespHint     varchar(200),
	out RespData     varchar(200)
)
begin
    set RespData='2';    
    set RespData = CONCAT(RespData,'|1||0');		
    set RespData = CONCAT(RespData,'|2|请刷看板|0');		

    set RespHint = '请刷看板';

    set Success = 0;
end;