drop procedure MES_BindOutsourceCard;

create procedure MES_BindOutsourceCard
(
  in      WorkstationId        bigint,  
  in      CardId               bigint,
  in      CardNo               varchar(20),  
  in      Success              int,
  out     RespData             varchar(200)
)
begin
    declare BindRecordId bigint;
    set Success = -1;

    select record_id into BindRecordId from outsource_workstation_bind where workstation_id = WorkstationId and bind_status  = 1;
       
    if (ifnull(BindRecordId,-1) <> -1) then
        update outsource_workstation_bind
          set outsource_card_id = CardId,
              outsource_card_no = CardNo,
              attach_time = Now()
        where record_id = BindRecordId;
    else
        insert into outsource_workstation_bind(outsource_card_id,outsource_card_no,workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,attach_time,bind_status)
            select CardId,CardNo,WorkstationId,org_code,org_name,parent_id,parent_code,parent_name,Now(),3
              from work_organization_unit 
              where record_id = WorkstationId;                
                                                                        
        update rfid_card
            set card_status = 3   -- 已绑定
        where record_id = CardId;
    end if;
    
    set RespData='1';
    set RespData = CONCAT(RespData,'|1|已绑定外发看板|0');  

    set Success = 0;
end;