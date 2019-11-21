drop procedure MES_ReportWip_0;

create procedure MES_ReportWip_0(  
	in    WorkstationId        int,              -- 报工工位
	in    CardId               int,              -- RFID
	in    ReqTime              datetime,         -- 报工时间
	out   ReportQty            int,              -- 结果：报工数量
	out   LastBusinessId       bigint
)
begin  
		declare StockQty,IssueQty,ShiftId,PrevOperationIndex,CurDID,CurGID,WorkshopType,CardType,TheNewCardStatus int;
		declare TimeOfOriginWork datetime;
		declare WorkshopId,ProductionId,LogId,StockRecordId bigint;
		declare WorkshopCode,ProductionCode,WorkstationCode,WocgCode,RfidNo varchar(20);
		declare WorkshopName,ProductionName,WorkstationName varchar(50);
				
		call MES_GetWorkDayAndShiftId(ReqTime,TimeOfOriginWork,ShiftId);

		select production_id,production_code,production_name,rfid_no,issue_qty,issue_qty - stock_qty,card_type
				into ProductionId,ProductionCode,ProductionName,RfidNo,IssueQty,ReportQty,CardType 
		from rfid_card 
		where record_id = CardId;

		select wst.org_code,wst.org_name,wst.parent_id,wst.parent_code,wst.parent_name,wst.wocg_code,wst.rfid_controller_id,wst.rfid_terminator_id, 
					 wss.prev_operation_index,wss.workshop_type
				into WorkstationCode,WorkstationName,WorkshopId,WorkshopCode,WorkshopName,WocgCode,CurGID,CurDID,PrevOperationIndex,WorkshopType
		from work_organization_unit wst join work_organization_unit wss on wst.parent_id = wss.record_id
		where wst.record_id = WorkstationId;

		-- 新增生产进度
		insert into production_order_progress(
				production_order_id,production_order_no,production_id,production_code,production_name,
				workshop_id,workshop_code,workshop_name,
				workstation_id,workstation_code,workstation_name,	wocg_code,		
				rfid_terminator_id,rfid_controller_id,			
				rfid_card_id,rfid_card_no,report_type,			
				operator_id,employee_id,employee_name,			
				create_by_id,create_by_code,create_by_name,create_time,			
				update_by_id,update_by_code,update_by_name,update_time,opt_flag,
				time_of_origin,time_of_origin_work,shift_id,qty,card_qty    
		) values(
				-1,'',ProductionId,ProductionCode,ProductionName,
				WorkshopId,WorkshopCode,WorkshopName,			
				WorkstationId,WorkstationCode,WorkstationName,WocgCode,
				CurGID,CurDID,			
				CardId,RfidNo,0,
				-1,'','',			
				1,'SYS','数据采集平台',Now(),			
				null,null,null,null,0,
				ReqTime,TimeOfOriginWork,ShiftId,ReportQty,IssueQty
		);
		set LastBusinessId = LAST_INSERT_ID();
 
		-- 调整完成品库存
		call MES_AssureMaterialStock(ProductionId,ProductionCode,ProductionName,WorkshopId,WorkshopCode,WorkshopName,StockRecordId);

		update material_stock st
				set st.qty_stock = st.qty_stock + ReportQty,
						st.qty_good = st.qty_good + ReportQty
		where st.record_id = StockRecordId;

		call MES_AjustStockByBom(ProductionId,
																 CurGID,CurDID,WorkstationId,WorkstationCode,WorkstationName,WocgCode,
																 WorkshopId,WorkshopCode,WorkshopName,
																 CardId,RfidNo,IssueQty,
																 ReportQty,TimeOfOriginWork,ShiftId
																);

		-- 更新状态和卡的库存数量
		set TheNewCardStatus = 10;
		if (WorkshopType = 5) and (CardType = 3) then
			 set TheNewCardStatus = 30;  -- 0. 未使用   1. 已派发  2.已退回  3.已绑定    10. 已报工   20. 已移库收货  30.已外发回厂
		end if;    

		update rfid_card c
		set  c.card_status = TheNewCardStatus  
				,c.stock_qty = IssueQty  
				,c.last_business_id = LastBusinessId
		where c.record_id = CardId;

		-- 更新生产进度
		if not exists(select * from product_summary ps
									 where ps.product_date = TimeOfOriginWork
										 and ps.production_id = ProductionId
										 and ps.workshop_id = WorkshopId) then
				insert into product_summary (product_date,workshop_id,workshop_code,workshop_name,production_id,production_code,production_name,qty_good_0,qty_defect_0,qty_good_1,qty_defect_1)
					 values(TimeOfOriginWork,WorkshopId,WorkshopCode,WorkshopName,ProductionId,ProductionCode,ProductionName,0,0,0,0);
		end if;

		if ShiftId = 0 then
				update product_summary ps
					set ps.qty_good_0 = ps.qty_good_0 + ReportQty
				where ps.product_date = TimeOfOriginWork
					and ps.production_id = ProductionId
					and ps.workshop_id = WorkshopId;
		else 
				update product_summary ps
					set ps.qty_good_1 = ps.qty_good_1 + ReportQty
				where ps.product_date = TimeOfOriginWork
					and ps.production_id = ProductionId
					and ps.workshop_id = WorkshopId;
		end if;    
end