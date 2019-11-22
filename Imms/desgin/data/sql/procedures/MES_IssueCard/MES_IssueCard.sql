drop procedure MES_IssueCard;

create procedure MES_IssueCard(
    in SessionId     bigint,
    in CurrentStep   int,
    in WorkstationId bigint,
    in ReqDataType   int,
    in ReqData       varchar(20),
    in CardId        bigint,
    in ReqTime       datetime,
    out Success      int,
    out RespHint     varchar(200),
    out RespData     varchar(200)
)
top:begin    
    declare CardStatus,DefaultIssueQty int;

    select -1,'','' into Success,RespData,RespHint;		
    call MES_Debug(CONCAT('MES_IssueCard--> CurrentStep:',CurrentStep,',ReqDataType:',ReqDataType,'ReqData:',ReqData));		

    if CurrentStep = 1 then
        select card_status,issue_qty into CardStatus,DefaultIssueQty
            from rfid_card
        where record_id = CardId;           
    end if;
    call MES_HandleIssueCardError(CurrentStep,ReqDataType,ReqData,CardStatus,RespData);
    
    if RespData <> '' then
        leave top;
    end if;    
		
    if (CurrentStep = 0) and (ReqDataType = 4) then  -- 菜单选择
        call MES_IssueCard_0(Success,RespHint,RespData);		
	elseif (CurrentStep = 1) and (ReqDataType = 2) then --  刷看板
        call MES_IssueCard_1(ReqDataType,CardId,DefaultIssueQty,Success,RespHint,RespData);	
    elseif (CurrentStep = 2) and (ReqDataType = 4) then -- 输入数量
        call MES_IssueCard_2(SessionId,CurrentStep,ReqDataType,ReqData,Success,RespData);		
    end if;

    if( Success <> 0 ) then
	   leave top;
	end if;
    
    if CurrentStep = 2 then
		update workstation_session
			set current_step = 255	
		where record_id = SessionId;
	else 
		update workstation_session
			set current_step = CurrentStep
		where record_id = SessionId;		
	end if;	
end;