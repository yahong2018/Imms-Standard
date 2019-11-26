drop procedure if exists MES_IssueCard_0;

create procedure MES_IssueCard_0(
    out Success      int,
    out RespHint     varchar(200),
	out RespData     varchar(200)   
)
begin
    set RespData='1';    
    set RespData = CONCAT(RespData,'|1|请刷看板|0');		    
    
    set RespHint = '请刷看板';
    
    set Success = 0;   
end;
