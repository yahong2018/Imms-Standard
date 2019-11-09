drop procedure MES_AjustMaterialStockByOutSourceCard_Out;
create procedure MES_AjustMaterialStockByOutSourceCard_Out
(
    in    InStoreId            bigint,
    in    LastBusinessId       bigint
)
begin    
    declare OutStoreId bigint;

	select workstation_id into OutStoreId
	from outsource_workstation_bind
		where record_id = LastBusinessId;
	
	start transaction;
	
	update material_stock s	join production_order_progress p on s.material_id = p.production_id		
		set s.qty_stock = s.qty_stock + p.qty,        -- 库存
		    s.qty_move_in = s.qty_move_in + p.qty,    -- 从上部门转入
			s.update_by_id = 1,
			s.update_by_code = 'SYS',
			s.update_by_name='数据采集平台',
			s.update_time = Now()
	where s.store_id = InStoreId
	and p.record_id in (
		select qty_report_id from outsource_card_bind
			where workstation_bind_id = LastBusinessId			    
	);		 
	
	update material_stock s join production_order_progress p on s.material_id = p.production_id
		set s.qty_stock = s.qty_stock - p.qty,        -- 库存
		    s.qty_move_out = s.qty_move_out + p.qty,  -- 从本部门转出
			s.update_by_id = 1,
			s.update_by_code = 'SYS',
			s.update_by_name='数据采集平台',			 
			s.update_time = Now()
	where s.store_id = OutStoreId
	and p.record_id in (
		select qty_report_id from outsource_card_bind
			where workstation_bind_id = LastBusinessId			    
	);		 	 
		
	commit;	
end;
