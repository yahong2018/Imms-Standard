create table system_parameter_class
(
  record_id            bigint    auto_increment   not null,
  class_name           varchar(50)                not null,

  PRIMARY KEY(record_id),
  index idx_sytsem_parameter_class_0(class_name)
);

--
-- 系统参数，包括与ERP的接口
--
create table system_parameter
(
    record_id          bigint  auto_increment   not null,
    parameter_class_id bigint                   not null, -- 参数分类
    parameter_code     varchar(50)              not null,
    parameter_name     varchar(120)             not null,
    parameter_value    varchar(255)             not null,

    PRIMARY KEY (record_id),
    index IDX_SYSTEM_PARAMETER_0(parameter_code),
    index IDX_SYSTEM_PARAMETER_1(parameter_name),
    index IDX_SYSTEM_PARAMETER_2(parameter_class_id)
);


--
-- 系统日志 
--
CREATE TABLE system_logs
(
  record_id                bigint  AUTO_INCREMENT      not null,
  user_id                  bigint                      not null,
  log_time                 datetime                    not null,
  log_type                 int                         not null,
  log_value                varchar(500)                not null,

  PRIMARY KEY(record_id),
  index IDX_SYSTEM_LOGS_0(user_id),
  index IDX_SYSTEM_LOGS_1(log_time),
  index IDX_SYSTEM_LOGS_2(log_type)                   
);

--
-- 控制器:使用科启奥的控制器表
--
create view v_rfid_controller
as
select ConterID as record_id,
       GID as group_id,   -- 组号
       ConterName as controller_name,
       Position as position,
       IP as ip,     
       Port as port,
       IsUse as is_use
from stationinfo
;      

--
-- 工位机:直接从工位里面取数据，因为每个工位对应一个工位机
-- 

--
-- 组织
--
alter table work_organization_unit
   add rfid_controller_id  int not null default 0,  -- 工位：控制器的序号
   add rfid_terminator_id  int not null default 0,  -- 工位：工位机的序号
   add operation_id        bigint not null default 0,  -- 车间：工艺
;

--
-- 员工：就是操作员 operator
--
alter table operator
   add employee_id         varchar(12)   not null,   -- 工号
   add employee_name       varchar(50)   not null,   -- 姓名 
   add employee_card_no    varchar(20)   null        -- 工卡号
;

--
-- 工艺流程： 就是工艺路线。
--

--
-- 产品 ： 就是物料
--

--
-- 发卡管理
--    本表不可以修改，只可以新增，如果已经被使用，则不可以删除。
--
create table rfid_card
(
  record_id      bigint  auto_increment  not null default 0,
  rfid_no        varchar(20)             not null,
  card_type      int                     not null,        --  卡类别: 0. 工艺数量   1. 员工卡
  card_status    int                     not null,        
  production_id  bigint                  not null,        -- （工艺数量卡）所代表的产品
  operation_id   bigint                  null,            -- （工艺数量卡）所代表的工艺
  qty            int                     null,            -- （工艺数量卡）数量
  operator_id    bigint                  null,            -- （员工卡）   操作员

  create_by      bigint                  not null,
  create_date    datetime                not null,
  update_by      bigint                  not null,
  update_date    datetime                not null,
  opt_flag       int                     not null,

  PRIMARY KEY(record_id),
  index IDX_RFID_CARD_0(rfid_no),
  index IDX_RFID_CARD_1(card_type),
  index IDX_RFID_CARD_2(card_status)       
);

--
-- 生产计划: 就用work_order表
--

--
-- 生产实绩: production_order_progress
--
create table production_order_progress
(
    record_id      bigint   auto_increment   not null default 0,
    production_order_id  bigint              not null,
    operation_id   bigint                    not null,
    rfid_terminator_id bigint                not null, -- 机器号
    rfid_controller_id bigint                not null, -- 组号
    production_id  bigint                    not null, -- 产品编号
    report_time    datetime                  not null, -- 报告时间
    report_qty     int                       not null, -- 数量
    rfid_card_no   varchar(20)               not null default '', -- RFID卡号，如果是尾数，则为空
    report_type    int                       not null, -- 数量类型：0. 整数刷卡申报  1.尾数
    work_station_id bigint                   not null, -- 工位Id
    work_shop_id  bigint                     not null, -- 车间Id


    create_by      bigint                  not null,
    create_date    datetime                not null,
    update_by      bigint                  not null,
    update_date    datetime                not null,
    opt_flag       int                     not null,    
    
    PRIMARY KEY(record_id),
    index idx_production_order_progress_0(work_order_id),
    index idx_production_order_progress_1(operation_id),
    index idx_production_order_progress_2(rfid_terminator_id),
    index idx_production_order_progress_3(rfid_controller_id),
    index idx_production_order_progress_4(production_id),
    index idx_production_order_progress_5(rfid_card_no),
    index idx_production_order_progress_6(work_station_id),
    index idx_production_order_progress_7(work_center_id)
);

--
-- 生产品质: quality_check
--

create table quality_check
(
  record_id      bigint     auto_increment   not null default 0,
  production_order_id  bigint                not null,  -- 工单编号
  production_id  bigint                      not null,  -- 产品id  
  discover_id    bigint                      not null,  -- 发现人
  discover_time  datetime                    not null,  -- 发现时间
  producer_id    bigint                      not null,  -- 产生人
  produce_time   datetime                    not null,  -- 产生时间  
  response_id    bigint                      not null,  -- 责任人
  defect_type_id varchar(20)                 not null,  -- 缺陷代码
  defect_description varchar(500)            not null,  -- 缺陷描述

  create_by      bigint                      not null,
  create_date    datetime                    not null,
  update_by      bigint                      not null,
  update_date    datetime                    not null,
  opt_flag       int                         not null,  

  PRIMARY KEY(record_id),
  index idx_quality_check_0(work_order_id),
  index idx_quality_check_1(production_id),
  index idx_quality_check_2(discover_id),
  index idx_quality_check_3(discover_time),
  index idx_quality_check_4(producer_id),
  index idx_quality_check_5(produce_time),
  index idx_quality_check_6(response_id),
  index idx_quality_check_7(defect_type_id)  
);

