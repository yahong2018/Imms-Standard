/*
   要准备的数据
        1. 车间
        2. 工位
        3. 操作员与工卡
        4. 产品
        5. 库存与生产进度（清零）
        6. 工程内看板
        7. 外发看板

    待测试的流程
        1. 发看板
        2. 报工
        3. 移库
        4. 退件

        5. 外发
        6. 外发回厂
        
*/
--
-- 清空原有数据
--
truncate table system_logs;
truncate table work_organization_unit;
truncate table operator;
truncate table material;
truncate table bom;
truncate table material_stock;
truncate table rfid_card;
truncate table production_order;
truncate table product_summary;
truncate table production_order_progress;
truncate table production_moving;
truncate table quality_check;
truncate table workstation_login;
truncate table workstation_session;
truncate table workstation_session_step;
truncate table outsource_workstation_bind;
truncate table outsource_card_bind;

/****************************************************************************************************
        操作员与工卡
*****************************************************************************************************/
INSERT INTO `operator` VALUES (1, 'GK001', '刘永红', 'GK001', 1, 'WK01_YZ', '压铸', 1, 'C00001', '刘永红', '2019-10-17 19:28:23', 1, 'C00001', '刘永红', '2019-10-31 06:58:35', 0);
INSERT INTO `operator` VALUES (2, 'GK002', '徐斯珍', 'GK002', 2, 'WK02_CJG', '粗加工', 1, 'C00001', '刘永红', '2019-10-17 19:28:23', 1, 'C00001', '刘永红', '2019-10-31 06:58:44', 0);

/****************************************************************************************************
        车间和工位
*****************************************************************************************************/
--
-- 压铸
--
set @OrgType = 'ORG_WORK_SHOP';   
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('YZ','压铸',@OrgType,1,
                                    0,'','',
                                    1,-1,-1,-1,'',
                                    1,'C00001','刘永红',Now());
set @WORKSHOP_KEY = LAST_INSERT_ID();

set @OrgType = 'ORG_WORK_STATION';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('YZ_01','压铸1线',@OrgType,1,
                                    @WORKSHOP_KEY,'YZ','压铸',
                                    1,-1,3,1,'YZ_01',
                                    1,'C00001','刘永红',Now());

--
-- 粗加工
--
set @OrgType = 'ORG_WORK_SHOP';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('CJG','粗加工',@OrgType,1,
                                    0,'','',
                                    2,1,-1,-1,'',
                                    1,'C00001','刘永红',Now());
set @WORKSHOP_KEY = LAST_INSERT_ID();

set @OrgType = 'ORG_WORK_STATION';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('CJG_01','粗加工1线',@OrgType,1,
                                    @WORKSHOP_KEY,'CJG','粗加工',
                                    1,-1,3,8,'CJG_01',
                                    1,'C00001','刘永红',Now());

-- ----------------------------------------------------------------------------------------------------------------------------------

--
-- 切断
--
set @OrgType = 'ORG_WORK_SHOP';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('QD','切断',@OrgType,1,
                                    0,'','',
                                    11,-1,-1,-1,'QD_01',
                                    1,'C00001','刘永红',Now());
set @WORKSHOP_KEY = LAST_INSERT_ID();

set @OrgType = 'ORG_WORK_STATION';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('QD_01','切断1线',@OrgType,1,
                                    @WORKSHOP_KEY,'QD','切断',
                                    11,-1,1,1,'QD_01',
                                    1,'C00001','刘永红',Now()); 

--
-- 锻造
--
set @OrgType = 'ORG_WORK_SHOP';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('DZ','锻造',@OrgType,1,
                                    0,'','',
                                    12,11,-1,-1,'',
                                    1,'C00001','刘永红',Now());
set @WORKSHOP_KEY = LAST_INSERT_ID();

set @OrgType = 'ORG_WORK_STATION';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('DZ_01','锻造1线',@OrgType,1,
                                    @WORKSHOP_KEY,'DZ','锻造',
                                    12,11,1,3,'DZ_01',
                                    1,'C00001','刘永红',Now());                                       

--
-- E/V前工程
--
set @OrgType = 'ORG_WORK_SHOP';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('EV0','EV前工程',@OrgType,3,
                                    0,'','',
                                    13,12,-1,-1,'',
                                    1,'C00001','刘永红',Now());
set @WORKSHOP_KEY = LAST_INSERT_ID();

set @OrgType = 'ORG_WORK_STATION';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('EV0_01','EV前工程1线',@OrgType,3,
                                    @WORKSHOP_KEY,'EV0','EV前工程',
                                    13,12,11,1,'EV0_01',
                                    1,'C00001','刘永红',Now());       

--
-- E/V外发
--
set @OrgType = 'ORG_WORK_SHOP';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('EV1','EV渗氮',@OrgType,4,
                                    0,'','',
                                    14,13,-1,-1,'',
                                    1,'C00001','刘永红',Now());

--
-- E/V后工程
--
set @OrgType = 'ORG_WORK_SHOP';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('EV2','EV后工程',@OrgType,5,
                                    0,'','',
                                    15,14,-1,-1,'',
                                    1,'C00001','刘永红',Now());
set @WORKSHOP_KEY = LAST_INSERT_ID();

set @OrgType = 'ORG_WORK_STATION';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('EV2_01','EV后工程1线',@OrgType,5,
                                    @WORKSHOP_KEY,'EV2','EV后工程',
                                    15,14,2,1,'EV2_01',
                                    1,'C00001','刘永红',Now()); 
/****************************************************************************************************
        产品
*****************************************************************************************************/
insert into material (material_code,material_name,prev_material_id,prev_material_code,prev_material_name,create_by_id,create_by_code,create_by_name,create_time)
    values('A01','A_压铸',-1,'','',1,'C00001','刘永红',Now());

set @PreMaterialId = LAST_INSERT_ID();
insert into material (material_code,material_name,prev_material_id,prev_material_code,prev_material_name,create_by_id,create_by_code,create_by_name,create_time)
    values('A02','A_粗加工',@PreMaterialId,'A01','A_压铸',1,'C00001','刘永红',Now());

insert into material (material_code,material_name,prev_material_id,prev_material_code,prev_material_name,create_by_id,create_by_code,create_by_name,create_time)
    values('B01','B_切断',-1,'','',1,'C00001','刘永红',Now());

set @PreMaterialId = LAST_INSERT_ID();
insert into material (material_code,material_name,prev_material_id,prev_material_code,prev_material_name,create_by_id,create_by_code,create_by_name,create_time)
    values('B02','B_锻造',@PreMaterialId,'B01','B_切断',1,'C00001','刘永红',Now());

set @PreMaterialId = LAST_INSERT_ID();
insert into material (material_code,material_name,prev_material_id,prev_material_code,prev_material_name,create_by_id,create_by_code,create_by_name,create_time)
    values('B03','B_EV前工程',@PreMaterialId,'B02','B_锻造',1,'C00001','刘永红',Now());    

set @PreMaterialId = LAST_INSERT_ID();
insert into material (material_code,material_name,prev_material_id,prev_material_code,prev_material_name,create_by_id,create_by_code,create_by_name,create_time)
    values('B04','B_EV外发',@PreMaterialId,'B03','B_EV前工程',1,'C00001','刘永红',Now());  

set @PreMaterialId = LAST_INSERT_ID();
insert into material (material_code,material_name,prev_material_id,prev_material_code,prev_material_name,create_by_id,create_by_code,create_by_name,create_time)
    values('B05','B_EV后工程',@PreMaterialId,'B04','B_EV外发',1,'C00001','刘永红',Now()); 


/****************************************************************************************************
        库存初始化
*****************************************************************************************************/        
insert into material_stock(material_id,material_code,material_name,
                            store_id,store_code,store_name,
                            qty_stock,qty_move_in,qty_back_in,qty_back_out,qty_consume_good,qty_consume_defect,qty_good,qty_defect,qty_move_out,
                            create_by_id,create_by_code,create_by_name,create_time)
select m.record_id as material_id,m.material_code,m.material_name,
	   w.record_id as store_id,w.org_code,w.org_name,
	   0,0,0,0,0,0,0,0,0,
	   1,'C00001','刘永红',Now()
from material m right outer join work_organization_unit w on 1 = 1
 where w.org_type = 'ORG_WORK_SHOP';

/****************************************************************************************************
        生产进度初始化
*****************************************************************************************************/  
insert into product_summary(product_date,workshop_id,workshop_code,workshop_name,
                            production_id,production_code,production_name,
                            qty_good_0,qty_defect_0,qty_good_1,qty_defect_1)
select  '2019/11/12', w.record_id as store_id,w.org_code,w.org_name,
        m.record_id as material_id,m.material_code,m.material_name,
        0,0,0,0
from material m right outer join work_organization_unit w on 1 = 1
 where w.org_type = 'ORG_WORK_SHOP';



/****************************************************************************************************
        工程内看板 &  外发看板
*****************************************************************************************************/     
insert into rfid_card(
    kanban_no,rfid_no,card_type,card_status,
    production_id,production_code,production_name,
    workshop_id,workshop_code,workshop_name,
    issue_qty,stock_qty,last_business_id,
    create_by_id,create_by_code,create_by_name,create_time
)values(
    'YZ001','YZ001',2,1,
    1,'A01','A_压铸',
    1,'YZ','压铸',
    100,0,-1,
    1,'C00001','刘永红',Now()
);

insert into rfid_card(
    kanban_no,rfid_no,card_type,card_status,
    production_id,production_code,production_name,
    workshop_id,workshop_code,workshop_name,
    issue_qty,stock_qty,last_business_id,
    create_by_id,create_by_code,create_by_name,create_time
)values(
    'CJG01','CJG01',2,1,
    2,'A02','A_粗加工',
    3,'CJG','粗加工',
    100,0,-1,
    1,'C00001','刘永红',Now()
);

insert into rfid_card(
    kanban_no,rfid_no,card_type,card_status,
    production_id,production_code,production_name,
    workshop_id,workshop_code,workshop_name,
    issue_qty,stock_qty,last_business_id,
    create_by_id,create_by_code,create_by_name,create_time
)values(
    'QD001','QD001',2,1,
    3,'B01','B_切断',
    5,'QD','切断',
    100,0,-1,
    1,'C00001','刘永红',Now()
);

insert into rfid_card(
    kanban_no,rfid_no,card_type,card_status,
    production_id,production_code,production_name,
    workshop_id,workshop_code,workshop_name,
    issue_qty,stock_qty,last_business_id,
    create_by_id,create_by_code,create_by_name,create_time
)values(
    'DZ001','DZ001',2,1,
    4,'B02','B_锻造',
    7,'DZ','锻造',
    100,0,-1,
    1,'C00001','刘永红',Now()
);

insert into rfid_card(
    kanban_no,rfid_no,card_type,card_status,
    production_id,production_code,production_name,
    workshop_id,workshop_code,workshop_name,
    issue_qty,stock_qty,last_business_id,
    create_by_id,create_by_code,create_by_name,create_time
)values(
    'EV001','EV001',2,1,
    5,'B03','B_EV前工程',
    9,'EV0','EV前工程',
    100,0,-1,
    1,'C00001','刘永红',Now()
);

insert into rfid_card(
    kanban_no,rfid_no,card_type,card_status,
    production_id,production_code,production_name,
    workshop_id,workshop_code,workshop_name,
    issue_qty,stock_qty,last_business_id,
    create_by_id,create_by_code,create_by_name,create_time
)values(
    'EV002','EV002',2,1,
    5,'B03','B_EV前工程',
    9,'EV0','EV前工程',
    100,0,-1,
    1,'C00001','刘永红',Now()
);

insert into rfid_card(
    kanban_no,rfid_no,card_type,card_status,
    production_id,production_code,production_name,
    workshop_id,workshop_code,workshop_name,
    issue_qty,stock_qty,last_business_id,
    create_by_id,create_by_code,create_by_name,create_time
)values(
    'EV101','EV101',3,1,    -- 外发看板
    6,'B04','B_EV外发',
    11,'EV1','EV渗氮',
    200,0,-1,
    1,'C00001','刘永红',Now()
);

insert into rfid_card(
    kanban_no,rfid_no,card_type,card_status,
    production_id,production_code,production_name,
    workshop_id,workshop_code,workshop_name,
    issue_qty,stock_qty,last_business_id,
    create_by_id,create_by_code,create_by_name,create_time
)values(
    'EV201','EV201',2,1,
    7,'B05','B_EV后工程',
    12,'EV2','EV后工程',
    100,0,-1,
    1,'C00001','刘永红',Now()
);

/****************************************************************************************************
        存储过程测试：初始化
*****************************************************************************************************/ 
truncate workstation_session;
truncate workstation_session_step;
truncate production_order_progress;
truncate production_moving;

update material_stock
  set qty_stock = 0,
      qty_move_in = 0,
      qty_move_out = 0,
      qty_back_in = 0,
      qty_back_out = 0,
      qty_consume_good = 0,
      qty_consume_defect = 0,
      qty_good  = 0,
      qty_defect = 0;

update product_summary
   set qty_defect_0 = 0,
       qty_defect_1 = 0,
       qty_good_0 = 0,
       qty_good_1 = 0;

update rfid_card
   set card_status = 1,
       stock_qty = 0;

/****************************************************************************************************
        压铸报工
*****************************************************************************************************/ 
truncate system_logs;
set         
		@GID=3, -- 压铸
		@DID=1,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='YZ001', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

/****************************************************************************************************
        移库： 压铸 --> 粗加工
*****************************************************************************************************/ 
truncate system_logs;
set         
		@GID=3, 
		@DID=8,  -- 粗加工	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='YZ001', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

/****************************************************************************************************
        退回： 粗加工 --> 压铸
*****************************************************************************************************/ 
--
-- 1. 刷工卡，显示菜单： "1.工件退回   2.给前工程发看板" 
--
truncate system_logs;
set         
		@GID=3, 
		@DID=1,  -- 压铸	
		@DataType=1, --  刷工卡			
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='GK002', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;
 

--
-- 2. 员工输入"1"，然后按确定，系统提示： "请刷看板" 
--
truncate system_logs;
set         
		@GID=3, 
		@DID=1,  -- 压铸	
		@DataType=3, --  键盘	
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='1', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

--
-- 3. 员工刷工程内看板，系统提示： "请输入退还数量" 
--
truncate system_logs;
set         
		@GID=3, 
		@DID=1,  -- 压铸	
		@DataType=1, --  刷卡
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='YZ001', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;


--
-- 3. 员工刷工程内看板，系统提示： "请接收人刷工卡确认" 
--
truncate system_logs;
set         
		@GID=3, 
		@DID=1,  -- 压铸	
		@DataType=3, --  键盘
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='50', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

--
-- 4. 员工刷工卡，系统提示： "已退还50个" 
--
truncate system_logs;
set         
		@GID=3, 
		@DID=1,  -- 压铸	
		@DataType=1, --  刷卡
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='GK001', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

/****************************************************************************************************
        报工： 粗加工，存在有对A01的消耗
*****************************************************************************************************/ 
truncate system_logs;
set         
		@GID=3, -- 粗加工
		@DID=8,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='CJG01', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;


/****************************************************************************************************
        给前工程发卡
*****************************************************************************************************/ 
--
-- -1. 刷工卡，显示菜单： "1.工件退回   2.给前工程发看板" 
--
truncate system_logs;
set         
		@GID=3, 
		@DID=8,  -- 压铸	
		@DataType=1, --  刷工卡			
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='GK002', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;
 
--
-- 0. 员工输入"2"，然后按确定，系统提示： "请刷看板" 
--
truncate system_logs;
set         
		@GID=3, 
		@DID=8,  -- 压铸	
		@DataType=3, --  键盘	
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='2', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

 
--
-- 1. 员工刷看板，系统提示： "请输入派发数量" 
--
truncate system_logs;
set         
		@GID=3, 
		@DID=8,  -- 压铸	
		@DataType=1, --  刷卡	
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='YZ001', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;
 
--
-- 2. 员工输入数量（如果需要），按【确定】键，系统提示： "已派发xx个，继续请刷其他看板" 
--
truncate system_logs;
set         
		@GID=3, 
		@DID=8,  -- 压铸	
		@DataType=3, --  键盘	
		@DataGatherTime='2019/11/12 08:30:59',
		@DataMakeTime='2019/11/12 08:31:02',
		@StrPara1='98', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;