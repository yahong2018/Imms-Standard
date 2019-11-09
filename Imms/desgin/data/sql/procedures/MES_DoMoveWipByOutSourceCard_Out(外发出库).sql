drop procedure MES_DoMoveWipByOutSourceCard_Out;
create procedure MES_DoMoveWipByOutSourceCard_Out
(
    in    WorkstationId        bigint, -- 转出工位
    in    CardId               bigint,
    in    LastBusinessId       bigint,		
	in    ReqTime              datetime
)
begin
    declare ShiftId,CurGID,CurDID int;
	declare TimeOfOriginWork datetime;
	declare WorkstationCode,WorkshopCode varchar(20);
	declare WorkstationName,WorkshopName varchar(50);
	declare WorkshopId,WorkstationBindId bigint;
			
	select w.org_code,w.org_name,w.rfid_controller_id,w.rfid_terminator_id,w.wocg_code 
		into WorkstationCode,WorkstationName,CurGID,CurDID
	from work_organization_unit w
	where w.record_id = WorkstationId;	

    select workshop_id,workshop_code,workskhop_name
		   into WorkshopId,WorkshopCode,WorkshopName
		from rfid_card 
	where record_id = CardId;	

	-- 计算工作日与班次
    call MES_GetWorkDayAndShiftId(ReqTime,TimeOfOriginWork,ShiftId);		

	-- 新增异动流水			 
	insert into production_moving(
		production_order_id,production_order_no,production_id,production_code,production_name,
		rfid_no,rfid_card_id,rfid_terminator_id,rfid_controller_group_id,qty,
		operator_id,employee_id,employee_name,time_of_origin,time_of_origin_work,shift_id,
		workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,
		workshop_id_from,workshop_code_from,workshop_name_from,
		create_by_id,create_by_code,create_by_name,create_time,
		update_by_id,update_by_code,update_by_name,update_time,opt_flag,prev_progress_record_id
	)select 
		-1,'',p.production_id,p.production_code,p.production_name,
		p.rfid_card_no,p.rfid_card_id,CurGID,CurDID,p.qty,
		-1,'','',ReqTime,TimeOfOriginWork,ShiftId,
		WorkstationId,WorkstationCode,WorkstationName,WorkshopId,WorkshopCode,WorkshopName,
		p.workshop_id,p.workshop_code,p.workshop_name,
		1,'SYS','数据采集平台',Now(),
		null,null,null,null,0,p.record_id
	from production_order_progress p
	where p.record_id in(
		select qty_report_id from outsource_card_bind	where workstation_bind_id = LastBusinessId
	);

	-- 修改外发看板的状态	
    update outsource_workstation_bind
	    set out_time = ReqTime,
			bind_status = 20 -- 已外发
	where record_id = LastBusinessId;	
	
    update rfid_card
	   set card_status = 20 -- 已外发
	where record_id in(
		select qty_card_id from outsource_card_bind	where workstation_bind_id = LastBusinessId
	);

	-- 调整库存及其异动	
	call MES_AjustMaterialStockByOutSourceCard_Out(WorkshopId,LastBusinessId);			    	
end;