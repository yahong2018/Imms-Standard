create procedure MES_MoveWip_0(
  in    WorkstationId        bigint,      -- 发生工位(工程看板为【移入工位】，外发看板为【移出工位】)  
  in    CardId               bigint,      -- 看板卡的Id  
  in    ReqTime              datetime,    -- 发生时间
  out   MovedQty             int,          -- 返回结果：移库数量
  inout LastBusinessId       bigint        -- 报工记录: -1 表示是外发，其他表示工程内移库
)
begin    
    declare CurGID,CurDID int;
	declare WorkstationCode,WorkshopCode,WorkshopCodeFrom,RfidNo,ProductionCode varchar(20);
	declare WorkstationName,WorkshopName,WorkshopNameFrom,ProductionName varchar(50);
	declare WorkshopId,ProductionId,WorkshopIdFrom,LogId bigint;	
    
    if LastBusinessId = -1 then  
	    call MES_Debug('MES_MoveWip_0: LastBusinessId is -1',LogId);	
		-- 移入车间
		select c.rfid_no, c.stock_qty,c.production_id,c.production_code,c.production_name, c.workshop_id,c.workshop_code,c.workshop_name
		        into RfidNo,MovedQty,ProductionId,ProductionCode,ProductionName,WorkshopId,WorkshopCode,WorkshopName
		from rfid_card c where c.record_id = CardId;				
		
		-- 移出车间
		select w.org_code,w.org_name,w.rfid_controller_id,w.rfid_terminator_id,w.wocg_code,w.parent_id,w.parent_code,w.parent_name 
			   into WorkstationCode,WorkstationName,CurGID,CurDID,WorkshopIdFrom,WorkshopCodeFrom,WorkshopNameFrom
		from work_organization_unit w
		where w.record_id = WorkstationId;
	else
	    call MES_Debug('MES_MoveWip_0: LastBusinessId is not -1',LogId);	
		-- 移出车间
		select c.rfid_no, c.stock_qty,c.production_id,c.production_code,c.production_name, c.workshop_id,c.workshop_code,c.workshop_name
	   	       into RfidNo,MovedQty,ProductionId,ProductionCode,ProductionName,WorkshopIdFrom,WorkshopCodeFrom,WorkshopNameFrom
		from rfid_card c where c.record_id = CardId;				
		
		-- 移入车间
		select w.org_code,w.org_name,w.rfid_controller_id,w.rfid_terminator_id,w.parent_id,w.parent_code,w.parent_name 
			   into WorkstationCode,WorkstationName,CurGID,CurDID,WorkshopId,WorkshopCode,WorkshopName
		from work_organization_unit w
		where w.record_id = WorkstationId;	    
	end if;

    call MES_Debug('MES_MoveWip_0: MES_MoveWip_1',LogId);	
	call MES_MoveWip_1(CardId,RfidNo,CurDID,CurGID,MovedQty,
	                     ProductionId,ProductionCode,ProductionName,
						 WorkstationId,WorkstationCode,WorkstationName,
						 WorkshopId,WorkshopCode,WorkshopName,
						 WorkshopIdFrom,WorkshopCodeFrom,WorkshopNameFrom,
						 1,'SYS','数据采集平台',
						 1,'SYS','数据采集平台',						 
						 ReqTime,
						 20, -- 从上部门移库到下部门
						 LastBusinessId
	);
end;