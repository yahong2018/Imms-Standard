drop procedure if exists MES_VerifyWorkstation;

create procedure MES_VerifyWorkstation(
    in GID              int,
    in DID              int,    
    out WorkstationId   bigint,
    out TemplateIndex   int,
    out RespData     varchar(200)
)
top:begin
    select -1,'',-1 into WorkstationId,RespData,TemplateIndex;
	
	if (select count(*)  from work_organization_unit w
    where w.org_type = 'ORG_WORK_STATION'
      and w.rfid_controller_id = GID
      and w.rfid_terminator_id = DID )>1 then
		
		set RespData = '3'; 
		set RespData = CONCAT(RespData,'|1|组号:',GID,',机号:',DID,'|0');
		set RespData = CONCAT(RespData,'|2|工位重复注册|0');			
		set RespData = CONCAT(RespData,'|3|请联系管理员|0');
        
		leave top;
	end if;	  

    select record_id,rfid_template_index into WorkstationId,TemplateIndex
    from work_organization_unit w
    where w.org_type = 'ORG_WORK_STATION'
      and w.rfid_controller_id = GID
      and w.rfid_terminator_id = DID;

    if (WorkstationId = -1) then		
		set RespData = '2';		
		set RespData = CONCAT(RespData,'|1|组号:',GID,',机号:',DID,'|0');
		set RespData = CONCAT(RespData,'|2|请联系管理员注册|0');
	end if;	   
end;