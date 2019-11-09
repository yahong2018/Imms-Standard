drop table MES_AjustMaterialStockByOutSourceCard_Back;
create procedure MES_AjustMaterialStockByOutSourceCard_Back
(
    in    InStoreId            bigint,
	in    OutStoreId           bigint,
    in    LastBusinessId       bigint
)
begin    
	start transaction;
	
	update material_stock s	join production_order_progress p on s.material_id = p.production_id		
		set s.stock_qty = s.stock_qty + p.qty,
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
		set s.stock_qty = s.stock_qty - p.qty,
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

