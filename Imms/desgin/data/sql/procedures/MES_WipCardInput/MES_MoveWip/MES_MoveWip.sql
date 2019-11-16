drop procedure MES_MoveWip;

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
    declare BindRecordId,LastBusinessId,LogId bigint;
    declare ProductionName varchar(50);

    select '',-1 into RespData,Success;
   
    select c.last_business_id into LastBusinessId
      from rfid_card c
    where c.record_Id = CardId;
        
    if (CardType = 3) and (WorkshopType = 3) then   -- 外发移库
        set LastBusinessId = -1;
        call MES_Debug('MES_MoveWip_0:外发移库',LogId);	
        call MES_MoveWip_0(WorkstationId,CardId,ReqTime,MovedQty,LastBusinessId);
    else  
         -- 工程内
        if(ifnull(LastBusinessId,-1) = -1) then
            set RespData= '2';            
            set RespData = CONCAT(RespData,'|1|看板移库异常：|0');            
            set RespData = CONCAT(RespData,'|2|不存在报工记录！|0');               
            
            leave top;
        end if;

        call MES_Debug('MES_MoveWip_0:工程内移库',LogId);	
        call MES_MoveWip_0(WorkstationId,CardId,ReqTime,MovedQty,LastBusinessId);        
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

    select production_name into ProductionName
      from rfid_card
    where record_id = CardId;

    set RespData=	'3';            
    set RespData = CONCAT(RespData,'|1|已移库|0');
    set RespData = CONCAT(RespData,'|2|',ProductionName,'|0');
    set RespData = CONCAT(RespData,'|3|',ifnull(MovedQty,0),'个|0'); 

    set Success = 0;              
end;