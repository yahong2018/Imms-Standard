
INSERT INTO system_user (user_code, user_name, pwd, user_status, email, last_login_time) VALUES ('C00001', '刘永红', 'e10adc3949ba59abbe56e057f20f883e', 0, 'liuyonghong@zhxh.com', NULL);
set @user_id = LAST_INSERT_ID();

INSERT INTO system_role (role_code, role_name) VALUES ('admin', '系统管理员');
set @role_id=LAST_INSERT_ID();

INSERT INTO role_user (role_id, user_id) VALUES (@role_id, @user_id);

INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters,  parent_id, glyph,program_status) VALUES ('SYS01','SYS01', '系统管理', '', 0, '', '', '0xf013',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters,  parent_id, glyph,program_status) VALUES ('SYS01_01','SYS01_01', '用户管理', 'app.view.admin.systemUser.SystemUser', 0, '', 'SYS01', '0xf007',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status)  VALUES ('SYS01_02','SYS01_02', '角色管理', 'app.view.admin.systemRole.SystemRole', 1, '', 'SYS01', '0xf233',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status)  VALUES ('SYS01_03','SYS01_03', '系统参数', 'app.view.admin.systemParameter.SystemParameter', 2, '','SYS01', '0xf085',0);

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01', 'RUN', '系统运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_01', 'RUN', '系统运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_01', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_01', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_01', 'DELETE', '删除');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_01', 'STOP_USER', '暂停账户');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_01', 'START_USER', '启用账户');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_01', 'RESET_PASSWORD', '重设密码');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_01', 'ASSIGN_ROLE', '授权');

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_02', 'RUN', '系统运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_02', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_02', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_02', 'DELETE', '删除');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_02', 'ASSIGN_ROLE', '授权');

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_03', 'RUN', '系统运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_03', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_03', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS01_03', 'DELETE', '删除');

-- ----------------------------------------------------------------------------------------------------------------------

INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status)VALUES ('SYS02','SYS02', '组织架构', '', 1, '', '', '0xf0e8',0);
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02', 'RUN', '运行');

INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS02_01', 'SYS02_01', '车间与工位', 'app.view.imms.org.Organization', 0, '',  'SYS02', '0xf1ad',0);
-- INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph) VALUES ('SYS02_02', 'SYS02_02', '工位管理', 'app.view.imms.org.workstation.Workstation', 1, '', 'SYS02', '0xf239',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS02_03', 'SYS02_03', '操作员管理', 'app.view.imms.org.operator.Operator',2, '', 'SYS02', '0xf2be',0);
-- INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph) VALUES ('SYS02_04', 'SYS02_04', '工位机登录记录', 'app.view.imms.org.workstationLogin.WorkstationLogin',3, '', 'SYS02', '0xf090',0);

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_01', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_01', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_01', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_01', 'DELETE', '删除');

-- INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_02', 'RUN', '运行');
-- INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_02', 'INSERT', '新增');
-- INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_02', 'UPDATE', '修改');
-- INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_02', 'DELETE', '删除');

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_03', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_03', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_03', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_03', 'DELETE', '删除');

-- INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_04', 'RUN', '运行');
-- INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_04', 'DELETE', '删除');
-- INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS02_04', 'DELETE_ALL', '清理');

-- ----------------------------------------------------------------------------------------------------------------------

INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status)VALUES ('SYS03','SYS03', '生产管理', '', 2, '',  '', '0xf0ae',0);
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03', 'RUN', '运行');
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS03_01', 'SYS03_01', '产品管理', 'app.view.imms.material.material.Material', 1, '', 'SYS03', '0xf1d0',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS03_02', 'SYS03_02', '发卡管理', 'app.view.imms.mfc.rfidCard.RfidCard', 2, '', 'SYS03', '0xf2c3',0);
-- INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph) VALUES ('SYS03_03', 'SYS03_03', '看板条码', 'app.view.imms.mfc.barcode.Barcode', 3, '', 'SYS03', '0xf02a',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS03_04', 'SYS03_04', '生产计划', 'app.view.imms.mfc.productionOrder.ProductionOrder', 4, '', 'SYS03', '0xf03a',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS03_05', 'SYS03_05', '生产实绩', 'app.view.imms.mfc.productionOrderProgress.ProductionOrderProgress', 5, '', 'SYS03', '0xf0cb',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS03_06', 'SYS03_06', '移库记录', 'app.view.imms.mfc.productionMoving.ProductionMoving', 6, '', 'SYS03', '0xf218',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS03_07', 'SYS03_07', '生产品质', 'app.view.imms.mfc.qualityCheck.QualityCheck', 7, '', 'SYS03', '0xf00e',0);


INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_01', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_01', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_01', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_01', 'DELETE', '删除');

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_02', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_02', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_02', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_02', 'DELETE', '删除');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_02', 'ExcelImport', '导入看板');

-- INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_03', 'RUN', '运行');
-- INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_03', 'INSERT', '新增');
-- INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_03', 'PRINT', '打印');
-- INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_03', 'DELETE', '删除');

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_04', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_04', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_04', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_04', 'DELETE', '删除');

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_05', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_05', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_05', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_05', 'DELETE', '删除');

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_06', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_06', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_06', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_06', 'DELETE', '删除');

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_07', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_07', 'INSERT', '新增');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_07', 'UPDATE', '修改');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_07', 'DELETE', '删除');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS03_07', 'TO_ERP', '同步给ERP');

-- ----------------------------------------------------------------------------------------------------------------------

INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status)VALUES ('SYS04','SYS04', '分析报表', '', 3, '',  '', '0xf02f',0);
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS04', 'RUN', '运行');

INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS04_01', 'SYS04_01', '生产进度表', 'app.view.imms.rpt.rptProductionOrderProgress.RptProductionOrderProgress', 1, '', 'SYS04', '0xf0ae',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS04_02', 'SYS04_02', '品质分析表', 'app.view.imms.rpt.rptQuality.RptQuality', 2, '', 'SYS04', '0xf200',1);

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS04_01', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS04_01', 'PRINT','打印');

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS04_02', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS04_02', 'PRINT', '打印');
-- --------------------------------------------------------------------------------------------------------------------
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status)VALUES ('SYS05','SYS05', '模拟器', '', 4, '',  '', '0xf02f',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS05_01', 'SYS05_01', '压铸', 'app.view.imms.mfc.simulator.LineYZ', 1, '', 'SYS05', '0xf1ec',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS05_02', 'SYS05_02', '粗加工', 'app.view.imms.mfc.simulator.LineCJG', 2, '', 'SYS05', '0xf1b3',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS05_03', 'SYS05_03', 'M/C加工', 'app.view.imms.mfc.simulator.LineMC', 3, '', 'SYS05', '0xf207',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS05_04', 'SYS05_04', 'THR', 'app.view.imms.mfc.simulator.LineTHR', 4, '', 'SYS05', '0xf1ce',0);
INSERT INTO system_program (record_id,program_code, program_name, url, show_order, parameters, parent_id, glyph,program_status) VALUES ('SYS05_05', 'SYS05_05', '仓库(THR)', 'app.view.imms.mfc.simulator.LineCK_THR', 5, '', 'SYS05', '0xf11d',0);

INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS05', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS05_01', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS05_02', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS05_03', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS05_04', 'RUN', '运行');
INSERT INTO program_privilege (program_id, privilege_code, privilege_name) VALUES ('SYS05_05', 'RUN', '运行');

-- --------------------------------------------------------------------------------------------------------------------

set @role_id = 1;
INSERT INTO role_privilege (role_id, program_privilege_id, program_id, privilege_code)
  SELECT
    @role_id,
    prv.record_id,
    prv.program_id,
    prv.privilege_code
  FROM program_privilege prv
  WHERE record_id NOT IN (
    SELECT program_privilege_id  FROM role_privilege
  )

-- --------------------------------------------------------------------------------------------------------------------

