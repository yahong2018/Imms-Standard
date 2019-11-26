drop procedure if exists MES_IssueCard_1;

create procedure MES_IssueCard_1
(    
    in WorkstationId    bigint,
    in CardId           bigint,		
    in DefaultIssueQty  int,
    out Success         int,
    out RespHint        varchar(200),
    out RespData        varchar(200)
)
top:begin       
    select -1,'','' into Success,RespData,RespHint;	        
        
    set RespData='4';    
    set RespData = CONCAT(RespData,'|1|按确定使用上次数量:|0');			
    set RespData = CONCAT(RespData,'|2|',DefaultIssueQty,'|0');			
	set RespData = CONCAT(RespData,'|3|如需自定义派发数量|0');			
    set RespData = CONCAT(RespData,'|4|先按数字键，再按确定|0');

    set RespHint = '输入派发数量：';
    		
	set Success = 0;
end;
