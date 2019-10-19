
/* *****************************************************************************************************************************/
--
-- 初始化工位:E/V 工程
--
/* ****************************************************************************************************************************/

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1701,'WS_EV_A_01','E/V 1线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,121,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1702,'WS_EV_A_02','E/V 1线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,122,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1703,'WS_EV_B_03','E/V 1线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    5,123,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1704,'WS_EV_A_04','E/V 2线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,124,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1705,'WS_EV_A_05','E/V 2线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,125,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1706,'WS_EV_B_06','E/V 2线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    5,126,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1707,'WS_EV_A_07','E/V 3线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,127,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1708,'WS_EV_A_08','E/V 3线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,128,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1709,'WS_EV_B_09','E/V 3线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    5,129,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1710,'WS_EV_A_10','E/V 4线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,130,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1711,'WS_EV_A_11','E/V 4线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,131,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1712,'WS_EV_A_12','E/V 4线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    5,132,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1713,'WS_EV_A_13','E/V 5线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,133,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1714,'WS_EV_A_14','E/V 5线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,134,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1715,'WS_EV_A_15','E/V 5线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    5,135,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1716,'WS_EV_A_16','E/V 6线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,136,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1717,'WS_EV_A_17','E/V 6线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,137,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1718,'WS_EV_A_18','E/V 6线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    5,138,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1719,'WS_EV_A_19','E/V 7线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,139,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1720,'WS_EV_A_20','E/V 7线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,140,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1721,'WS_EV_A_21','E/V 7线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    5,141,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1722,'WS_EV_A_22','E/V 8线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,142,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1723,'WS_EV_A_23','E/V 8线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,143,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1724,'WS_EV_A_24','E/V 8线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    5,144,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1725,'WS_EV_A_25','E/V 9线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,145,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1726,'WS_EV_A_26','E/V 9线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,146,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1727,'WS_EV_A_27','E/V 9线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    5,147,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1728,'WS_EV_A_28','E/V 10线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,148,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1729,'WS_EV_A_29','E/V 10线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    5,149,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1730,'WS_EV_A_30','E/V 10线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    5,150,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

