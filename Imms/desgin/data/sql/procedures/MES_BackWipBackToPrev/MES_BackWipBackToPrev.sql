create procedure MES_BackWipBackToPrev
(
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
top:begin
    declare Success int;
    select -1,'' into Success,RespData;		
		
    if (CurrentStep = 0) then  
        call MES_BackWipBackToPrev_0(Success,RespData);		
	elseif CurrentStep = 1 then --  保存看板
	    call MES_BackWipBackToPrev_1(ReqDataType,CardId,Success,RespData);		
	elseif CurrentStep = 2 then -- 保存退还数量
        call MES_BackWipBackToPrev_2(SessionId,CurrentStep,ReqDataType,ReqData,Success,RespData);
	elseif CurrentStep = 3 then -- 保存接收人工卡
		call MES_BackWipBackToPrev_3(SessionId,CurrentStep,ReqDataType,ReqData,CardId,GID,DID,WorkstationId,ReqTime,Success,RespData);
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