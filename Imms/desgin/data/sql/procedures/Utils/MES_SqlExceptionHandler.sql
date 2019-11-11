create procedure MES_SqlExceptionHandler(
    in StrPara1         varchar(20),    
    in GID              int,
    in DID              int,
    in DataType         int,
    in GatherTime       datetime,   
    in ErrorCode        varchar(5),
    in ErrorMsg         varchar(500),
    out RespMessage     varchar(500)
)
begin
    declare LogMessage varchar(4000);
    declare LogId bigint;
    set LogId = -1;    

    set LogMessage = CONCAT('StrPara1:',StrPara1,'DataType:',DataType,',GID:',GID,',DID:',DID,',GatherTime:',GatherTime,'ErrorCode:',ErrorCode,',ErrorMessage:',ErrorMsg);
    call MES_Debug(LogMessage,LogId);

    set RespMessage = '2|1|3';
    set RespMessage = CONCAT(RespMessage,'|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
    set RespMessage = CONCAT(RespMessage,'|1|系统异常:',LogId,'|0');
    set RespMessage = CONCAT(RespMessage,'|2|请联系管理员|0');	   
end;