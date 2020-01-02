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