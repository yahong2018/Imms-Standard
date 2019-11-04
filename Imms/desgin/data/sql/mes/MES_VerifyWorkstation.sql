create procedure MES_VerifyWorkstation(
    in GID              int,
    in DID              int,
    out WorkstationId   int,
    out RespMessage varchar(500)
)
top:begin
  set WorkstationId = -1;
	
	if (select count(*)  from work_organization_unit w
    where w.org_type = 'ORG_WORK_STATION'
      and w.rfid_controller_id = GID
      and w.rfid_terminator_id = DID )>1 then
		
		set RespMessage = '2|1|4';
		set RespMessage = CONCAT(RespMessage,'|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
		set RespMessage = CONCAT(RespMessage,'|1|组号:',GID,',机号:',DID,'|0');
		set RespMessage = CONCAT(RespMessage,'|2|工位重复注册|0');			
		set RespMessage = CONCAT(RespMessage,'|3|请联系管理员|0');	

		leave top;
	end if;	  

  select record_id into WorkstationId
    from work_organization_unit w
    where w.org_type = 'ORG_WORK_STATION'
      and w.rfid_controller_id = GID
      and w.rfid_terminator_id = DID;

  if (WorkstationId = -1) then		
		set RespMessage = '2|1|3';
		set RespMessage = CONCAT(RespMessage,'|210|128|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
		set RespMessage = CONCAT(RespMessage,'|1|组号:',GID,',机号:',DID,'|0');
		set RespMessage = CONCAT(RespMessage,'|2|请联系管理员注册|0');			
    
	end if;	  
end;

