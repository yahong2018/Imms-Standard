drop procedure if exists MES_MoveWip_1;

create procedure MES_MoveWip_1(
    in CardId                    bigint,
    in RfidNo                    varchar(20),
    in CurDID                    int,
    in CurGID                    int,
    in MovedQty                  int,
    
    in ProductionId              bigint,
    in ProductionCode            varchar(20),
    in ProductionName            varchar(50),

    in WorkstationId             bigint,
    in WorkstationCode           varchar(20),
    in WorkstationName           varchar(50),

    in WorkshopId                bigint,
    in WorkshopCode              varchar(20),
    in WorkshopName              varchar(50),
    
    in WorkshopIdFrom            bigint,
    in WorkshopCodeFrom          varchar(20),
    in WorkshopNameFrom          varchar(50),

    in ReceiveOperatorId         bigint,
    in ReceiveEmployeeId         varchar(20),
    in ReceiveEmployeeName       varchar(50),

    in OutOperatorId             bigint,
    in OutEmployeeId             varchar(20),
    in OutEmployeeName           varchar(50),

    in ReqTime                   datetime,

    in MoveType                  int,   -- 2.退回    20. 转入
    
    inout LastBusinessId         bigint
)
begin
    declare TimeOfOriginWork datetime;
    declare ShiftId  int;
    declare StockRecordId bigint;

    -- 计算工作日与白晚班
    call MES_GetWorkDayAndShiftId(ReqTime,TimeOfOriginWork,ShiftId);

    -- 新增移库流水记录
	insert into production_moving(
			production_order_id,production_order_no,production_id,production_code,production_name,
			rfid_no,rfid_card_id,rfid_terminator_id,rfid_controller_group_id,qty,
			operator_id,employee_id,employee_name,
            time_of_origin,time_of_origin_work,shift_id,
			workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,
            operator_id_from,employee_id_from,employee_name_from,
			workshop_id_from,workshop_code_from,workshop_name_from,
			create_by_id,create_by_code,create_by_name,create_time,
			update_by_id,update_by_code,update_by_name,update_time,opt_flag,prev_progress_record_id
	)values(  
			-1,'',ProductionId,ProductionCode,ProductionName,
			RfidNo,CardId,CurDID,CurGID,MovedQty,
			ReceiveOperatorId,ReceiveEmployeeId,ReceiveEmployeeName,
            ReqTime,TimeOfOriginWork,ShiftId,
			WorkstationId,WorkstationCode,WorkstationName,WorkshopId,WorkshopCode,WorkshopName,
            OutOperatorId,OutEmployeeId,OutEmployeeName,
			WorkshopIdFrom,WorkshopCodeFrom,WorkshopNameFrom,
			1,'SYS','数据采集平台',Now(),			
			null,null,null,null,0,LastBusinessId
	);

    set LastBusinessId = LAST_INSERT_ID();

	-- 修改卡工程内看板的状态    
	update rfid_card c
	   set c.card_status = MoveType,
           c.last_business_id = LastBusinessId,
           c.stock_qty = MovedQty
	where c.record_id = CardId;

    call MES_AssureMaterialStock(ProductionId,ProductionCode,ProductionName,WorkshopId,WorkshopCode,WorkshopName,StockRecordId);
	
	-- 调整车间在制品库存
    if MoveType = 20 then
        update material_stock s
            set s.qty_stock = s.qty_stock + MovedQty,	    -- 库存
                s.qty_move_in = s.qty_move_in + MovedQty,	-- 从上部门转入	
                s.update_time = Now(),
                s.update_by_id = 1,
                s.update_by_code = 'SYS',
                s.update_by_name='数据采集平台'
        where record_id = StockRecordId;  -- 转入
            
        update material_stock s
            set s.qty_stock = s.qty_stock - MovedQty,        -- 库存
                s.qty_move_out = s.qty_move_out + MovedQty,  -- 从本部门转出
                s.update_time = Now(),
                s.update_by_id = 1,
                s.update_by_code = 'SYS',
                s.update_by_name='数据采集平台'						 
        where s.material_id = ProductionId
        and s.store_id = WorkshopIdFrom;   -- 转出
    elseif(MoveType = 2)  then
        update material_stock s
            set s.qty_stock = s.qty_stock + MovedQty,	    -- 库存
                s.qty_back_in = s.qty_back_in + MovedQty,	-- 从下部门退回本部门	
                s.update_time = Now(),
                s.update_by_id = 1,
                s.update_by_code = 'SYS',
                s.update_by_name='数据采集平台'					 
        where record_id = StockRecordId; -- 转入
            
        update material_stock s
            set s.qty_stock = s.qty_stock - MovedQty,        -- 库存
                s.qty_back_out = s.qty_back_out + MovedQty,  -- 从本部门退回上部门
                s.update_time = Now(),
                s.update_by_id = 1,
                s.update_by_code = 'SYS',
                s.update_by_name='数据采集平台'						 
        where s.material_id = ProductionId
        and s.store_id = WorkshopIdFrom;   -- 转出        
    end if;
end;