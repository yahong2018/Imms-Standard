
-- 去掉品质的发生时间，只留工作日
alter table quality_check MODIFY COLUMN time_of_origin datetime null;

-- 去掉生产计划
alter table production_order_progress modify column production_order_no  varchar(20) null;
alter table production_order_progress modify column production_order_id  bigint null;
alter table production_moving modify column production_order_no  varchar(20) null;
alter table production_moving modify column production_order_id  bigint null;

-- 支持前台界面不输入卡号
alter table production_order_progress modify column rfid_card_id  bigint not null default -1;
alter table production_order_progress modify column card_qty  int not null default 0;
alter table production_order_progress modify column rfid_card_no varchar(20) null;

alter table production_moving modify column workstation_code  varchar(20) null;
alter table production_moving modify column workstation_name  varchar(50) null;
alter table production_moving modify column workstation_id  bigint null;

-- 取消相关的权限
delete from program_privilege
 where program_id in('SYS03_05','SYS03_06','SYS03_07')
   and privilege_code in('UPDATE','DELETE');

delete from role_privilege
  where program_privilege_id not in(
      select record_id from program_privilege
  );

-- 操作人员按照部门进行数据权限管理

-- 授权码
ae103a68cd2ace75182268cc9c32ce84

---