create procedure MES_AssureMaterialStock(
    in ProductionId      bigint,
    in ProductionCode    varchar(20),
    in ProductionName    varchar(50),
    in WorkshopId        bigint,
    in WorkshopCode      varchar(20),
    in WorkshopName      varchar(50),
    out StockRecordId    bigint
)
begin    
    set StockRecordId = -1;

    select record_id into StockRecordId 
      from material_stock 
    where material_id = ProductionId  and store_id = WorkshopId;

    if ifnull(StockRecordId,-1) = -1 then
        start transaction;
            select record_id into StockRecordId 
            from material_stock 
            where material_id = ProductionId  and store_id = WorkshopId 
              for update;

            if ifnull(StockRecordId,-1) = -1 then                
                insert into material_stock(material_id,material_code,material_name,store_id,store_code,store_name,
                                            qty_stock,qty_move_in,qty_back_in,qty_back_out,qty_consume_good,qty_consume_defect,qty_good,qty_defect,qty_move_out,
                                            create_by_id,create_by_code,create_by_name,create_time,opt_flag)
                    values(ProductionId,ProductionCode,ProductionName,WorkshopId,WorkshopCode,WorkshopName,
                            0,0,0,0,0,0,0,0,0,
                            1,'SYS','数据采集平台',Now(),0
                    );            

                set StockRecordId = LAST_INSERT_ID();
            end if;        
        commit;    
    end if;
end;