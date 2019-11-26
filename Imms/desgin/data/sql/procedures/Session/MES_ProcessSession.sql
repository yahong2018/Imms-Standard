drop procedure if exists MES_ProcessSession;

create procedure MES_ProcessSession(
    in   WorkstationId        bigint,  
    in   DataType             int,          -- 1. 工卡    2.数量卡   3.委外加工卡    4.键盘输入    
    in   ReqData              varchar(20),  -- 卡号或者键盘输入的数字        
    in   ReqTime              datetime,       
    out  RespData             varchar(200)
) 
top:begin
    declare PrevStep,Step int default 0;  
    declare SessionType,Success int default -1;
    declare SessionId,CardId  bigint;
    declare RespHint varchar(200);
    declare CardType,ReqDataType,CardStatus int;

    select -1,-1,'','' into SessionId,Step,RespData,RespHint;	
    
    call MES_GetWorkstationSession(WorkstationId,SessionId,PrevStep,SessionType);	
    call MES_Debug(CONCAT('MES_GetWorkstationSession  WorkstationId:',WorkstationId,',SessionId:',SessionId,',PrevStep:',PrevStep,',SessionType:',SessionType));	

    if(DataType = 1) then  -- 刷卡输入    
        call MES_VerifyCard(ReqData,CardType,CardStatus,CardId,RespData);		
        call MES_Debug(CONCAT('MES_VerifyCard  ReqData:',ReqData,',CardType:',CardType,',CardId:',CardId));
        if not (CardType in(0,1,2,3)) then		            
            if SessionId <> -1 then
                select s.resp_hint into RespHint from workstation_session_step s where s.workstation_session_id = SessionId and s.step = PrevStep;
                if ifnull(RespHint,'') <> '' then
                   call MES_AddRespMessage(CONCAT('|200|',RespHint),RespData);
                end if;
            end if;
            call MES_Error(RespData);

            leave top;
        end if;         
        set ReqDataType = CardType;
    elseif(DataType in(2,3)) then
        set ReqDataType = 4;   -- 键盘输入
    end if;
    
    if (SessionId = -1) then    
        if ReqDataType in(1,2,3) then
            call MES_CreateNewSession(WorkstationId,ReqDataType,ReqData,CardId,ReqTime,SessionId);			
            call MES_Debug(CONCAT('MES_CreateNewSession   WorkstationId:',WorkstationId,',ReqDataType:',ReqDataType,',ReqData:',ReqData,',CardId:',CardId,',SessionId:',SessionId));	

            set PrevStep = -1;    
        else
            set RespData = '3';
            set RespData = CONCAT(RespData,'|1|前次功能已过30秒有效期|0');
            set RespData = CONCAT(RespData,'|2|刷工卡确定系统功能之后，|0');
            set RespData = CONCAT(RespData,'|3|才可按键输入。|0');
            
            call MES_Error(RespData);
            leave top;
        end if;
    elseif((ReqDataType = 1) and (PrevStep = -1)) then
        update workstation_session set current_step = 255 where record_id = SessionId;
        call MES_CreateNewSession(WorkstationId,ReqDataType,ReqData,CardId,ReqTime,SessionId);			
        set PrevStep = -1;    
    end if; 

    call MES_Debug(CONCAT('MES_ProcessSessionStep--> WorkstationId:',WorkstationId,',SessionId:',SessionId,',PrevStep:',PrevStep,',ReqDataType:',ReqDataType,',ReqData:',ReqData));	
    
    call MES_ProcessSessionStep(SessionId,PrevStep,SessionType,WorkstationId,ReqDataType,ReqData,CardId,ReqTime,Success,RespHint,RespData);

    if Success = 0 then
        call MES_Debug('MES_ProcessSessionStep  OK');
        insert into workstation_session_step(workstation_session_id,step,req_time,req_data_type,req_data,resp_hint,resp_data,resp_time)
               values(SessionId,PrevStep,ReqTime,ReqDataType,ReqData,RespHint,RespData,Now());    
    else
        call MES_Debug(CONCAT('MES_ProcessSessionStep  Fail ---> SessionId:',SessionId,',PrevStep:',PrevStep));
        select s.resp_hint into RespHint from workstation_session_step s where s.workstation_session_id = SessionId and s.step = PrevStep;

        call MES_Debug('MES_ProcessSessionStep get Last Hint');
        if (RespData <> '') and (RespHint <> '') then
            call MES_AddRespMessage(CONCAT('|200|',RespHint),RespData);

            call MES_Debug(CONCAT('MES_ProcessSessionStep Failed:', RespData));
        elseif (RespHint <> '')  then
           set RespData = CONCAT('1|1|',RespHint,'|0');         
        end if;

        if (ifnull(RespData,'') = '') then
            call MES_HandleErrorReq(ReqData,RespData);        
        end if;
    end if;

    update workstation_session 
       set expire_time =  DATE_ADD(Now(),interval 1 minute)
      where record_id = SessionId;

    if Success = 0 then        
        call MES_OK(RespData);
    else
        call MES_Error(RespData);
    end if;
end;