create procedure MES_ReportWip(
  in    WorkstationId        bigint,              -- 报工工位
  in    WorkshopType         int,  
  in    CardId               bigint,              -- RFID  
  in    CardType             int,
  in    CardStatus           int,
  in    ReqTime              datetime,            -- 报工时间
  out   RespData             varchar(200)  
)
top:begin
    declare ReportQty int;
    declare BindId,OutSourceCardProductionId,QtyCardProductionId,LastBusinessId,LogId  bigint;    
    declare QtyCardProductionCode,RfidNo varchar(20);
    
    set RespData = '';   

    if (WorkshopType in (1,5)) then  -- 工程内车间、外发后工程车间 
        call MES_Debug('MES_ReportWip:工程内车间、外发后工程车间 ',LogId);  
        call MES_ReportWip_0(WorkstationId,CardId,ReqTime,ReportQty,LastBusinessId);
    elseif(WorkshopType = 3) then   -- 外发前工程车间的工程内看板报工
        select rfid_no,production_id,production_code into RfidNo,QtyCardProductionId,QtyCardProductionCode
           from rfid_card
        where record_id = CardId; 

        -- 外发前工程，必须先有相应的绑定记录     
        select b.record_id, c.production_id into BindId, OutSourceCardProductionId
          from outsource_workstation_bind b join rfid_card  c on b.outsource_card_id = c.record_id                                            
         where b.workstation_id = WorkstationId and b.bind_status < 20;        
        set OutSourceCardProductionId = ifnull(OutSourceCardProductionId,-1);

        if (OutSourceCardProductionId = -1) or (not exists( select * from material m
           where m.record_id = OutSourceCardProductionId
             and m.prev_material_id = QtyCardProductionId)) then
            set RespData=	'2|1|4';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|工位没有绑定对应|0');     
            set RespData = CONCAT(RespData,'|2|产品',QtyCardProductionCode,'|0');     
            set RespData = CONCAT(RespData,'|3|的外发看板|0');     

            leave top;
        end if;

        -- 进行报工 
        call MES_Debug('MES_ReportWip_1:外发前工程车间的工程内看板报工 ',LogId);                 
        call MES_ReportWip_1(WorkstationId,BindId,CardId,RfidNo,ReqTime,ReportQty,LastBusinessId);   
    end if;

    if(WorkshopType = 5) then -- 外发回厂
         /*  1.  进行报工 已经执行了
             2.  进行移库    
             3.  修改工位绑定状态
        */
        call MES_Debug('MES_MoveWip_0:外发回厂 ',LogId);                 
        call MES_MoveWip_0(WorkstationId,CardId,ReqTime,ReportQty,LastBusinessId);  -- 移库
        
        update outsource_workstation_bind
          set bind_status = 30,
              back_time = ReqTime
        where outsource_card_id = CardId
          and bind_status = 20;          
    end if;

    -- 返回结果    
    set RespData=	'2|1|2';
    set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  
    set RespData = CONCAT(RespData,'|1|已报工',ifnull(ReportQty,0),'个|0');     
end;