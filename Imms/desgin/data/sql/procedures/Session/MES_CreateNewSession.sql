create procedure MES_CreateNewSession(
    in   WorkstationId        bigint,   
    in   ReqDataType          int,          -- 1. 工卡    2.数量卡   3.委外加工卡    4.键盘输入    
    in   ReqData              varchar(20),  -- 卡号或者键盘输入的数字    
    in   CardId               bigint,        -- 如果ReqDataType是 [1,2,3]，则表示卡的Id,
    in   ReqTime              datetime,
    out  SessionId            bigint
)
begin
  declare OperatorId bigint default -1;
  declare EmployeeId,EmployeeCardNo varchar(20) default '';
  declare EmployeeName varchar(50) default '';
  declare CreateTime,LastProcessTime,ExpireTime datetime default Now();
  declare SessionType,CurrentStep int default -1; -- -1表示未知

  set ExpireTime = DATE_ADD(CreateTIme,interval 1 minute);

  if (ReqDataType = 1) then
    select o.record_id,o.employee_id,o.employee_name,ReqData into OperatorId,EmployeeId,EmployeeName,EmployeeCardNo
       from operator o
       where record_id = CardId;
  end if;

  insert into workstation_session(workstation_id,session_type,current_step,
                                  operator_id,employee_id,employee_name,employee_card_no,
                                  create_time,last_process_time,expire_time) 
                           values(WorkstationId,SessionType,CurrentStep,
                                  OperatorId,EmployeeId,EmployeeName,EmployeeCardNo,
                                  CreateTime,LastProcessTime,ExpireTime);
  set SessionId = LAST_INSERT_ID();                                    
end;