drop procedure MES_AjustStockByBom;
create procedure MES_AjustStockByBom(
    in       ProductionId      bigint,

    in       GID               int,
    in       DID               int,
    in       WorkstationId     bigint,
    in       WorkstationCode   varchar(20),
    in       WorkstationName   varchar(50),
    in       WocgCode          varchar(20),

    in       WorkshopId        bigint,
    in       WorkshopCode      varchar(20),
    in       WorkshopName      varchar(50),

    in       CardId            bigint,
    in       RfidNo            varchar(20),
    in       CardQty           int,

    in       Qty               int,
    in       TimeOfOriginWork  datetime,
    in       ShiftId           int
)
begin
    declare CurLevel int;      
    
    start transaction;
    select * from global_lock for update;    

    drop table if exists bom_stock;
    create temporary table bom_stock(		
        production_id     bigint                      not null,
        qty               int                         not null,
        lvl               int                         not null
	) engine=memory; 

    insert into bom_stock(production_id,qty,lvl)
       select b.component_id,b.component_qty * Qty,1 
        from bom b 
      where b.material_id = ProductionId
        and b.bom_status = 0;

    set CurLevel = 1;
    BreakWhile:while (true) do       
        set CurLevel = CurLevel + 1;
        insert into bom_stock(production_id,qty,lvl)
            select b.component_id,b.component_qty * bs.qty,CurLevel
               from bom b join bom_stock bs on bs.production_id = b.material_id
               where b.bom_status = 0;                 
      
        if not exists(select * from bom_stock where lvl = CurLevel ) then
            leave BreakWhile;
        end if; 

        if CurLevel > 99 then
            call MES_Debug('');
        end if;       
    end while;

    -- 1. 自动报工    
    insert into production_order_progress(
        production_order_id,production_order_no,production_id,production_code,production_name,
        workshop_id,workshop_code,workshop_name,
        workstation_id,workstation_code,workstation_name,wocg_code,		
        rfid_terminator_id,rfid_controller_id,			
        rfid_card_id,rfid_card_no,report_type,			
        operator_id,employee_id,employee_name,			
        create_by_id,create_by_code,create_by_name,create_time,			
        update_by_id,update_by_code,update_by_name,update_time,opt_flag,
        time_of_origin,time_of_origin_work,shift_id,qty,card_qty    
    ) select 
         -1,'',bs.production_id,m.material_code,m.material_name,
         WorkshopId,WorkshopCode,WorkshopName,
         WorkstationId,WorkstationCode,WorkstationName,WocgCode,
         DID,GID,
         CardId,RfidNo,1,
         -1,'','',
         1,'SYS','数据采集平台',Now(),
         -1,'','',null,0,
         Now(),TimeOfOriginWork,ShiftId,bs.qty,CardQty
     from bom_stock bs join material m on bs.production_id = m.record_Id
    where m.auto_finished_progress = 1;

    -- 2.调整消耗
    update material_stock ms join bom_stock bs on ms.material_id = bs.production_id
       set ms.qty_stock = ms.qty_stock - bs.qty,
           ms.qty_consume_good = ms.qty_consume_good + bs.qty
    where ms.store_id = WorkshopId;

    commit;
end;