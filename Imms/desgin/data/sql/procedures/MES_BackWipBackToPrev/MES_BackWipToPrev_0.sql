create procedure MES_BackWipToPrev_0(
    out Success      int,
	out RespData     varchar(200)
)
begin
    set RespData=	'2|1|2';
    set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
    set RespData = CONCAT(RespData,'|1|请刷看板|0');		
    
    set Success = 0;
end;