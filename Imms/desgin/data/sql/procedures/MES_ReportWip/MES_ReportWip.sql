create procedure MES_ReportWip(
  in    WorkstaitonId        bigint,              -- 报工工位
  in    CardId               bigint,              -- RFID  
  in    CardType             int,
  in    CardStatus           int,
  in    ReqTime              datetime,            -- 报工时间
  out   RespData             varchar(200)  
)
top:begin
    declare WorkshopType,ReportQty int;
    declare OutSourceCardProductionId,QtyCardProductionId,LastBusinessId  bigint;  
    
    set RespData = '';

    select workshop_type into WorkshopType
      from work_organization_unit
    where record_id in (
        select parent_Id from work_organization_unit where record_id = WorkstaitonId
    );    

    if (CardType = 2) and (not CardStatus in (1,2)) then
        set RespData=	'2|1|2';
        set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
        set RespData = CONCAT(RespData,'|1|卡没有派发|0');            

        leave top;
    elseif(CardType = 3)then
        if CardStatus <> 20 then
            set RespData=	'2|1|3';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|外发看板必须先外发|0');            
            set RespData = CONCAT(RespData,'|2|才可以回厂打卡|0'); 
            
            leave top;
        end if;

        if WorkshopType <> 3 then
            set RespData=	'2|1|2';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|非后工程车间|0');            
            leave top;        
        end if;
    end if;

    if WorkshopType in (0,5) then  -- 工程内车间、外发后工程车间  
        call MES_DoReportWip_0(WorkstationId,CardId,ReqTime,ReportQty);        
    else  -- 外发前工程车间
        -- 外发前工程，必须先有相应的绑定记录     
        select OutSourceCardProductionId into OutSourceCardProductionId
         from outsource_workstation_bind
        where workstation_id = WorkstationId
          and bind_status < 20;   
        if ifnull(OutSourceCardProductionId,-1) = -1 then
            set RespData=	'2|1|2';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|工位没有绑定外发看板|0');     

            leave top;
        end if;
         
        -- 报工产品必须与外发产品是同一个产品
        select production_id into QtyCardProductionId
           from rfid_card
        where record_id = CardId; 
        if(OutSourceCardProductionId<>QtyCardProductionId) then
            set RespData=	'2|1|3';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|当前产品与绑定的|0');     
            set RespData = CONCAT(RespData,'|2|外发产品不一致|0');

            leave top;
        end if;

        -- 进行报工
        call MES_DoReportWip_1(WorkstationId,CardId,ReqTime,ReportQty);   
    end if;

    if(WorkshopType = 5) then -- 外发回厂
        /*   1.  进行报工 已经执行了
             2.  进行移库    
             3.  修改工位绑定状态
        */
        select last_business_id into LastBusinessId
          from rfid_card 
          where record_id = CardId;

        call MES_DoMoveWip(WorkstationId,LastBusinessId,WorkshopType,CardId,ReqTime,ReportQty);  -- 移库
        
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