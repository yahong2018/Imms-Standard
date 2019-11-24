drop procedure MES_AjustStockByOp;
create procedure MES_AjustStockByOp(
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
    in       ShiftId           int,
    in       LevelCount        int
)
begin
    declare CurLevel,MaxLevel int;  
    
    delete from bom_stock where workstation_id = WorkStationId;
    
    set MaxLevel = LevelCount + 1;
    --
    -- 第1层的部品(非原材料)
    --   最后的一层有物料消耗，但是不要自动报工
    --
    insert into bom_stock(workstation_id,production_id,qty,lvl)
    select WorkStationId,b.component_id,b.component_qty * Qty,1 
        from bom b 
    where b.material_id = ProductionId
        and b.bom_status = 1
        and exists(
        select * from bom b1 where b1.material_id = b.component_id
    );

    set CurLevel = 1;
    BreakWhile:while (CurLevel < MaxLevel) do
        set CurLevel = CurLevel + 1;

        insert into bom_stock(workstation_id,production_id,qty,lvl)
        select WorkstationId, b.component_id,b.component_qty * bs.qty,CurLevel
        from bom b,bom_stock bs,material m
        where  bs.workstation_id  = WorkStationId
            and b.material_id     = bs.production_id                  
            and b.material_id     = m.record_id
            and bs.lvl            = CurLevel - 1
            and b.bom_status      = 1                    
            and exists(
                select * from bom b1 where b1.material_id = b.component_id
            );
    
        if not exists(select * from bom_stock where lvl = CurLevel and workstation_id = WorkstationId ) then
            leave BreakWhile;
        end if; 
    end while;                 
    
    -- 1. 自动报工记录    
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

    -- 2. 生产进度
    insert into product_summary (product_date,workshop_id,workshop_code,workshop_name,production_id,production_code,production_name,qty_good_0,qty_defect_0,qty_good_1,qty_defect_1)
    select TimeOfOriginWork,WorkshopId,WorkshopCode,WorkshopName,
            bs.production_id,m.material_code,m.material_name,0,0,0,0
    from  bom_stock bs join material m on bs.production_id = m.record_id
    where bs.workstation_id = WorkstationId
        and bs.lvl < MaxLevel
        and not exists(
            select * from product_summary ps
                where ps.production_id = bs.production_Id
                    and ps.workshop_id = WorkshopId
                    and ps.product_date = TimeOfOriginWork
    );

    update product_summary ps,bom_stock bs 
        set ps.qty_good_0 = if(bs.lvl = MaxLevel,ps.qty_good_0,if(ShiftId = 0, (ps.qty_good_0 + bs.qty), ps.qty_good_0)),
            ps.qty_good_1 = if(bs.lvl = MaxLevel,ps.qty_good_1,if(ShiftId = 1, (ps.qty_good_1 + bs.qty), ps.qty_good_1))
    where ps.production_id = bs.production_id
        and ps.product_date = TimeOfOriginWork
        and ps.workshop_id = WorkshopId
        and bs.workstation_id = WorkstationId;
    
    --
    -- 调整库存:所有的部品都需要进行库存的调整
    --
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
                where ms.material_id = bs.production_id
                    and ms.store_id = WorkshopId
    );
    
    -- 产出与消耗
    update material_stock ms , bom_stock bs, material m
        set ms.qty_stock = if(bs.lvl = MaxLevel, (ms.qty_stock - bs.qty), ms.qty_stock),
            ms.qty_good =  if(bs.lvl = MaxLevel,  ms.qty_good,ms.qty_good + bs.qty),
            ms.qty_consume_good = ms.qty_consume_good + bs.qty
    where ms.material_id = bs.production_id
        and ms.store_id = WorkshopId
        and bs.production_id = m.record_id
        and bs.workstation_id = WorkstationId;
end;