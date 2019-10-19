
/* *****************************************************************************************************************************/
--
-- 初始化工位:切断
--
/* ****************************************************************************************************************************/

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1501,'WS_QD_01','E/V 切断1号线工位','ORG_WORK_STATION','',21,'WK21_QD','切断',
    4,91,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1502,'WS_QD_02','E/V 切断2号线工位','ORG_WORK_STATION','',21,'WK21_QD','切断',
    4,92,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

