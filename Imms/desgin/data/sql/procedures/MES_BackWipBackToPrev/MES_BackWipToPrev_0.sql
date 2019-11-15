drop procedure MES_BackWipToPrev_0;

create procedure MES_BackWipToPrev_0(
    out Success      int,
	out RespData     varchar(200)
)
begin
    set RespData='2';    
    set RespData = CONCAT(RespData,'|1|请刷看板|0');		
    call MES_OK(RespData);
    
    set Success = 0;
end;