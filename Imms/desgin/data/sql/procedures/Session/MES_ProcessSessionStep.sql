drop procedure MES_ProcessSessionStep;

create procedure MES_ProcessSessionStep(
    in   SessionId            bigint,       -- Session的Id
	inout  PrevStep           int,          -- 前一步骤	
    in   SessionType          int,          
    in   WorkstationId        bigint,       -- 工位    
    in   ReqDataType          int,          -- 1. 工卡    2.数量卡   3.委外加工卡    4.键盘输入    
    in   ReqData              varchar(20),  -- 卡号或者键盘输入的数字    
    in   CardId               bigint,        -- 如果ReqDataType是 [1,2,3]，则表示卡的Id,
    in   ReqTime              datetime,  
	out  Success              int,
	out  RespHint             varchar(200),
    out  RespData             varchar(200)
)
top:begin  
    declare SessionStepId bigint;
     
	select '','',-1 into RespHint,RespData,Success;

	call MES_Debug(CONCAT('MES_ProcessSessionStep--> PrevStep:',PrevStep,',ReqDataType:',ReqDataType,'ReqData:',ReqData));		
	
    -- 如果是新Session,就要确定Session的类别
    if (PrevStep = -1) then
		if ReqDataType = 1 then -- 如果是刷工卡，则提示菜单 1.退件  2.发前工程看板    
			call MES_Debug('MES_DisplayMenu');	

			call MES_DisplayMenu(RespHint,RespData);		
			set Success = 0;

			leave top;
		elseif (ReqDataType in (2,3))  then
		    if exists(select * from workstation_session_step where workstation_session_id = SessionId) then  
			   leave top;
			end if;

			call MES_Debug(CONCAT('MES_WipCardInput --> Success:',Success));
			update workstation_session  set current_step = 255 where record_id = SessionId; -- 这些Session只有一步      
			call MES_WipCardInput(WorkstationId,ReqDataType,ReqData,CardId,ReqTime,Success,RespData);
			call MES_Debug(CONCAT('MES_WipCardInput --> Success:',Success));
			
			set PrevStep = 0;
			
			leave top;
		elseif (ReqDataType = 4) then			    
			if ReqData in ('1','2') then -- 确定Session类型
				if ReqData = '1' then
					set SessionType = 0;
				elseif ReqData = '2' then
					set SessionType = 1;
				elseif ReqData = '3' then
				    set SessionType = 2;
				end if;
				
				update workstation_session  
				set current_step = 0,
					session_type = SessionType 
				where record_id = SessionId;       					 													
			end if;
		end if;
	end if;	
  	
  	 -- 如果已经确定了session的类别，则根据PrevStep来确定本次的行动
    if SessionType = 0 then   -- 如果是"退件"	
	    call MES_Debug('MES_BackWipToPrev');		 
        call MES_BackWipToPrev(SessionId,PrevStep + 1,WorkstationId,ReqDataType,ReqData,CardId,ReqTime,Success,RespHint,RespData);				
		call MES_Debug('MES_BackWipToPrev END');	
    elseif SessionType = 1 then -- 如果是"给前工程发卡"
	    call MES_Debug('MES_IssueCard');		
        call MES_IssueCard(SessionId,PrevStep + 1,WorkstationId,ReqDataType,ReqData,CardId,ReqTime,Success,RespHint,RespData);
	elseif SessionType = 2 then  -- 尾数报工
	    call MES_Debug('MES_PartialReport');		
        call MES_PartialReport(SessionId,PrevStep + 1,WorkstationId,ReqDataType,ReqData,CardId,ReqTime,Success,RespHint,RespData);	
    end if;  

	if Success = 0 then
	    set PrevStep = PrevStep + 1;	
	end if;
end;