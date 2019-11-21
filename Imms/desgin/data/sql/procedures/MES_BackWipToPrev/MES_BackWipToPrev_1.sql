drop procedure MES_BackWipToPrev_1;

create procedure MES_BackWipToPrev_1
(    
    in WorkstationId bigint,
    in ReqDataType   int,	
    in CardId        bigint,		
    out Success      int,
    out RespHint     varchar(200),
    out RespData     varchar(200)   
)
top:begin
    -- 1.校验数量卡
    -- 2.提示输入退还数量    
    declare CardStatus int default -1;
    declare CardWorkshopId,WorkshopId bigint;
    declare CardWorkshopName varchar(50);

    select -1,'' into Success,RespData;		
    
    if(ReqDataType <> 2) then
        call MES_BackWipToPrev_0(Success,RespData);
        leave top;
    end if;
    
    select c.card_status,c.workshop_id,c.workshop_name into CardStatus,CardWorkshopId,CardWorkshopName
      from  rfid_card c
    where c.record_id = CardId;

    select parent_id into WorkshopId  from work_organization_unit where record_id = WorkstationId;

    if(CardWorkshopId <> WorkshopId) then
        set RespData='2';        
        set RespData = CONCAT(RespData,'|1|只有在车间:',CardWorkshopName,'|0');					   
        set RespData = CONCAT(RespData,'|2|才可以退本卡.|0');					   
               
        leave top;       
    end if;   
    
    set RespData='1';    
    set RespData = CONCAT(RespData,'|1|请输入退还数量|0');
    set RespHint = '请输入退还数量';
    
    set Success = 0;
end;