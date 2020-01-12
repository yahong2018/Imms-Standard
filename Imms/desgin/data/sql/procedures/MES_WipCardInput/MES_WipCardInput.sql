drop procedure if exists MES_WipCardInput;

create procedure MES_WipCardInput(
    in     WorkstationId       bigint,
    in     CardType            int,           -- 1. 工卡    2. 工程内看板    3.外发看板   4.键盘输入
    in     RfidNo              varchar(20),
    in     CardId              bigint,
    in     ReqTime             datetime,
    out    Success             int,
    out    RespData            varchar(200)
)
top:begin
    declare CardStatus,WorkshopType,WorkshopOpIndex,WorkshopPreIndex,CardOpIndex,CardPreOpIndex,ReportQty int;
    declare CardWorkshopId,WorkshopId,LastBusinessId bigint;
    declare CardWorkshopName varchar(50);
    declare CardStatusName varchar(20);

    select '',-1 into RespData,Success;

    select c.workshop_id,c.workshop_name,c.card_status,w.operation_index,w.prev_operation_index
         into CardWorkshopId,CardWorkshopName,CardStatus,CardOpIndex,CardPreOpIndex
      from rfid_card c join work_organization_unit w on c.workshop_id = w.record_id
    where c.record_id = CardId;

    select w.record_id,w.workshop_type,w.operation_index,w.prev_operation_index
            into WorkshopId, WorkshopType,WorkshopOpIndex,WorkshopPreIndex
      from work_organization_unit w
      where w.record_id = (
        select parent_Id from work_organization_unit where record_id = WorkstationId
    );
  
    call MES_ParseCardStatus(CardStatus,CardStatusName);
    if (CardStatus = 0) then
        set RespData= '3';
        set RespData = CONCAT(RespData,'|1|看板的状态为:',CardStatusName,'|0');
        set RespData = CONCAT(RespData,'|2|后工程派发以后|0');
        set RespData = CONCAT(RespData,'|3|才可以报工和移库.|0');

        leave top;
    end if;

    -- 外发绑卡
    if (CardType = 3) then
        if CardStatus = 1 then
            if(WorkshopType <> 3) then
                set RespData= '2';
                set RespData = CONCAT(RespData,'|1|只有外发前工程车间|0');
                set RespData = CONCAT(RespData,'|2|才可以绑定外发看板|0');

                leave top;
            end if;

            if(WorkshopOpIndex <> CardPreOpIndex) then
                set RespData= '2';
                set RespData = CONCAT(RespData,'|1|该外发看板不能|0');
                set RespData = CONCAT(RespData,'|2|在本车间绑卡|0');

                leave top;
            end if;   
        end if;    
    end if;    

    if (CardOpIndex = WorkshopOpIndex) then 
        if (CardType = 2) and not(CardStatus in (1,2)) then -- 工程内看板，在报工以后不可以再次报工
            set RespData= '3';
            set RespData = CONCAT(RespData,'|1|看板的状态为:',CardStatusName,'|0');
            set RespData = CONCAT(RespData,'|2|后工程移库派发|0');
            set RespData = CONCAT(RespData,'|3|以后才可以报工.|0');

            leave top;
        end if;

        if(CardType = 3) and (CardStatus not in(3,4)) then  -- 外发看板
            set RespData= '3';
            set RespData = CONCAT(RespData,'|1|外发看板必须前工程|0');
            set RespData = CONCAT(RespData,'|2|报工以后才可以外发|0');            
            set RespData = CONCAT(RespData,'|3|和报工|0');            

            leave top;        
        end if;
    end if;

    if (CardOpIndex < WorkshopOpIndex) and not (CardStatus in (2,10)) then
        set RespData= '3';
        set RespData = CONCAT(RespData,'|1|看板的状态为:',CardStatusName,'|0');
        set RespData = CONCAT(RespData,'|2|前工程报工以后,|0');
        set RespData = CONCAT(RespData,'|3|才可以移库.|0');

        leave top;
    elseif((CardType = 2) and (CardOpIndex > WorkshopOpIndex)) then -- 工程内看板
        set RespData= '2';
        set RespData = CONCAT(RespData,'|1|本看板可以报工的车间:|0');
        set RespData = CONCAT(RespData,'|2|',CardWorkshopName,'|0');

        leave top;        
    end if;   
    
    if(CardType = 3) and (CardStatus = 1) then  -- 外发绑卡
        call MES_Debug('MES_BindOutsourceCard:外发绑卡');
        call MES_BindOutsourceCard(WorkstationId,CardId,RfidNo,Success,RespData);
    elseif (CardType = 3) and (CardStatus = 3) and (WorkshopType = 4)then -- 打卡外发
        call MES_Debug('MES_MoveWip:打卡外发');        
        call MES_MoveWip(WorkstationId,WorkshopType,CardId,CardType,CardStatus,ReqTime,Success,RespData); 
    elseif ((CardStatus in (1,2,4)) and (CardOpIndex = WorkshopOpIndex)) then  -- 报工
        call MES_Debug('MES_ReportWip:报工(回厂)');
        set ReportQty = -1;
        call MES_ReportWip(WorkstationId,WorkshopType,CardId,CardType,CardStatus,ReqTime,ReportQty,LastBusinessId,Success,RespData);
    elseif((CardStatus in (2,10)) and (CardOpIndex <> WorkshopOpIndex)) then  -- 移库
        call MES_Debug('MES_MoveWip:移库(投入)');
        call MES_MoveWip(WorkstationId,WorkshopType,CardId,CardType,CardStatus,ReqTime,Success,RespData); 
    end if;

    call MES_Debug(CONCAT('MES_WipCardInput Result --> Success:',Success));
end;
