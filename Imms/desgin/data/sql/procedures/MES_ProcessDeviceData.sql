drop procedure if exists MES_ProcessDeviceData;
delimiter $$

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
    declare WorkstationId,CardId bigint default -1;
    declare TemplateIndex int default -1;
    declare ErroCode varchar(5) default '00000';
    declare ErrorMsg text;	

    declare exit handler for sqlexception
    begin
        get diagnostics condition 1 ErroCode = returned_sqlstate, ErrorMsg = message_text;	
        set RespData = '';

        call MES_SqlExceptionHandler(StrPara1,DataType,GID,DID,DataGatherTime,ErroCode,ErrorMsg,RespData);
        call MES_BuildRespData(TemplateIndex,RespData); 
    end;

    select '' into RespData;
    call MES_Debug(CONCAT("Get data--> GID:",GID,',DID:',DID,'DataType:',DataType,',DataGatherTime:',DataGatherTime,',StrPara1:',StrPara1));
    call MES_VerifyWorkstation(GID,DID,WorkstationId,TemplateIndex,RespData);	
    call MES_Debug(CONCAT('MES_VerifyWorkstation  GID:',GID,',DID:',DID,',WorkstationId:',WorkstationId,',TemplateIndex:',TemplateIndex));

    if WorkstationId = -1 then  
        call MES_Error(RespData);
        call MES_BuildRespData(TemplateIndex,RespData); 
        
        leave top;
    end if;
    
    call MES_ProcessSession(WorkstationId,DataType,StrPara1,DataGatherTime,RespData); 
    if(DataType<>2) and (StrPara1<>'12') then
        call MES_BuildRespData(TemplateIndex,RespData); 
    end if;
end$$

delimiter ;