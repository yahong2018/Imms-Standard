
drop table system_parameter;
drop table system_logs;
drop view v_rfid_controller;
drop table work_organization_unit;
drop table operator;
drop table material;
drop table rfid_card;
drop table production_order;
drop table production_order_progress;
drop table production_moving;
drop table quality_check;
drop table workstation_login;

--
-- 系统参数，包括与ERP的接口
--
create table system_parameter
(
    record_id          bigint  auto_increment   not null,
    parameter_class_id bigint                   not null, -- 参数分类
    parameter_class_name varchar(50)            not null,
    parameter_code     varchar(50)              not null,
    parameter_name     varchar(120)             not null,
    parameter_value    varchar(255)             not null,

    PRIMARY KEY (record_id)
);


--
-- 系统日志 
--
CREATE TABLE system_logs
(
  record_id                bigint  AUTO_INCREMENT      not null,
  user_id                  bigint                      not null,
  log_time                 datetime                    not null,
  log_type                 varchar(20)                 not null,
  log_level                int                         not null,
  log_value                varchar(500)                not null,

  PRIMARY KEY(record_id)                
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
from conterinfo
;      

--
-- 工位机:直接从工位里面取数据，因为每个工位对应一个工位机
-- 

--
-- 组织
--
create table work_organization_unit
(
    record_id              bigint    auto_increment    not null,
    org_code               varchar(50)                 not null,
    org_name               varchar(50)                 not null,
    org_type               varchar(50)                 not null,    
    description            varchar(250)                null,

    parent_id              bigint                      null,
    parent_code            varchar(50)                 null,
    parent_name            varchar(50)                 null,

    operation_index        int                         not null default 0,   -- 对于车间来说，工序编号必须唯一
    prev_operation_index   int                         not null default 0,    
    workshop_type          int                         not null default 0,   -- 车间类型: 0. 内部车间   3.外发前工程车间   4.外发车间   5.外发后工程车间
    
    rfid_controller_id     int                         not null default 0,
    rfid_terminator_id     int                         not null default 0,
    wocg_code              varchar(20)                 null,

    create_by_id           bigint                      not null,
    create_by_code         varchar(20)                 not null,
    create_by_name         varchar(50)                 not null,
    create_time            datetime                    not null,

    update_by_id           bigint                      null,
    update_by_code         varchar(20)                 null,
    update_by_name         varchar(50)                 null,
    update_time            datetime                    null,

    opt_flag               int                         not null default 0,

    primary key(record_id)
);

--
-- 员工：就是操作员 operator
--
create table operator
(
    record_id              bigint    auto_increment    not null,
    employee_id            varchar(20)                 not null,
    employee_name          varchar(50)                 not null,
    employee_card_no       varchar(20)                 not null,
    
    org_id                 bigint                      null,
    org_code               varchar(50)                 null,
    org_name               varchar(50)                 null,

    create_by_id           bigint                      not null,
    create_by_code         varchar(20)                 not null,
    create_by_name         varchar(50)                 not null,
    create_time            datetime                    not null,

    update_by_id           bigint                      null,
    update_by_code         varchar(20)                 null,
    update_by_name         varchar(50)                 null,
    update_time            datetime                    null,

    opt_flag               int                         not null default 0,

    primary key(record_id)
);

--
-- 产品
--
create table material
(
    record_id              bigint     auto_increment   not null,
    material_code          varchar(20)                 not null,
    material_name          varchar(50)                 not null,
    description            varchar(250)                null,

    prev_material_id       bigint                      not null default -1,
    prev_material_code     varchar(20)                 not null default '',
    prev_material_name     varchar(50)                 not null default '',

    create_by_id           bigint                      not null,
    create_by_code         varchar(20)                 not null,
    create_by_name         varchar(50)                 not null,
    create_time            datetime                    not null,

    update_by_id           bigint                      null,
    update_by_code         varchar(20)                 null,
    update_by_name         varchar(50)                 null,
    update_time            datetime                    null,

    opt_flag               int                         not null default 0,

    primary key(record_id)
);

--
-- 物料结构
--
create table bom
(
    record_id             bigint    auto_increment     not null,
    bom_no                varchar(20)                  not null,
    bom_type              int                          not null,
    bom_status            int                          not null,

    material_id           bigint                       not null,
    material_code         varchar(20)                  not null,
    material_name         varchar(50)                  not null,

    component_id          bigint                       not null,
    component_code        varchar(20)                  not null,
    component_name        varchar(50)                  not null,

    material_qty          int                          not null,
    component_qty         int                          not null,

    create_by_id          bigint                       not null,
    create_by_code        varchar(20)                  not null,
    create_by_name        varchar(50)                  not null,
    create_time           datetime                     not null,
 
    update_by_id          bigint                       null,
    update_by_code        varchar(20)                  null,
    update_by_name        varchar(50)                  null,
    update_time           datetime                     null,
 
    opt_flag              int                          not null default 0,    

    primary key(record_id)
);

--
-- 物料库存
--
create table material_stock
(
    record_id               bigint    auto_increment    not null,
    material_code           varchar(20)                 not null,
    material_name           varchar(50)                 not null,

    store_id                bigint                      not null,
    store_code              varchar(20)                 not null,
    store_name              varchar(50)                 not null,

    qty_stock               int                         not null,  -- 在库
    qty_move_in             int                         not null,  -- 转入（半成品） *
    qty_return_in           int                         not null,  -- 退回（从下部门退回到本部门）
    qty_return_out          int                         not null,  -- 退出（从本部门退回到上部门）
    qty_consume_good        int                         not null,  -- 良品消耗
    qty_consume_defect      int                         not null,  -- 不良消耗
    qty_good                int                         not null,  -- 良品数
    qty_defect              int                         not null,  -- 不良品数
    qty_move_out            int                         not null,  -- 转出（完成品） *

    create_by_id            bigint                      not null,
    create_by_code          varchar(20)                 not null,
    create_by_name          varchar(50)                 not null,
    create_time             datetime                    not null,
  
    update_by_id            bigint                      null,
    update_by_code          varchar(20)                 null,
    update_by_name          varchar(50)                 null,
    update_time             datetime                    null,
  
    opt_flag                int                         not null default 0,  

    primary key(record_id)
);

--
-- 发卡管理
--    本表不可以修改，只可以新增，如果已经被使用，则不可以删除。
--
create table rfid_card
(
    record_id              bigint  auto_increment      not null,

    kanban_no              varchar(20)                 not null,        
    rfid_no                varchar(20)                 not null,
    card_type              int                         not null,       --  卡类别: 1.员工卡     2.数量卡    3.委外加工卡
    card_status            int                         not null,       --  0. 未使用   1. 已派发(已绑定)   2.已退回     10. 已报工   20. 已移库收货(已外发)   30.已回厂     255.已作废

    production_id          bigint                      not null,       -- （工艺数量卡）所代表的产品
    production_code        varchar(20)                 not null,
    production_name        varchar(50)                 not null,

    workshop_id            bigint                      not null,       -- （工艺数量卡）所代表的工艺
    workshop_code          varchar(20)                 not null,  
    workshop_name          varchar(50)                 not null,

    issue_qty              int                         not null,       -- 派发数量
    stock_qty              int                         not null,       -- 库存数量

    last_business_id       bigint                      not null,       -- 最后一笔绑定的业务单据

    create_by_id           bigint                      not null,
    create_by_code         varchar(20)                 not null,
    create_by_name         varchar(50)                 not null,
    create_time            datetime                    not null,

    update_by_id           bigint                      null,
    update_by_code         varchar(20)                 null,
    update_by_name         varchar(50)                 null,
    update_time            datetime                    null,
    
    opt_flag               int                         not null default 0,

  PRIMARY KEY(record_id)
);


--
-- 生产计划: 就用produciton_order表
--
create table production_order
(
    record_id              bigint  auto_increment      not null,

    order_no               varchar(20)                 not null,
    order_status           int                         not null,

    production_id          bigint                      not null,
    production_code        varchar(20)                 not null,
    production_name        varchar(50)                 not null,

    -- workshop_id            bigint                      not null,
    -- workshop_code          varchar(20)                 not null,
    -- workshop_name          varchar(50)                 not null,

    plan_date              datetime                    not null,

    qty_planned            int                         not null,
    qty_actual             int                         not null, -- 实际生产
    qty_store              int                         not null, -- 入库数
    qty_good               int                         null,
    qty_bad                int                         null,

    create_by_id           bigint                      not null,
    create_by_code         varchar(20)                 not null,
    create_by_name         varchar(50)                 not null,
    create_time            datetime                    not null,

    update_by_id           bigint                      null,
    update_by_code         varchar(20)                 null,
    update_by_name         varchar(50)                 null,
    update_time            datetime                    null,
    
    opt_flag               int                         not null default 0,

    primary key(record_id)
);

--
-- 生产汇总
--
create table product_summary
(
    record_id             bigint          auto_increment     not null,
    product_date          datetime                           not null,

    workshop_id           bigint                             not null,
    workshop_code         varchar(20)                        not null,
    workshop_name         varchar(50)                        not null,
    
    production_id         bigint                             not null,
    production_code       varchar(20)                        not null,
    production_name       varchar(50)                        not null,

    qty_good_0            int                                not null,
    qty_defect_0          int                                not null,

    qty_good_1            int                                not null,
    qty_defect_1          int                                not null,

    primary key(record_id)
);


--
-- 生产实绩: production_order_progress
--
create table production_order_progress
(
    record_id              bigint   auto_increment   not null,

    production_order_id    bigint                    not null,
    production_order_no    varchar(20)               not null,

    workshop_id            bigint                    not null, -- 车间Id
    workshop_code          varchar(20)               not null,
    workshop_name          varchar(50)               not null,

    workstation_id         bigint                    not null, -- 工位Id
    workstation_code       varchar(20)               not null,
    workstation_name       varchar(50)               not null,
    wocg_code              varchar(20)               not null, -- 工作中心组

    production_id          bigint                    not null, -- 产品编号
    production_code        varchar(20)               not null,
    production_name        varchar(50)               not null,

    rfid_terminator_id     int                       not null, -- 机器号
    rfid_controller_id     int                       not null, -- 组号
    
    time_of_origin         datetime                  not null, -- 报告时间: 日历日
    time_of_origin_work    datetime                  not null, -- 报告时间: 工作日
    shift_id               int                       not null, -- 班次: 0.白班(08:30:00 ~ 19:29:59)  1.夜班(20:00:00 ~ 08:29:59)

    rfid_card_id           bigint                    not null, -- RFID卡记录号
    rfid_card_no           varchar(20)               not null, -- RFID卡号
    report_type            int                       not null, -- 报工类型
    qty                    int                       not null, -- 报工数量    
    card_qty               int                       not null, -- 卡的数量

    operator_id            bigint                    not null,
    employee_id            varchar(20)               not null,
    employee_name          varchar(50)               not null,

    remark                 varchar(250)              null,

    create_by_id           bigint                    not null,
    create_by_code         varchar(20)               not null,
    create_by_name         varchar(50)               not null,
    create_time            datetime                  not null,

    update_by_id           bigint                    null,
    update_by_code         varchar(20)               null,
    update_by_name         varchar(50)               null,
    update_time            datetime                  null,
    
    opt_flag               int                       not null default 0, -- 0. 正常报工记录    64. 尾数新记录  65.尾数已输入数量的记录 66.尾数已处理的记录  127.已包含尾数的刷卡报工记录
    
    primary key(record_id)
);

--
-- 交接记录: production_moving
--
create table production_moving
(
    record_id                  bigint                    auto_increment    not null,
       
    production_order_id        bigint                    not null,
    production_order_no        varchar(20)               not null,
   
    production_id              bigint                    not null,
    production_code            varchar(20)               not null,
    production_name            varchar(50)               not null,
            
    rfid_no                    varchar(20)               not null,
    rfid_card_id               bigint                    not null,
    
    rfid_terminator_id         int                       not null,
    rfid_controller_group_id   int                       not null,             
            
    operator_id                bigint                    not null,
    employee_id                varchar(20)               not null,
    employee_name              varchar(50)               not null,
   
    operator_id_from           bigint                    not null,
    employee_id_from           varchar(20)               not null,
    employee_name_from         varchar(50)               not null,

    qty                        int                       not null,
    time_of_origin             datetime                  not null,
    time_of_origin_work        datetime                      not null, -- 报告时间: 工作日
    shift_id                   int                           not null, -- 班次: 0.白班(08:30:00 ~ 19:29:59)  1.夜班(20:00:00 ~ 08:29:59)

    workshop_id_from           int                       not null,
    workshop_code_from         varchar(20)               not null,
    workshop_name_from         varchar(50)               not null,
   
    workstation_id             int                       not null,
    workstation_code           varchar(20)               not null,
    workstation_name           varchar(50)               not null,
   
    workshop_id                bigint                    not null,
    workshop_code              varchar(20)               not null,
    workshop_name              varchar(50)               not null,
   
    prev_progress_record_id    bigint                    not null,

    create_by_id               bigint                    not null,
    create_by_code             varchar(20)               not null,
    create_by_name             varchar(50)               not null,
    create_time                datetime                  not null,
    
    update_by_id               bigint                    null,
    update_by_code             varchar(20)               null,
    update_by_name             varchar(50)               null,
    update_time                datetime                  null,
        
    opt_flag                   int                       not null default 0,
    PRIMARY KEY(record_id)
);

--
-- 品质代码
--
create table defect(
  record_id                   bigint     auto_increment      not null,
  defect_code                 varchar(20)                    not null,
  defect_name                 varchar(50)                    not null,

  primary key(record_id)
);


--
-- 生产品质: quality_check
--
create table quality_check
(
  record_id                      bigint     auto_increment   not null,
  production_order_id            bigint                      not null,  
  production_order_no            varchar(20)                 not null,  

  production_id                  bigint                      not null,
  production_code                varchar(20)                 not null,
  production_name                varchar(50)                 not null,

  wocg_code                      varchar(20)                 not null,   -- 工作中心组

  workshop_id                    bigint                      not null,  
  workshop_code                  varchar(20)                 not null,
  workshop_name                  varchar(20)                 not null,

  defect_id                      long                        not null,
  defect_code                    varchar(20)                 not null, 
  defect_name                    varchar(500)                not null,
  time_of_origin                 datetime                    not null,
  time_of_origin_work            datetime                    not null, -- 报告时间: 工作日
  shift_id                       int                         not null, -- 班次: 0.白班(08:30:00 ~ 19:29:59)  1.夜班(20:00:00 ~ 08:29:59)  

  qty                            int                         not null,

  create_by_id                   bigint                      not null,
  create_by_code                 varchar(20)                 not null,
  create_by_name                 varchar(50)                 not null,
  create_time                    datetime                    not null,
  
  update_by_id                   bigint                      null,
  update_by_code                 varchar(20)                 null,
  update_by_name                 varchar(50)                 null,
  update_time                    datetime                    null,
     
  opt_flag                       int                         not null default 0,  

  PRIMARY KEY(record_id)  
);

--
-- 员工在工位机上的登录表
--
create table workstation_login
(
  record_id                      bigint     auto_increment   not null,
  
  rfid_terminator_id             int                         not null,
  rfid_controller_group_id       int                         not null,  
  rfid_card_no                   varchar(20)                 not null,
  operator_id                    bigint                      not null,  
  employee_id                    varchar(20)                 not null,
  employee_name                  varchar(50)                 not null,
  login_time                     datetime                    not null,    

  workstation_id                 bigint                      not null,
  workstation_code               varchar(20)                 not null,
  workstation_name               varchar(50)                 not null,

  workshop_id                    bigint                      not null,
  workshop_code                  varchar(20)                 not null,
  workshop_name                  varchar(50)                 not null,

  PRIMARY KEY(record_id)
);

create table workstation_session
(
  record_id              bigint      auto_increment      not null,
  workstation_id         bigint                          not null,
  session_type           int                             not null, -- session的类别: -1. 未知 0. 刷工卡退还工件    1.刷工卡发前工程看板    2. 刷数量卡报工  3.刷数量卡移库   4.刷委外加工卡计数  5.刷委外加工卡外发 6.刷委外加工卡回厂 
  current_step           int                             not null, -- 当前步骤：-1.新建 0.确定session_type  1~250. 当前步骤   253.已过期  254.已取消   255.已完成 
                                                                   --  session_type  的session，只有一个步骤，就是255,因为不需要交互。                                                                   

  operator_id            bigint                          not null, -- 操作员Id
  employee_id            varchar(20)                     not null,
  employee_name          varchar(50)                     not null,
  employee_card_no       varchar(20)                     not null,

  GID                    int                             not null, 
  DID                    int                             not null,  

  create_time            datetime                        not null,
  last_process_time      datetime                        not null,   -- 最后处理时间
  expire_time            datetime                        not null,   -- 过期时间，目前过期时间，就是最后处理时间后的一分钟，如果一分钟内没有任何处理，就默认为过期了。

  primary key(record_Id)
);

create table workstation_session_step
(
  record_id                    bigint       auto_increment     not null,
  workstation_session_id       bigint                          not null,
  step                         int                             not null,
  
  req_time                     datetime                        not null, -- 请求时间
  req_data_type                int                             not null, -- 1. 工卡    2.数量卡   3.委外加工卡    4.键盘输入   
  req_data                     varchar(20)                     not null, -- 请求的数据
    
  resp_data                    varchar(200)                    not null, -- 从服务器返回的结果
  resp_time                    datetime                        not null, -- 返回时间

  primary key(record_id)
);

create table outsource_workstation_bind
(
    record_id               bigint       auto_increment   not null,
    outsource_card_id       bigint                        not null,
    outsource_card_no       varchar(20)                   not null,    
    workstation_id          bigint                        not null,
    workstation_code        varchar(20)                   not null,
    workstation_name        varchar(50)                   not null,
    workshop_id             bigint                        not null,
    workshop_code           varchar(20)                   not null,
    workshop_name           varchar(50)                   not null,
    attach_time             datetime                      not null,       -- 绑定时间
    out_time                datetime                      null,           -- 外发时间
    back_time               datetime                      null,           -- 回厂时间
    bind_status             int                           not null,       -- 1.已绑定   10.已经有绑定的卡报工  20.已外发    30.已回厂

    primary key(record_id)
);

create table outsource_card_bind(
    record_id               bigint       auto_increment   not null,
    outsource_card_id       bigint                        not null,       -- 外发卡
    outsource_card_no       varchar(20)                   not null,
    qty_report_id           bigint                        not null,       -- 报工记录号
    qty_card_id             bigint                        not null,       -- 数量卡
    qty_card_no             varchar(20)                   not null,
    attach_time             datetime                      not null,       -- 绑定时间
    workstation_bind_id     bigint                        not null,

    primary key(record_id)
);

