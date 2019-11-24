drop procedure MES_ReportWip;

create procedure MES_ReportWip(
    in    WorkstationId        bigint,              -- 报工工位
    in    WorkshopType         int,  
    in    CardId               bigint,              -- RFID  
    in    CardType             int,
    in    CardStatus           int,
    in    ReqTime              datetime,            -- 报工时间  
    inout ReportQty            int,
    out   LastBusinessId       bigint,
    out   Success              int,
    out   RespData             varchar(200)  
)
top:begin
    declare ShiftId,totalCount,totalQty,BindCardIssueQty,BindCardStockQty int;
    declare BindId,OutSourceCardProductionId,QtyCardProductionId  bigint;    
    declare QtyCardProductionCode,RfidNo varchar(20);
    declare ProductionName varchar(50);
    declare TimeOfOriginWork datetime;
    
    select '',-1 into RespData,Success;   

    select c.rfid_no,c.production_id,c.production_code,c.production_name,
                if(ReportQty <> -1,ReportQty,if(c.card_type = 3 and c.card_status = 20, c.stock_qty, c.issue_qty - c.stock_qty))
            into RfidNo,QtyCardProductionId,QtyCardProductionCode,ProductionName,ReportQty
        from rfid_card c
    where c.record_id = CardId; 

    if (WorkshopType in (1,4,5)) then  -- 工程内车间、外发后工程车间 
        call MES_Debug('MES_ReportWip:工程内车间、外发后工程车间 ');  
        call MES_ReportWip_0(WorkstationId,CardId,ReqTime,ReportQty,LastBusinessId);
    elseif(WorkshopType = 3) then   -- 外发前工程车间的工程内看板报工
        --
        -- 外发前工程，必须先有相应的绑定记录
        --   注意可以不同机种的多塔来回切换
        --  
       
        select b.record_id, c.production_id,c.issue_qty,c.stock_qty
          into BindId, OutSourceCardProductionId,BindCardIssueQty,BindCardStockQty
          from outsource_workstation_bind b join rfid_card  c on b.outsource_card_id = c.record_id                                            
         where b.workstation_id = WorkstationId            
           and b.bind_status < 20
           and exists (
                select * from bom bm
                where bm.material_id = c.production_id
                  and bm.component_id = QtyCardProductionId
           )
           order by attach_time desc  -- 只匹配最后刷卡的对应记录
           limit 1;
                    
        set OutSourceCardProductionId = ifnull(OutSourceCardProductionId,-1);

        if (OutSourceCardProductionId = -1) or (not exists( select * from bom b
                where b.material_id = OutSourceCardProductionId
                and b.component_id = QtyCardProductionId)
        ) then
            set RespData = '3';            
            set RespData = CONCAT(RespData,'|1|工位没有绑定对应|0');     
            set RespData = CONCAT(RespData,'|2|产品',QtyCardProductionCode,'|0');     
            set RespData = CONCAT(RespData,'|3|的外发看板|0');                 

            leave top;
        end if;

        -- 判断是否有超过外发看板的数量
        if(BindCardIssueQty < BindCardStockQty + ReportQty) then
            set RespData = '3';      
            set RespData = CONCAT(RespData,'|1|报工数:',BindCardStockQty + ReportQty,'已超过|0');     
            set RespData = CONCAT(RespData,'|2|外发看板容量:',BindCardIssueQty,'|0');    
            set RespData = CONCAT(RespData,'|3|请换另外一张外发看板|0');

            leave top;
        end if;
        
        -- 进行报工 
        call MES_Debug('MES_ReportWip_1:外发前工程车间的工程内看板报工 ');
        call MES_ReportWip_1(WorkstationId,BindId,CardId,RfidNo,ReqTime,ReportQty,LastBusinessId);   
    end if;

    if(WorkshopType = 5) then -- 外发回厂
        call MES_Debug('MES_MoveWip_0:外发回厂 ');                 
                        
        update outsource_workstation_bind
            set bind_status = 30,   -- 外发回厂
                back_time = ReqTime
        where outsource_card_id = CardId
          and bind_status = 20;
    end if;

    -- 返回结果    
    call MES_GetWorkDayAndShiftId(ReqTime,TimeOfOriginWork,ShiftId);
    select count(DISTINCT p.rfid_card_id) as total_count,sum(p.qty) as total_qty into totalCount,totalQty
      from production_order_progress p
       where p.workstation_id = WorkstationId
         and p.shift_id = ShiftId
         and p.time_of_origin_work = TimeOfOriginWork
         and p.production_id = QtyCardProductionId;
        
    set RespData=	'3';    
    set RespData = CONCAT(RespData,'|1|已报工|0');
    set RespData = CONCAT(RespData,'|2|',ProductionName,'|0');
    set RespData = CONCAT(RespData,'|3|',ifnull(ReportQty,0),'个,累计',totalCount,'张,',totalQty,'个.|0');
    
    set Success = 0;
    call MES_Debug(CONCAT('MES_ReportWip Result --> Success:',Success));
end;