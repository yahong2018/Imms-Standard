
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
    4,1,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1702,'WS_EV_A_02','E/V 1线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,2,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1703,'WS_EV_B_03','E/V 1线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    4,3,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1704,'WS_EV_A_04','E/V 2线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,4,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1705,'WS_EV_A_05','E/V 2线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,5,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1706,'WS_EV_B_06','E/V 2线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    4,6,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1707,'WS_EV_A_07','E/V 3线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,7,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1708,'WS_EV_A_08','E/V 3线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,7,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1709,'WS_EV_B_09','E/V 3线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    4,9,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1710,'WS_EV_A_10','E/V 4线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,10,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1711,'WS_EV_A_11','E/V 4线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,11,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1712,'WS_EV_A_12','E/V 4线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    4,12,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1713,'WS_EV_A_13','E/V 5线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,13,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1714,'WS_EV_A_14','E/V 5线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,14,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1715,'WS_EV_A_15','E/V 5线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    4,15,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1716,'WS_EV_A_16','E/V 6线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,16,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1717,'WS_EV_A_17','E/V 6线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,17,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1718,'WS_EV_A_18','E/V 6线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    4,18,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1719,'WS_EV_A_19','E/V 7线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,19,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1720,'WS_EV_A_20','E/V 7线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,20,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1721,'WS_EV_A_21','E/V 7线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    4,21,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1722,'WS_EV_A_22','E/V 8线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,22,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1723,'WS_EV_A_23','E/V 8线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,23,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1724,'WS_EV_A_24','E/V 8线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    4,24,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1725,'WS_EV_A_25','E/V 9线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,25,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1726,'WS_EV_A_26','E/V 9线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,26,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1727,'WS_EV_A_27','E/V 9线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    4,27,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


-- ------------------------------------------------------------------------------------------------

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1728,'WS_EV_A_28','E/V 10线(前工程投入工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,28,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1729,'WS_EV_A_29','E/V 10线(前工程报工工位)','ORG_WORK_STATION','',23,'WK23_EV_A','E/V前工程',
    4,29,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1730,'WS_EV_A_30','E/V 10线(后工程工位)','ORG_WORK_STATION','',25,'WK25_EV_B','E/V后工程',
    4,30,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

