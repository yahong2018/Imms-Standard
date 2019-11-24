create procedure MES_PartialReport_0
(
    out Success      int,
    out RespHint     varchar(200),
	out RespData     varchar(200)  
)
begin
    set RespData='1';    
    set RespData = CONCAT(RespData,'|1|请刷工程内看板|0');		    
    
    set RespHint = '请刷工程内看板';
    
    set Success = 0;   
end;