/* *****************************************************************************************************************************/
--
-- 初始化工位: 粗加工
--
/* ****************************************************************************************************************************/

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1201,'WS_CJG_01','粗加工1线工位','ORG_WORK_STATION','',2,'WK02_CJG','粗加工',
    1,21,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1202,'WS_CJG_02','粗加工2线工位','ORG_WORK_STATION','',2,'WK02_CJG','粗加工',
    1,22,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1203,'WS_CJG_03','粗加工3线工位','ORG_WORK_STATION','',2,'WK02_CJG','粗加工',
    1,23,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1204,'WS_CJG_04','粗加工4线工位','ORG_WORK_STATION','',2,'WK02_CJG','粗加工',
    1,24,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1230,'WS_CJG_YK','粗加工手持移库','ORG_WORK_STATION','',2,'WK02_CJG','粗加工',
    1,30,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);
