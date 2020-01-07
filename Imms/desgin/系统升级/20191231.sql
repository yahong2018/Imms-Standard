-- 按照存储区域同步数据给ERP
alter table quality_check add loc_code varchar(20);
alter table work_organization_unit add loc_code varchar(20);

update work_organization_unit
   set loc_code = parent_code
where parent_code <>'THR'
  and org_type = 'ORG_WORK_STATION';

update work_organization_unit
  set loc_code = wocg_code
where parent_code = 'THR'
  and org_type = 'ORG_WORK_STATION';    

-- 开放品质代码维护功能
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS03_03', 'SYS03_03', '品质代码', 'app.view.imms.mfc.defectCode.DefectCode', 3, '', 'SYS03', '0xf02a',0);
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_03', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_03', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_03', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_03', 'DELETE', '删除');

INSERT INTO role_privilege (role_id, program_privilege_id, program_id, privilege_code)
  SELECT
    1,
    prv.record_id,
    prv.program_id,
    prv.privilege_code
  FROM program_privilege prv
  WHERE record_id NOT IN (
    SELECT program_privilege_id  FROM role_privilege
  );

-- 品质记录增加批量新增的功能
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_07', 'BATCH_INSERT', '批量新增');
INSERT INTO role_privilege (role_id, program_privilege_id, program_id, privilege_code)
  SELECT
    1,
    prv.record_id,
    prv.program_id,
    prv.privilege_code
  FROM program_privilege prv
  WHERE record_id NOT IN (
    SELECT program_privilege_id  FROM role_privilege
  );

-- 增加发卡记录
drop procedure if exists MES_IssueCard_2;

create procedure MES_IssueCard_2(
        in SessionId     bigint,    
        in CurrentStep   int,				
        in ReqDataType   int,
        in ReqData       varchar(20),
        out Success      int,    
        out RespData     varchar(200)
)
begin
    declare RfidNo,EmpCardNo varchar(20);
    declare IssueQty,kanbanCount,totalQty int;
    declare CardId,TheNewSessionId,ProductionId bigint;	 
    declare CreateTime,LastProcessTime,ExpireTime datetime;
    declare ProductionName varchar(50);
     
    select -1,'' into Success,RespData;
     
    select s.req_data into RfidNo
        from workstation_session_step s
    where s.workstation_session_id = SessionId
        and s.step = 1
        order by s.record_id desc
        limit 1;

    select c.record_id,c.issue_qty,c.production_id,c.production_name into CardId,IssueQty,ProductionId,ProductionName
        from rfid_card c
    where c.rfid_no = RfidNo
      and c.card_status <> 255;
        
    if (ReqDataType = 4) and (ReqData <> '') then
        set IssueQty = cast(ReqData as UNSIGNED);	
    end if; 
     
    select employee_card_no into EmpCardNo from workstation_session where record_id = SessionId;
        
    update rfid_card
       set issue_qty = IssueQty,
         card_status = 1,
           stock_qty = 0
    where record_id = CardId;

    insert into card_issue(card_id,card_no,issue_user_id,issue_user_code,issue_user_name,workstation_id,workstation_code,workstation_name,issue_qty,create_by_id,create_by_code,create_by_name,create_time,opt_flag)
         select CardId,ReqData,ws.operator_id,ws.employee_id,ws.employee_name,ws.workstation_id,wst.org_code,wst.org_name,IssueQty,1,'SYS','数据采集平台',Now(),0
           from workstation_session ws join work_organization_unit wst on ws.workstation_id = wst.record_id
          where record_id = SessionId;           

    set CreateTime = Now();
    set LastProcessTime = Now();
    set ExpireTime = DATE_ADD(Now(),interval 30 second);
    insert into workstation_session(workstation_id,session_type,current_step,operator_id,employee_id,employee_name,employee_card_no,GID,DID,create_time,last_process_time,expire_time) 
        select workstation_id,session_type,0,operator_id,employee_id,employee_name,employee_card_no,GID,DID,CreateTime,LastProcessTime,ExpireTime
                from workstation_session ws
            where record_id = SessionId;

    set TheNewSessionId = LAST_INSERT_ID();
    
    insert into workstation_session_step(workstation_session_id,step,req_time,req_data_type,req_data,resp_hint,resp_data,resp_time)
        values (TheNewSessionId,0,CreateTime,1,EmpCardNo,'请刷看板',RespData,Now());   

    select count(*),sum(issue_qty)  into kanbanCount,totalQty
     from rfid_card c
     where c.production_id = ProductionId
       and c.card_status = 1; -- 累计已经发放的总数
    
    set RespData= '4';
    set RespData = CONCAT(RespData,'|1|已给看板',RfidNo,'派发|0');
    set RespData = CONCAT(RespData,'|2|',ProductionName,'|0');
    set RespData = CONCAT(RespData,'|3|',IssueQty,'个,共计',kanbanCount,'张,',totalQty,'个.|0');
    set RespData = CONCAT(RespData,'|4|请刷看板继续.|0');

    set Success = 0;
end;

