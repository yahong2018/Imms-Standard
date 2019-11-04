create procedure MES_HandleEmployeeCard(
    in   CardId,
    in   GID,
    in   DID,
    out  RespMessage  varchar(500)
)
begin
    declare OperatorId,WorkshopId,WorkstationId bigint;
    declare EmployeeId,WorkshopCode,WorkstationCode,WocgCode varchar(20);
    declare EmployeeName,WorkshopName,WorkstationName varchar(50);

    set OperatorId = CardId;				
    select o.employee_id,o.employee_name    into EmployeeId,EmployeeName
      from operator o 
     where record_id = OperatorId;		

    /* 如果是员工卡，则新建尾数记录，如果尾数记录已经存在，则更新记录的的相关数据 */                    
    if exists(select * from production_order_progress  where opt_flag = 64 and rfid_terminator_id = DID  and rfid_controller_id = GID) then          
        update production_order_progress
        set operator_id = OperatorId, employee_id = EmployeeId, employee_name = EmployeeName,
            create_by_id = OperatorId, create_by_code = EmployeeId, create_by_name = EmployeeName, create_time = Now()
        where opt_flag = 64
        and rfid_terminator_id = DID
        and rfid_controller_id = GID ;
    else
        select record_id,org_code,org_name,parent_id,parent_code,parent_name,wocg_code
           into WorkstationId,WorkstationCode,WorkstationName,WorkshopId,WorkshopCode,WorkshopName,WocgCode
           from work_organization_unit w
         where w.rfid_controller_id = GID
           and w.rfid_terminator_id = DID;
                                
        insert into production_order_progress(production_order_id,production_order_no,production_id,production_code,production_name,
                    workshop_id,workshop_code,workshop_name,workstation_id,workstation_code,workstation_name,wocg_code,rfid_terminator_id,rfid_controller_id,									
                    time_of_origin,qty,rfid_card_no,report_type,card_qty,operator_id,employee_id,employee_name,
                    create_by_id,create_by_code,create_by_name,create_time,opt_flag)
        values(-1,'',-1,'','',
                WorkshopId,WorkshopCode,WorkshopName,WorkstationId,WorkstationCode,WorkstationName,WocgCode,DID,GID,                   
                DataGatherTime,0,'',1,0,OperatorId,EmployeeId,EmployeeName,
                OperatorId,EmployeeId,EmployeeName,Now(),64);
    end if;
            
    set RespMessage=  '2|1|2';
    set RespMessage = CONCAT(RespMessage,'|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 打开键盘，将键盘的模式设置为多键输入，发声一次
    set RespMessage = CONCAT(RespMessage,'|1|请输入尾数数量|0');	
end;