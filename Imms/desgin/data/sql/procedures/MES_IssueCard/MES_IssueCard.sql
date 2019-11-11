create procedure MES_IssueCard(
    in SessionId     bigint,
    in CurrentStep   int,
    in WorkstationId bigint,
    in GID           int,
    in DID           int,
    in ReqDataType   int,
    in ReqData       varchar(20),
    in CardId        bigint,
    in ReqTime       datetime,
    out RespData     varchar(200)
)
begin
    declare Success int;
    select -1,'' into Success,RespData;		
		
    if (CurrentStep = 0) then  
        call MES_IssueCard_0(Success,RespData);		
	elseif CurrentStep = 1 then --  刷看板
		call MES_IssueCard_1(ReqDataType,CardId,Success,RespData);		
    elseif CurrentStep = 2 then -- 输入数量
        call MES_IssueCard_2(SessionId,CurrentStep,ReqDataType,ReqData,Success,RespData);		
    end if;
    
    if( Success <> 0 ) then
	   leave top;
	end if;
    
    if CurrentStep = 3 then
		update workstation_session
			set current_step = 255	
		where record_id = SessionId;
	else 
		update workstation_session
			set current_step = CurrentStep
		where record_id = SessionId;		
	end if;	
end;