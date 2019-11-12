create procedure MES_ProcessDeviceData( 
 in	GID            int,
 in	DID            int,
 in	DataType       int, 				
 in	DataGatherTime datetime,
 in	DataMakeTime   datetime,
 in	StrPara1       varchar(20),  
 out RespData      varchar(200)
)
top:begin    
    declare WorkstationId,CardId,LogId bigint default -1;
    declare CardType,ReqDataType int default -1;
    declare ErroCode varchar(5) default '00000';
    declare ErrorMsg text;	

    declare exit handler for sqlexception
    begin
        get diagnostics condition 1 ErroCode = returned_sqlstate, ErrorMsg = message_text;	
        set RespData = '';
        call MES_SqlExceptionHandler(StrPara1,DataType,GID,DID,DataGatherTime,ErroCode,ErrorMsg,RespData);
    end;  

    select '' into RespData;

    call MES_Debug('MES_VerifyWorkstation',LogId);	

    call MES_VerifyWorkstation(GID,DID,WorkstationId,RespData);	
    if WorkstationId = -1 then     
        leave top;
    end if;

    call MES_Debug('MES_VerifyCard',LogId);
    if(DataType = 1) then  -- 刷卡输入    
        call MES_VerifyCard(StrPara1,CardType,CardId,RespData);		
        if not (CardType in(0,1,2,3)) then		  
            leave top;
        end if;         
        set ReqDataType = CardType;
    elseif(DataType in(2,3)) then
        set ReqDataType = 4;   -- 键盘输入
    end if;

    call MES_Debug('MES_ProcessSession',LogId);
    call MES_ProcessSession(WorkstationId,ReqDataType,StrPara1,CardId,DataGatherTime,RespData);
end;