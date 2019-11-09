drop procedure MES_DoMoveWipByQtyCard;
create procedure MES_DoMoveWipByQtyCard(
  /*
    MES_DoMoveWipByQtyCard: 从上车间【移入】到本车间
  */
  in    WorkstationId        bigint,      -- 移入工位
  in    LastBusinessId       bigint,      -- 报工记录
  in    CardId               bigint,      -- 工程内看板卡的Id
  in    ReqTime              datetime,    -- 发生时间
  out   MovedQty             int          -- 返回结果：移库数量
)
begin    
    declare ShiftId,CurGID,CurDID int;
	declare TimeOfOriginWork datetime;
	declare WorkstationCode,WorkshopCode,WorkshopCodeFrom,RfidNo,ProductionCode varchar(20);
	declare WorkstationName,WorkshopName,WorkshopNameFrom,ProductionName varchar(50);
	declare WorkshopId,ProductionId,WorkshopIdFrom bigint;	

    -- 上次的报工记录相关信息
    select rfid_no, stock_qty,production_id,production_code,production_name, workshop_id,workshop_code,workshop_name
	   into RfidNo,MovedQty,ProductionId,ProductionCode,ProductionName,WorkshopIdForm,WorkshopCodeFrom,WorkshopNameFrom
	from rfid_card where record_id = CardId;				
	
	-- 获取移入车间信息
	select w.org_code,w.org_name,w.rfid_controller_id,w.rfid_terminator_id,w.wocg_code,w.parent_id,w.parent_code,w.parent_name 
		into WorkstationCode,WorkstationName,CurGID,CurDID,WorkshopId,WorkshopCode,WorkshopName
	from work_organization_unit w
	where w.record_id = WorkstationId;

	-- 计算工作日与白晚班
    call MES_GetWorkDayAndShiftId(ReqTime,TimeOfOriginWork,ShiftId);

    -- 新增移库流水记录
	insert into production_moving(
			production_order_id,production_order_no,production_id,production_code,production_name,
			rfid_no,rfid_card_id,rfid_terminator_id,rfid_controller_group_id,qty,
			operator_id,employee_id,employee_name,time_of_origin,time_of_origin_work,shift_id,
			workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,
			workshop_id_from,workshop_code_from,workshop_name_from,
			create_by_id,create_by_code,create_by_name,create_time,
			update_by_id,update_by_code,update_by_name,update_time,opt_flag,prev_progress_record_id
	)values(  
			-1,'',ProductionId,ProductionCode,ProductionName,
			RfidNo,CardId,CurDID,CurGID,MovedQty,
			-1,'','',ReqTime,TimeOfOriginWork,ShiftId,
			WorkstationId,WorkstationCode,WorkstationName,WorkshopId,WorkshopCode,WorkshopName,
			WorkshopIdFrom,WorkshopCodeFrom,WorkshopNameFrom
				1,'SYS','数据采集平台',Now(),			
			null,null,null,null,0,LastBusinessId
	);

	-- 修改卡工程内看板的状态
	update reid_card
	   set card_status = 20 
	where record_id = CardId;
	
	-- 调整车间在制品库存
	update material_stock
		set qty_stock = qty_stock + MovedQty,	    -- 库存
		    qty_move_in = qty_move_in + MovedQty,	-- 从上部门转入	
			update_time = Now(),
			update_by_id = 1,
			update_by_code = 'SYS',
			update_by_name='数据采集平台'					 
	where material_id = ProductionId
	and store_id = WorkshopId;    -- 转入
		
	update material_stock
		set qty_stock = qty_stock - MovedQty,        -- 库存
		    qty_move_out = qty_move_out + MovedQty,  -- 从本部门转出
			update_time = Now(),
			update_by_id = 1,
			update_by_code = 'SYS',
			update_by_name='数据采集平台'						 
	where material_id = ProductionId
	and store_id = WorkshopIdFrom;   -- 转出
end;