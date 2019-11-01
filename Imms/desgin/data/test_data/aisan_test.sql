/*
truncate table operator;
truncate table rfid_card;
truncate table work_organization_unit;
truncate table material;
truncate table production_order;
truncate table system_parameter;
*/

-- 初始化人员数据
insert into operator(record_id,employee_id,employee_name,employee_card_no,org_id,org_code,org_name,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    1,'C00001','刘永红','GK0001',1,'WK01_YZ','压铸',  
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);

insert into operator(record_id,employee_id,employee_name,employee_card_no,org_id,org_code,org_name,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    2,'C00002','徐斯珍','GK0002',2,'WK02_CJG','粗加工',
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);

-- 初始化RFID卡的数据
insert into rfid_card(record_id,rfid_no,card_type,card_status,production_id,production_code,production_name,
   workshop_id,workshop_code,workshop_name,qty,kanban_no,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    1,'K0001',0,0,1,'A-0001','产品1',
    1,'WK01_YZ','压铸',100,'K0001',
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);

insert into rfid_card(record_id,rfid_no,card_type,card_status,production_id,production_code,production_name,
   workshop_id,workshop_code,workshop_name,qty,kanban_no,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    2,'K0002',0,0,1,'A-0001','产品1',
    2,'WK02_CJG','粗加工',100,'K0002',
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);

insert into rfid_card(record_id,rfid_no,card_type,card_status,production_id,production_code,production_name,
   workshop_id,workshop_code,workshop_name,qty,kanban_no,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    3,'K0003',0,0,1,'A-0001','产品1',
    3,'WK03_MC','MC加工',100,'K0003',
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);


insert into rfid_card(record_id,rfid_no,card_type,card_status,production_id,production_code,production_name,
   workshop_id,workshop_code,workshop_name,qty,kanban_no,
   create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    4,'K0004',0,0,1,'A-0001','产品1',
    4,'WK04_THR','THR',100,'K0004',
    1,'C00001','刘永红',Now(),null,null,null,null,0   
);


-- insert into rfid_card(record_id,rfid_no,card_type,card_status,production_id,production_code,production_name,
--    workshop_id,workshop_code,workshop_name,qty,
--    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
-- )values(
--     5,'K0004',0,0,1,'A-0001','产品1',
--     5,'RK01','入库1',100,
--     1,'C00001','刘永红',Now(),null,null,null,null,0   
-- );


-- 初始化产品

insert into material(record_id,material_code,material_name,description,
create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    1,'A-0001','产品1','',
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into material(record_id,material_code,material_name,description,
create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    2,'A-0002','产品2','',
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

insert into material(record_id,material_code,material_name,description,
create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
)values(
    3,'A-0003','产品3','',
    1,'C00001','刘永红',Now(),null,null,null,null,0
);

-- 初始化计划
-- insert into production_order(record_id,order_no,order_status,production_id,production_code,production_name,
--    plan_date,qty_planned,qty_actual,qty_store,qty_good,qty_bad,
--    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
-- )values(
--     1,'PO.000001',0,1,'A-0001','产品1',
--     '2019/10/14',550,0,0,0,0,
--     1,'C00001','刘永红',Now(),null,null,null,null,0
-- );

-- insert into production_order(record_id,order_no,order_status,production_id,production_code,production_name,
--    plan_date,qty_planned,qty_actual,qty_store,qty_good,qty_bad,
--    create_by_id,create_by_code,create_by_name,create_time,update_by_id,update_by_code,update_by_name,update_time,opt_flag
-- )values(
--     2,'PO.000002',0,2,'A-0002','产品2',
--     '2019/10/14',550,0,0,0,0,
--     1,'C00001','刘永红',Now(),null,null,null,null,0
-- );

								 


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


-- 报工
truncate system_logs;
set @IsNewData=1,        
		@GID=1, -- 压铸
		@DID=1,
		@IsOffLineData=0, 		
		@DataType=1, --  刷卡输入 				
		@DataGatherTime='2019/10/14 08:30:59',
		@DataMakeTime='2019/10/14 08:31:02',
		@StrPara1='K0001',  -- 数量卡
		@Resp=''
		;		
call MES_ProcessDeviceData(@IsNewData,@GID,@DID,@IsOffLineData,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;


-- 移库
truncate system_logs;
set @IsNewData=1,        
		@GID=2, -- MC加工
		@DID=1,
		@IsOffLineData=0, 		
		@DataType=1, --  刷卡输入 				
		@DataGatherTime='2019/10/14 08:30:59',
		@DataMakeTime='2019/10/14 08:31:02',
		@StrPara1='K0001',  -- 数量卡
		@Resp=''
		;		
call MES_ProcessDeviceData(@IsNewData,@GID,@DID,@IsOffLineData,@DataType,@DataGatherTime,@DataMakeTime,@StrPara1,@Resp);
select @Resp;
select log_value from system_logs;

*/

/*
数据导入

load data infile 'D:/Data/mydata/mysql/import/defect.csv' 
into table defect 
CHARACTER SET utf8
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

[mysqld]
port=3306
character_set_server=utf8
basedir=D:\Data\mydata\mysql
datadir=D:\Data\mydata\mysql\database
max_connections=1000
secure-file-priv=D:\Data\mydata\mysql\import
*/
