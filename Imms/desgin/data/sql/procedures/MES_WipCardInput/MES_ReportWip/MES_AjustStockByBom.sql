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
       
    delete from bom_stock where workstation_id = WorkStationId;
    
    insert into bom_stock(workstation_id,production_id,qty,lvl)
       select WorkStationId,b.component_id,b.component_qty * Qty,1 
        from bom b 
      where b.material_id = ProductionId
        and b.bom_status = 1;

    call MES_Debug('MES_AjustStockByBom   1');

    set CurLevel = 1;
    BreakWhile:while (true) do       
        set CurLevel = CurLevel + 1;
        insert into bom_stock(workstation_id,production_id,qty,lvl)
            select WorkstationId, b.component_id,b.component_qty * bs.qty,CurLevel
               from bom b join bom_stock bs on bs.production_id = b.material_id
               where b.bom_status = 1
                 and bs.workstation_id = WorkStationId
                 and bs.lvl = CurLevel-1;
      
        if not exists(select * from bom_stock where lvl = CurLevel and workstation_id = WorkstationId ) then
            leave BreakWhile;
        end if; 

        if CurLevel > 99 then
            call MES_Debug('Max Level Reached');
            leave BreakWhile;
        end if;       
    end while;

    call MES_Debug('MES_AjustStockByBom   99');
    
    delete bs from bom_stock bs
      where bs.workstation_id = WorkstationId
        and not exists(
             select * from material m 
                where m.auto_finished_progress = 1
                 and m.record_id = bs.production_id
    );

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
     where bs.workstation_id = WorkstationId;

    call MES_Debug('MES_AjustStockByBom   100');

    -- 2. 生产进度
    insert into product_summary (product_date,workshop_id,workshop_code,workshop_name,production_id,production_code,production_name,qty_good_0,qty_defect_0,qty_good_1,qty_defect_1)
    select TimeOfOriginWork,WorkshopId,WorkshopCode,WorkshopName,
           bs.production_id,m.material_code,m.material_name,0,0,0,0
    from  bom_stock bs join material m on bs.production_id = m.record_id
    where bs.workstation_id = WorkstationId
      and not exists(
        select * from product_summary ps
          where ps.production_id = bs.production_Id
            and ps.workshop_id = WorkshopId
            and ps.product_date = TimeOfOriginWork
    );
    
    if ShiftId = 0 then
        update product_summary ps,bom_stock bs 
          set ps.qty_good_0 = ps.qty_good_0 + bs.qty
        where ps.production_id = bs.production_id
          and ps.product_date = TimeOfOriginWork
          and ps.workshop_id = WorkshopId
          and bs.workstation_id = WorkstationId;
    else 
        update product_summary ps,bom_stock bs 
          set ps.qty_good_1 = ps.qty_good_1 + bs.qty
        where ps.production_id = bs.production_id
          and ps.product_date = TimeOfOriginWork
          and ps.workshop_id = WorkshopId
          and bs.workstation_id = WorkstationId;
    end if;    

    -- 调整库存
    insert into material_stock(material_id,material_code,material_name,store_id,store_code,store_name,
                               qty_stock,qty_move_in,qty_back_in,qty_back_out,qty_consume_good,qty_consume_defect,qty_good,qty_defect,qty_move_out,
                               create_by_id,create_by_code,create_by_name,create_time,opt_flag)
    select m.record_id,m.material_code,m.material_name,WorkshopId,WorkshopCode,WorkshopName,
                  0,0,0,0,0,0,0,0,0,
                  1,'SYS','数据采集平台',Now(),0
     from  bom_stock bs join material m on bs.production_id = m.record_id
    where bs.workstation_id = WorkstationId
     and not exists(
        select * from material_stock ms 
          where ms.material_id = bs.production_Id
            and ms.store_id = WorkshopId
    );    
   
    -- 产出与消耗
    update material_stock ms join bom_stock bs on ms.material_id = bs.production_id
       set ms.qty_good = ms.qty_good + bs.qty,
           ms.qty_consume_good = ms.qty_consume_good + bs.qty
    where ms.store_id = WorkshopId
      and bs.workstation_id = WorkstationId;    
end;