create procedure MES_BindOutsourceCard
(
  in      WorkstationId        bigint,  
  in      CardId               bigint,
  in      CardNo               varchar(20),
  out     RespData             varchar(200)
)
begin
    declare BindRecordId bigint;

    select record_id into BindRecordId from outsource_workstation_bind where workstation_id = WorkstationId and bind_status  = 1;
       
    if (ifnull(BindRecordId,-1) <> -1) then
        update outsource_workstation_bind
          set outsource_card_id = CardId,
              outsource_card_no = CardNo,
              attach_time = Now()
        where record_id = BindRecordId;
    else              
        insert into outsource_workstation_bind(outsource_card_id,outsource_card_no,workstation_id,workstation_code,workstation_name,attach_time,bind_status)
            select CardId,CardNo,WorkstationId,workstation_code,workstation_name,Now(),3
              from work_organization_unit 
              where record_id = WorkstationId;                
                                                                        
        update rfid_card
            set card_status = 3   -- 已绑定
        where record_id = CardId;
    end if;
    
    set RespData=	'2|1|2';
    set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
    set RespData = CONCAT(RespData,'|1|已绑定外发看板|0');  
end;