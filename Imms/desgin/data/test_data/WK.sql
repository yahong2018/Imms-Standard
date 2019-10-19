
/* *****************************************************************************************************************************/
--
--  初始化车间与工艺路线
--
-- -----------------------------------------------------------------------------------------------------------------------------

-- 第1个系列 : 压铸
insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1,'WK01_YZ','压铸','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(2,'WK02_CJG','粗加工','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(3,'WK03_MC','MC加工','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(4,'WK04_THR','THR','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(5,'WK05_CK_THR','仓库(THR)','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- 第2个系列 : 切断
insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(21,'WK21_QD','切断','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(22,'WK22_DZ','锻造','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(23,'WK23_EV_A','E/V前工程','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(24,'WK24_EV','EV渗氮','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(25,'WK25_EV_B','E/V后工程','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(26,'WK26_CK_EV','仓库(E/V)','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


-- 第3个系列 : 注塑
insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(41,'WK41_ZS','注塑','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(42,'WK42_ZZ','组装','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(43,'WK43_CK_ZZ','仓库(组装)','ORG_WORK_SHOP','',0,null,null,
    0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


