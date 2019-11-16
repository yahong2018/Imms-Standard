drop procedure MES_SqlExceptionHandler;

create procedure MES_SqlExceptionHandler(
    in StrPara1         varchar(20),   
    in DataType         int, 
    in GID              int,
    in DID              int,
    in GatherTime       datetime,   
    in ErrorCode        varchar(5),
    in ErrorMsg         varchar(500),
    out RespData     varchar(200)
)
begin
    declare LogMessage varchar(4000);
    declare LogId bigint;
    set LogId = -1;    

    set LogMessage = CONCAT('StrPara1:',StrPara1,',DataType:',DataType,',GID:',GID,',DID:',DID,',GatherTime:',GatherTime,',ErrorCode:',ErrorCode,',ErrorMsg:',ErrorMsg);
    call MES_Debug(LogMessage,LogId);

    set RespData = '2';
    set RespData = CONCAT(RespData,'|1|系统异常:',LogId,'|0');
    set RespData = CONCAT(RespData,'|2|请联系管理员|0');

    call MES_Error(RespData);   
end;