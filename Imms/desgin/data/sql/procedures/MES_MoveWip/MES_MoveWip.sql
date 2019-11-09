create procedure MES_DoMoveWip
(
  in    WorkstaitonId        bigint,              -- 报工工位
  in    CardId               bigint,              -- RFID  
  in    CardType             int,
  in    CardStatus           int,
  in    ReqTime              datetime,            -- 移库时间
  out   RespData             varchar(200)  
)
begin
    declare WorkshopType,MovedQty int;
    declare BindRecordId,LastBusinessId bigint;

    if CardStatus <> 10 then
        set RespData=	'2|1|3';
        set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
        set RespData = CONCAT(RespData,'|1|只有报工的看板|0');            
        set RespData = CONCAT(RespData,'|2|才可以移库|0');            

        leave top;
    end if;
    
    if CardType = 3 then  
        -- 外发移库
        call MES_DoMoveWip(WorkstaitonId,-1,CardId,ReqTime,MovedQty);
    else  
         -- 工程内
        select last_business_id into LastBusinessId 
          from rfid_card
        where record_id = CardId;

        if(ifnull(LastBusinessId,-1) = -1) then
            set RespData=	'2|1|3';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|看板移库异常：|0');            
            set RespData = CONCAT(RespData,'|2|不存在报工记录！|0');               

            leave top;
        end if;

        call MES_DoMoveWip(WorkstationId,LastBusinessId,CardId,ReqTime,MovedQty);        
    end if;

    if (CardType = 3) then    
        -- 要将所有绑定的工程内看板也一并进行移库            
        select record_id into BindRecordId
        from outsource_workstation_bind
        where outsource_card_id = CardId
          and bind_status = 10;    
        
        update rfid_card
          set card_status = 20
        where record_id in (
            select  qty_card_id from  outsource_card_bind
               where workstation_bind_id = BindRecordId
        );

        -- 更新工位绑定记录的状态
        update outsource_workstation_bind
          set bind_status = 20,
              back_time = ReqTime
        where outsource_card_id = CardId
          and bind_status = 10;          
    end if;

    set RespData=	'2|1|2';
    set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
    set RespData = CONCAT(RespData,'|1|已经移库',ifnull(MovedQty,0),'个|0');                
end;