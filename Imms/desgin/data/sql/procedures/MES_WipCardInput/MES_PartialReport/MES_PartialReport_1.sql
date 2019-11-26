drop procedure if exists MES_PartialReport_1;

create procedure MES_PartialReport_1
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
    set RespData = CONCAT(RespData,'|1|剩余总数为:',DefaultIssueQty,'|0');			
    set RespData = CONCAT(RespData,'|2|请输入尾数，再按确定|0');					
    set RespData = CONCAT(RespData,'|4|使用剩余总数直接按确定|0');

    set RespHint = '输入尾数：';
    		
	set Success = 0;
end;
