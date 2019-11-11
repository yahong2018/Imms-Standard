create procedure MES_DoReportWip_0(  
  /*
      MES_DoReportWip_0: 非外发前工程报工，除了E/V前工程外的车间进行生产报工，包括外发回厂的报工。
  */
  in    WorkstaitonId        int,              -- 报工工位
  in    CardId               int,              -- RFID
  in    ReqTime              datetime,         -- 报工时间
  out   ReportQty            int,              -- 结果：报工数量
  out   LastBusinessId       bigint
)
begin  
  declare StockQty,IssueQty,ShiftId,PrevOperationIndex,CurGID,CurGID int;
  declare TimeOfOriginWork datetime;
  declare WorkshopId,ProductionId,PrevMaterialId bigint;
  declare WorkshopCode,ProductionCode,WorkstationCode,WocgCode,RfidNo varchar(20);
  declare WorkshopName,ProductionName,WorkstationName varchar(50);
	    
  call MES_GetWorkDayAndShiftId(ReqTime,TimeOfOriginWork,ShiftId);

  select production_id,production_code,production_name,rfid_no,issue_qty,issue_qty - stock_qty
       into ProductionId,ProducitonCode,ProductionName,RfidNo,IssueQty,ReportQty 
   from rfid_card 
  where card_id = CardId;

  select wst.org_code,wst.org_name,wst.parent_id,wst.parent_code,wst.parent_name,wst.wocg_code,wst.rfid_controller_id,wst.rfid_terminator_id, wss.prev_operation_index
      into WorkstatioinCode,WorkstationName,WorkshopId,WorkshopCode,WorkshopName,WocgCode,CurGID,CurDID,PrevOperationIndex
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
  update material_stock
     set qty_stock = qty_stock + ReportQty,
         qty_good = qty_good + ReportQty
  where material_id = ProductionId
    and store_id = WorkshopId;
  
  -- 调整投入半成品的库存
  if(PrevOperationIndex<>-1) then
      select prev_material_id  into PrevMaterialId 
        from material
        where material_id = ProductionId;

      update material_stock
         set qty_stock = qty_stock - ReportQty,                  -- 转入【半成品】的库存
             qty_consume_good = qty_consume_good + ReportQty     -- 转入【半成品】的消耗
         where material_id = PrevMaterialId
           and store_id = WorkshopId;
  end if; 
  
  -- 更新状态和卡的库存数量
  update rfid_card
    set card_status = 10  -- 0. 未使用   1. 已派发  2.已退回  3.已绑定    10. 已报工   20. 已移库收货 
       ,stock_qty = IssueQty  
       ,last_business_id = LastBusinessId
  where record_id = CardId;
    
end