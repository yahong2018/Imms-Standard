create procedure MES_ProcessSession(
    in   WorkstationId        bigint,  
    in   ReqDataType          int,          -- 1. 工卡    2.数量卡   3.委外加工卡    4.键盘输入    
    in   ReqData              varchar(20),  -- 卡号或者键盘输入的数字    
    in   CardId               bigint,        -- 如果ReqDataType是 [0,1,2,3]，则表示卡的Id,
    in   ReqTime              datetime,       
    out  RespData             varchar(200)
) 
top:begin
    declare PrevStep,Step int default 0;  
    declare SessionType int default -1;
    declare LogId,SessionId  bigint;

    select -1,-1,'' into SessionId,Step,RespData;	
    call MES_GetWorkstationSessionId(WorkstationId,SessionId,PrevStep,SessionType);	
    if (SessionId = -1) and ReqDataType in(1,2,3) then    
        call MES_CreateNewSession(WorkstationId,ReqDataType,ReqData,CardId,ReqTime,SessionId);			
        set PrevStep = -1;    
    end if;    
    if (SessionId <> -1) then
      call MES_ProcessSessionStep(SessionId,SessionType,PrevStep,WorkstationId,ReqDataType,ReqData,CardId,ReqTime,RespData); 				
        
      insert into workstation_session_step(workstation_session_id,step,req_time,req_data_type,req_data,resp_data,resp_time)
          values(SessionId,PrevStep,ReqTime,ReqDataType,ReqData,RespData,Now());    				
    end if;
      
    if(RespData = '') then
      call MES_HandleErrorReq(ReqData,RespData);
    end if; 
end;