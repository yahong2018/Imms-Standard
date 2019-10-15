-- 初始化人员数据
insert into operator(record_id,employee_id,employee_name,employee_card_no,org_id,org_code,org_name,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    1,'C00001','刘永红','GK0001',1,'YZ','压铸',
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);

insert into operator(record_id,employee_id,employee_name,employee_card_no,org_id,org_code,org_name,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    2,'C00002','徐斯珍','GK0002',2,'CJG','粗加工',
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);


-- 初始化RFID卡的数据
insert into rfid_card(record_id,rfid_no,card_type,card_status,production_id,production_code,production_name,
   workshop_id,workshop_code,workshop_name,qty,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    1,'K0001',0,0,1,'A-0001','产品1',
    1,'YZ','压铸',100,
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);

insert into rfid_card(record_id,rfid_no,card_type,card_status,production_id,production_code,production_name,
   workshop_id,workshop_code,workshop_name,qty,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    2,'K0002',0,0,1,'A-0001','产品1',
    2,'CJG','粗加工',100,
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);

insert into rfid_card(record_id,rfid_no,card_type,card_status,production_id,production_code,production_name,
   workshop_id,workshop_code,workshop_name,qty,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    3,'K0003',0,0,1,'A-0001','产品1',
    3,'MC','MC加工',100,
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);


insert into rfid_card(record_id,rfid_no,card_type,card_status,production_id,production_code,production_name,
   workshop_id,workshop_code,workshop_name,qty,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    4,'K0004',0,0,1,'A-0001','产品1',
    4,'SJG','细加工',100,
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);


insert into rfid_card(record_id,rfid_no,card_type,card_status,production_id,production_code,production_name,
   workshop_id,workshop_code,workshop_name,qty,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    5,'K0004',0,0,1,'A-0001','产品1',
    5,'RK01','入库1',100,
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);

--  初始化车间数据
insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    next_workshop_id,next_workshop_code,next_workshop_name,rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(1,'YZ','压铸','ORG_WORK_SHOP','',null,null,null,
    2,'CJG','粗加工',0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    next_workshop_id,next_workshop_code,next_workshop_name,rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(2,'CJG','粗加工','ORG_WORK_SHOP','',null,null,null,
    3,'MC','MC加工',0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    next_workshop_id,next_workshop_code,next_workshop_name,rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(3,'MC','MC加工','ORG_WORK_SHOP','',null,null,null,
    4,'SJG','细加工',0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    next_workshop_id,next_workshop_code,next_workshop_name,rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(4,'SJG','细加工','ORG_WORK_SHOP','',null,null,null,
    5,'RK01','工务入库',0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    next_workshop_id,next_workshop_code,next_workshop_name,rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(5,'RK01','入库_1','ORG_WORK_SHOP','',null,null,null,
    null,null,null,0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- 初始化工位 
insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    next_workshop_id,next_workshop_code,next_workshop_name,rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(155,'YZ01','压铸1号工位','ORG_WORK_STATION','',1,'YZ','压铸',
    null,null,null,1,1,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    next_workshop_id,next_workshop_code,next_workshop_name,rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(156,'MC01','MC1号工位','ORG_WORK_STATION','',2,'MC','MC加工',
    null,null,null,2,1,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    next_workshop_id,next_workshop_code,next_workshop_name,rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(166,'CJG01','粗加工1号工位','ORG_WORK_STATION','',2,'CJG','粗加工',
    null,null,null,3,1,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    next_workshop_id,next_workshop_code,next_workshop_name,rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(176,'SJG01','细加工1号工位','ORG_WORK_STATION','',4,'XJG','细加工',
    null,null,null,4,1,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into work_organization_unit(
    record_id,org_code,org_name,org_type,description,parent_id,parent_code,parent_name,
    next_workshop_id,next_workshop_code,next_workshop_name,rfid_controller_id,rfid_terminator_id,
    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(200,'RK0101','入库1号工位','ORG_WORK_STATION','',5,'RK01','入库01',
    null,null,null,5,1,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);


-- 初始化产品

insert into material(record_id,material_code,material_name,description,first_workshop_id,first_workshop_code,first_workshop_name,
create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    1,'A-0001','产品1','',1,'YZ','压铸',
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into material(record_id,material_code,material_name,description,first_workshop_id,first_workshop_code,first_workshop_name,
create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    2,'A-0002','产品2','',1,'YZ','压铸',
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into material(record_id,material_code,material_name,description,first_workshop_id,first_workshop_code,first_workshop_name,
create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    3,'A-0003','产品3','',1,'YZ','压铸',
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- 初始化计划
insert into production_order(record_id,order_no,order_status,production_id,production_code,production_name,
   plan_date,qty_planned,qty_actual,qty_store,qty_good,qty_bad,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    1,'PO.000001',0,1,'A-0001','产品1',
    '2019/10/14',550,0,0,0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into production_order(record_id,order_no,order_status,production_id,production_code,production_name,
   plan_date,qty_planned,qty_actual,qty_store,qty_good,qty_bad,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    2,'PO.000002',0,2,'A-0002','产品1',
    '2019/10/14',550,0,0,0,0,
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- 系统参数
insert into system_parameter(parameter_class_id,parameter_code,parameter_name,parameter_value)
                 values(0,'LOG_LEVEL','日志级别','DEBUG');
								 


/*
truncate system_logs;
set @IsNewData=1,        
		@GID=1, -- 压铸
		@DID=1,
		@IsOffLineData=0, 		
		@DataType=1, --  刷卡数据 				
		@DataGatherTime='2019/10/14 08:30:59',
		@DataMakeTime='2019/10/14 08:31:02',
		@StrPara1='GK0001', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@IsNewData,@GID,@DID,@IsOffLineData,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;

-- 模拟键盘输入
truncate system_logs;
set @IsNewData=1,        
		@GID=1, -- 压铸
		@DID=1,
		@IsOffLineData=0, 		
		@DataType=3, --  键盘输入 				
		@DataGatherTime='2019/10/14 08:30:59',
		@DataMakeTime='2019/10/14 08:31:02',
		@StrPara1='3', 
		@Resp=''
		;		
call MES_ProcessDeviceData(@IsNewData,@GID,@DID,@IsOffLineData,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;
*/