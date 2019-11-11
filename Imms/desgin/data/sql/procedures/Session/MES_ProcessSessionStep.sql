create procedure MES_ProcessSessionStep(
    in   SessionId            bigint,       -- Session的Id
    in   SessionType          int,          
    inout  PrevStep           int,          -- 前一步骤
    in   WorkstationId        bigint,       -- 工位    
    in   ReqDataType          int,          -- 1. 工卡    2.数量卡   3.委外加工卡    4.键盘输入    
    in   ReqData              varchar(20),  -- 卡号或者键盘输入的数字    
    in   CardId               bigint,        -- 如果ReqDataType是 [1,2,3]，则表示卡的Id,
    in   ReqTime              datetime,        
    out  RespData             varchar(200)
)
top:begin  
    declare SessionStepId,LogId bigint;
     
	select '' into RespData;	
	
    -- 如果是新Session,就要确定Session的类别
    if (PrevStep = -1) then
			if ReqDataType = 1 then -- 如果是刷工卡，则提示菜单 1.退件  2.发前工程看板       
					call MES_CreateSessionTypeSelectMenu(RespData);			
					leave top;
			elseif (ReqDataType in (2,3)) then
					update workstation_session  set current_step = 255 where record_id = SessionId; -- 这些Session只有一步      
					call MES_ProcessWipCardInput(WorkstationId,ReqDataType,ReqData,CardId,ReqTime,RespData);   
					set PrevStep = 0;
					
					leave top;
			elseif (ReqDataType = 4) then			    
					if ReqData in ('1','2') then -- 确定Session类型
						 if ReqData = '1' then
								 set SessionType = 0;
						 elseif ReqData = '2' then
								 set SessionType = 1;
						 end if;
						 
						 update workstation_session  
						    set current_step = 0,
								    session_type = SessionType 
							where record_id = SessionId;       					 													
					end if;
			end if;
	end if;
  
	set PrevStep = PrevStep + 1;
  	 -- 如果已经确定了session的类别，则根据PrevStep来确定本次的行动
    if SessionType = 0 then   -- 如果是"退件"		 
        call MES_ProcessReturnWipBackToPrevProcedure(SessionId,PrevStep,WorkstationId,ReqDataType,ReqData,CardId,ReqTime,RespData);				
    elseif SessionType = 1 then -- 如果是"给前工程发卡"
       call MES_ProcessIssuePlanToPrevProcedure(SessionId,PrevStep,WorkstationId,ReqDataType,ReqData,CardId,ReqTime,RespData);
			-- call MES_Debug('MES_ProcessIssuePlanToPrevProcedure', LogId);
    end if;  
end;