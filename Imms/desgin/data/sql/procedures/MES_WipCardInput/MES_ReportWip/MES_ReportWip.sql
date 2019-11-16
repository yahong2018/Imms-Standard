drop procedure MES_ReportWip;

create procedure MES_ReportWip(
  in    WorkstationId        bigint,              -- 报工工位
  in    WorkshopType         int,  
  in    CardId               bigint,              -- RFID  
  in    CardType             int,
  in    CardStatus           int,
  in    ReqTime              datetime,            -- 报工时间  
  out   Success              int,
  out   RespData             varchar(200)  
)
top:begin
    declare ReportQty int;
    declare BindId,OutSourceCardProductionId,QtyCardProductionId,LastBusinessId  bigint;    
    declare QtyCardProductionCode,RfidNo varchar(20);
    declare ProductionName varchar(50);
    
    select '',-1 into RespData,Success;   

    select c.rfid_no,c.production_id,c.production_code,c.production_name 
           into RfidNo,QtyCardProductionId,QtyCardProductionCode,ProductionName
      from rfid_card c
    where c.record_id = CardId; 

    if (WorkshopType in (1,5)) then  -- 工程内车间、外发后工程车间 
        call MES_Debug('MES_ReportWip:工程内车间、外发后工程车间 ');  
        call MES_ReportWip_0(WorkstationId,CardId,ReqTime,ReportQty,LastBusinessId);
    elseif(WorkshopType = 3) then   -- 外发前工程车间的工程内看板报工
        -- 外发前工程，必须先有相应的绑定记录     
        select b.record_id, c.production_id into BindId, OutSourceCardProductionId
          from outsource_workstation_bind b join rfid_card  c on b.outsource_card_id = c.record_id                                            
         where b.workstation_id = WorkstationId and b.bind_status < 20;        
        set OutSourceCardProductionId = ifnull(OutSourceCardProductionId,-1);

        if (OutSourceCardProductionId = -1) or (not exists( select * from material m
           where m.record_id = OutSourceCardProductionId
             and m.prev_material_id = QtyCardProductionId)) then
            set RespData=	'3';            
            set RespData = CONCAT(RespData,'|1|工位没有绑定对应|0');     
            set RespData = CONCAT(RespData,'|2|产品',QtyCardProductionCode,'|0');     
            set RespData = CONCAT(RespData,'|3|的外发看板|0');                 

            leave top;
        end if;

        -- 进行报工 
        call MES_Debug('MES_ReportWip_1:外发前工程车间的工程内看板报工 ');                 
        call MES_ReportWip_1(WorkstationId,BindId,CardId,RfidNo,ReqTime,ReportQty,LastBusinessId);   
    end if;

    if(WorkshopType = 5) then -- 外发回厂
         /*  1.  进行报工 已经执行了
             2.  进行移库    
             3.  修改工位绑定状态
        */
        call MES_Debug('MES_MoveWip_0:外发回厂 ');                 
        call MES_MoveWip_0(WorkstationId,CardId,ReqTime,ReportQty,LastBusinessId);  -- 移库
        
        update outsource_workstation_bind
          set bind_status = 30,
              back_time = ReqTime
        where outsource_card_id = CardId
          and bind_status = 20;          
    end if;

    -- 返回结果    
    set RespData=	'3';    
    set RespData = CONCAT(RespData,'|1|已报工|0');
    set RespData = CONCAT(RespData,'|2|',ProductionName,'|0');
    set RespData = CONCAT(RespData,'|3|',ifnull(ReportQty,0),'个|0');

    set Success = 0;

    call MES_Debug(CONCAT('MES_ReportWip Result --> Success:',Success));
end;