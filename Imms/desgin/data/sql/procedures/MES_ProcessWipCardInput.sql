create procedure MES_ProcessWipCardInput(   
   in     WorkstationId       bigint,
   in     GID                 int,
   in     DID                 int,
   in     RfidNo              varchar(20),
   in     CardId              bigint,
   in     ReqTime             datetime,
   out    RespData            varchar(200)
)
top:begin    
  declare CardWorkshopId,LoginedWorkshopId,ProductionId,MoveCardId,WorkstationBindId,BindWorkshopId,LogId  bigint default -1;
  declare CardStatus,CardType,CardProcedureIndex,LoginedProcedureIndex,LoginedPrevProcedureIndex,WorkshopType,IssueQty,StockQty int default -1;
  declare ProductionCode,LoginedWorkshopCode,CardWorkshopCode,WorkstationCode,WocgCode,BindWorkshopCode,NextWorkshopCode,MoveCardNo varchar(20);
  declare ProductionName,LoginedWorkshopName,CardWorkshopName,WorkstationName,NextWorkshopName,BindWorkshopName varchar(50);
  declare ProcessIndex,CheckType,WorkstationBindStatus int default 1;
	
  select '' into RespData;
  
  select w.record_id,w.operation_index,c.card_type,c.card_status,c.issue_qty,c.stock_qty,c.production_id,c.production_code,c.production_name,c.workshop_code,c.workshop_name
    into CardWorkshopId,CardProcedureIndex,CardType,CardStatus,IssueQty,StockQty,ProductionId,ProductionCode,ProductionName,CardWorkshopCode,CardWorkshopName
  from work_organization_unit  w join rfid_card  c on w.record_id = c.workshop_id
  where c.record_id =  CardId;
    
  select wss.record_id,wss.org_code,wss.org_name,wss.operation_index,wss.prev_operation_index,wss.workshop_type,wst.org_code,wst.org_name,wst.wocg_code
    into LoginedWorkshopId,LoginedWorkshopCode,LoginedWorkshopName,LoginedProcedureIndex,LoginedPrevProcedureIndex,WorkshopType,WorkstationCode,WorkstationName,WocgCode
  from work_organization_unit wst join work_organization_unit wss on wst.parent_id = wss.record_id
  where wst.record_id = WorkstationId;

  select w.org_code,w.org_name into NextWorkshopCode,NextWorkshopName
    from work_organization_unit w
    where w.prev_operation_index = CardProcedureIndex;
  
  select b.outsource_card_id,b.outsource_card_no,b.record_id,b.bind_status,b.workshop_id,b.workshop_code,b.workshop_name
  	into MoveCardId,MoveCardNo,WorkstationBindId,WorkstationBindStatus,BindWorkshopId,BindWorkshopCode,BindWorkshopName
   from outsource_workstation_bind b
   where b.workstation_id = WorkstationId
  order by attach_time desc
   limit 1;

  -- 检查类型: 0. 报工、移库  1.绑定  2.退库   3.派发
  if CardType = 3 and CardStatus in(1,2,20) then
     set CheckType = 1;
  else 
     set CheckType = 0; 
  end if;
	
  call MES_CheckCardAndWorkstation(WorkstationId,CardStatus,CardType,CardProcedureIndex,LoginedProcedureIndex,LoginedPrevProcedureIndex,CardWorkshopName,NextWorkshopName,WorkshopType,MoveCardId,WorkstationBindStatus,BindWorkshopId,BindWorkshopCode,BindWorkshopName,CheckType,RespData);
  
  if( RespData <> '') then
      leave top;
  end if;
  
  if (CardStatus = 1) then  
      if CardType = 2 then  -- 工程内报工    
          call MES_DoReportWip(LoginedWorkshopId,LoginedWorkshopCode,LoginedWorkshopName,WorkshopType,MoveCardId,MoveCardNo,WorkstationBindId,GID,DID,WorkstationId,WorkstationCode,WorkstationName,WocgCode,ProductionId,ProductionCode,ProductionName,RfidNo,CardId,IssueQty,StockQty,CardType,CardStatus,ReqTime,RespData);       					
      elseif CardType = 3 then  -- 外发卡绑定
          call MES_DoBindOutsourceCard(WorkstationId,WorkstationCode,WorkstationName,CardId,CardNo,RespData);
		  call MES_Debug('MES_DoBindOutsourceCard',LogId);
      end if;
  elseif(CardStatus = 2 ) and (LoginedProcedureIndex = CardProcedureIndex) and (CardType = 2) then -- 补数
      call MES_DoReportWip(LoginedWorkshopId,LoginedWorkshopCode,LoginedWorkshopName,WorkshopType,MoveCardId,MoveCardNo,WorkstationBindId,GID,DID,WorkstationId,WorkstationCode,WorkstationName,WocgCode,ProductionId,ProductionCode,ProductionName,RfidNo,CardId,IssueQty,StockQty,CardType,CardStatus,ReqTime,RespData);       						    
	else -- 移库
      call MES_DoMoveWip(LoginedWorkshopId,LoginedWorkshopCode,LoginedWorkshopName,CardWorkshopId,CardWorkshopCode,CardWorkshopName,WorkstationBindId,WorkstationBindStatus,GID,DID,WorkstationId,WorkstationCode,WorkstationName,WocgCode,ProductionId,ProductionCode,ProductionName,RfidNo,CardId,StockQty,CardType,CardStatus,ReqTime,RespData);      	
  end if;	 
end;
