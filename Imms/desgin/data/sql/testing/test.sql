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

truncate table work_organization_unit;
truncate table operator;
truncate table material;
truncate table bom;
truncate table rfid_card;

truncate table system_logs;
truncate table material_stock;
truncate table product_summary;
truncate table production_order_progress;
truncate table production_moving;
truncate table workstation_session;
truncate table workstation_session_step;
truncate table quality_check;
truncate table outsource_workstation_bind;
truncate table outsource_card_bind;
truncate table card_issue;

truncate table defect;
truncate table production_order;

truncate table workstation_login;



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
                                    2,1,3,2,'CJG_01',
                                    1,'C00001','刘永红',Now());


--
-- MC加工
--
set @OrgType = 'ORG_WORK_SHOP';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('MC','MC加工',@OrgType,1,
                                    0,'','',
                                    3,2,-1,-1,'',
                                    1,'C00001','刘永红',Now());
set @WORKSHOP_KEY = LAST_INSERT_ID();

set @OrgType = 'ORG_WORK_STATION';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('MC_01','MC工1线',@OrgType,1,
                                    @WORKSHOP_KEY,'MC','MC加工',
                                    3,2,3,3,'MC_01',
                                    1,'C00001','刘永红',Now());


--
-- MC加工
--
set @OrgType = 'ORG_WORK_SHOP';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('THR','THR组合',@OrgType,1,
                                    0,'','',
                                    4,3,-1,-1,'',
                                    1,'C00001','刘永红',Now());
set @WORKSHOP_KEY = LAST_INSERT_ID();

set @OrgType = 'ORG_WORK_STATION';
insert into work_organization_unit(org_code,org_name,org_type,workshop_type,
                                   parent_id,parent_code,parent_name,
                                   operation_index,prev_operation_index,rfid_controller_id,rfid_terminator_id,wocg_code,
                                   create_by_id,create_by_code,create_by_name,create_time)
                             values('THR_01','THR1线',@OrgType,1,
                                    @WORKSHOP_KEY,'THR','THR',
                                    4,3,3,4,'THR_01',
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
insert into material (material_code,material_name,auto_finished_progress,create_by_id,create_by_code,create_by_name,create_time)
           select 'A01','A_压铸',0,1,'C00001','刘永红',Now()
 union all select 'A02','A_粗加工',0,1,'C00001','刘永红',Now()
 union all select 'A03','A_MC加工',0,1,'C00001','刘永红',Now()
 union all select 'A04','A_THR组装',0,1,'C00001','刘永红',Now()
 union all select 'A04_01','A04_01',1,1,'C00001','刘永红',Now()
 union all select 'A04_0101','A04_0101',1,1,'C00001','刘永红',Now()
 union all select 'A04_02','A04_02',1,1,'C00001','刘永红',Now()
 union all select 'A04_0201','A04_0201',1,1,'C00001','刘永红',Now()

 --
 -- BOM
 --
insert bom (bom_no,bom_type,bom_status,
             material_id,material_code,material_name,
             component_id,component_code,component_name,
             material_qty,component_qty,effect_date,
             create_by_id,create_by_code,create_by_name,create_time,
             opt_flag)
         select '',-1,1,
                7,'A04_02','A04_02',
                8,'A04_0201','A04_0201',
                1,1,'2019/11/01',
                1,'C00001','刘永红',Now(),
                1
union all select '',-1,1,
                5,'A04_01','A04_01',
                6,'A04_0101','A04_0101',
                1,1,'2019/11/01',
                1,'C00001','刘永红',Now(),
                1        
union all select '',-1,1,
                4,'A04','A_THR组装',
                5,'A04_01','A04_01',
                1,1,'2019/11/01',
                1,'C00001','刘永红',Now(),
                1        
union all select '',-1,1,
                4,'A04','A_THR组装',
                7,'A04_02','A04_02',
                1,1,'2019/11/01',
                1,'C00001','刘永红',Now(),
                1        
 union all select '',-1,1,
                6,'A04_01','A04_01',
                3,'A03','A_MC加工',
                1,1,'2019/11/01',
                1,'C00001','刘永红',Now(),
                1        
 union all select '',-1,1,
                3,'A03','A_MC加工',
                2,'A02','A_粗加工',
                1,1,'2019/11/01',
                1,'C00001','刘永红',Now(),
                1        
union all select '',-1,1,
                2,'A02','A_粗加工',
                1,'A01','A_压铸',
                1,1,'2019/11/01',
                1,'C00001','刘永红',Now(),
                1    

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
    2,'CJG','粗加工',
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
    'MC01','MC01',2,1,
    3,'A03','A_MC加工',
    3,'MC','MC加工',
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
    'THR01','THR01',2,1,
    4,'A04','A_THR加工',
    4,'THR','THR加工',
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
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
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='98', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

/****************************************************************************************************
        E/V 前工程 绑定外发卡 
*****************************************************************************************************/ 
truncate system_logs;
-- truncate workstation_session;
-- truncate workstation_session_step;

set         
		@GID=11, -- E/V前工程
		@DID=1,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime='2019/11/13 08:30:59',
		@DataMakeTime='2019/11/13 08:31:02',
		@StrPara1='EV101',  -- 外发看板
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;


/****************************************************************************************************
        E/V 前工程 报工
*****************************************************************************************************/ 
truncate system_logs;
set         
		@GID=11, -- E/V前工程
		@DID=1,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime='2019/11/13 08:30:59',
		@DataMakeTime='2019/11/13 08:31:02',
		@StrPara1='EV001', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

truncate system_logs;
set         
		@GID=11, -- E/V前工程
		@DID=1,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime='2019/11/13 08:30:59',
		@DataMakeTime='2019/11/13 08:31:02',
		@StrPara1='EV002', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

/****************************************************************************************************
        E/V 外发
*****************************************************************************************************/ 
truncate system_logs;
set         
		@GID=11, -- E/V前工程
		@DID=1,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime='2019/11/13 08:30:59',
		@DataMakeTime='2019/11/13 08:31:02',
		@StrPara1='EV101', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

/****************************************************************************************************
        E/V 回厂
*****************************************************************************************************/ 

truncate system_logs;
set         
		@GID=2, -- E/V后工程
		@DID=1,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime='2019/11/13 08:30:59',
		@DataMakeTime='2019/11/13 08:31:02',
		@StrPara1='EV101', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

/****************************************************************************************************
        E/V 后工程报工
*****************************************************************************************************/ 

truncate system_logs;
set         
		@GID=2, -- E/V后工程
		@DID=1,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime='2019/11/13 08:30:59',
		@DataMakeTime='2019/11/13 08:31:02',
		@StrPara1='EV201', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;


---------------------------------------------------------------------------------------------------------------
-- 绑卡
truncate system_logs;
truncate workstation_session;
truncate workstation_session_step;

set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011004747', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;


-- 报工

truncate system_logs;
truncate workstation_session;
truncate workstation_session_step;

set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0010970609', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

truncate system_logs;
truncate workstation_session;
truncate workstation_session_step;

set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0010963202', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;


set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0010970349', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;


set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011021970', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;


set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0010978038', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;



set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011015658', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;


set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0010998159', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;

set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011012385', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;



set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011007202', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;



set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011006752', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;



set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011008329', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;




set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0010982920', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;


set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0010963687', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;



set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011008209', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;



set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0010976153', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;


set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0010987348', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;


set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011008963', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;


set         
		@GID=45, -- EV前加工
		@DID=3,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0010979793', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;

-- --------------------------------------------------------------------------------------------
-- EV外发
truncate system_logs;
truncate workstation_session;
truncate workstation_session_step;

set         
		@GID=11, -- 中三三民
		@DID=26,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011004747', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;


-- EV回厂
truncate system_logs;
truncate workstation_session;
truncate workstation_session_step;

set         
		@GID=11, -- 中三三民
		@DID=27,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011004747', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;

-- -----------------------------------------------------------------------------------------
-- EV后加工
truncate system_logs;
truncate workstation_session;
truncate workstation_session_step;

set         
		@GID=45, -- 后加工
		@DID=5,	
		@DataType=1, --  刷卡数据 				
		@DataGatherTime=Now(),
		@DataMakeTime=Now(),
		@StrPara1='0011004747', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@GID,@DID,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
select * from workstation_session;
select * from workstation_session_step;
