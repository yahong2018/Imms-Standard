drop procedure if exists MES_MoveWip;

create procedure MES_MoveWip
(
    in    WorkstationId        bigint,              -- 报工工位  
    in    WorkshopType         int,  
    in    CardId               bigint,              -- RFID  
    in    CardType             int,
    in    CardStatus           int,
    in    ReqTime              datetime,            -- 移库时间  
    out   Success              int,
    out   RespData             varchar(200)  
)
top:begin
    declare MovedQty int;
    declare BindRecordId,LastBusinessId bigint;
    declare ProductionName varchar(50);

    select '',-1 into RespData,Success;
    
    select c.last_business_id into LastBusinessId
        from rfid_card c
    where c.record_Id = CardId;
            
    if (WorkshopType = 4) and (CardType = 3 ) then   -- 外发移库
        set LastBusinessId = -1;
        call MES_Debug('MES_MoveWip_0:外发移库');	
        call MES_MoveWip_0(WorkstationId,CardId,ReqTime,MovedQty,LastBusinessId);
    
        -- 外发移库，不是将外发看板的状态修改为已移库，而是修改其绑定的看板的状态
        -- 要把外发看板的库存数修改回0,把其外发数量修改为移库数量
        update rfid_card
          set card_status = 4,
              stock_qty = 0,   
              outsource_qty = MovedQty 
        where record_id = CardId;      

        -- 要将所有绑定的工程内看板一并进行移库
        select record_id into BindRecordId
        from outsource_workstation_bind
        where outsource_card_id = CardId
            and bind_status = 10;
        
        update rfid_card
            set card_status = 20
        where record_id in (
            select qty_card_id 
                from outsource_card_bind
                where workstation_bind_id = BindRecordId
        );

        -- 更新工位绑定记录的状态
        update outsource_workstation_bind
            set bind_status = 20,
                back_time = ReqTime
        where outsource_card_id = CardId
            and bind_status = 10; 
    else  
        call MES_Debug('MES_MoveWip_0:工程内移库');	
        call MES_MoveWip_0(WorkstationId,CardId,ReqTime,MovedQty,LastBusinessId);        
    end if;

    select production_name into ProductionName
        from rfid_card
    where record_id = CardId;

    set RespData=	'3';            
    set RespData = CONCAT(RespData,'|1|已投入(外发)|0');
    set RespData = CONCAT(RespData,'|2|',ProductionName,'|0');
    set RespData = CONCAT(RespData,'|3|',ifnull(MovedQty,0),'个|0'); 

    set Success = 0;              
end;