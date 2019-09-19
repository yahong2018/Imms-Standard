--
-- 系统参数，包括与ERP的接口
--
create table system_parameters
(
    record_id          bigint  auto_increment   not null,
    parameter_code     varchar(50)              not null,
    parameter_name     varchar(120)             not null,
    parameter_value    varchar(255)             not null,

    PRIMARY KEY (record_id),
    index IDX_SYSTEM_PARAMETER_0(parameter_code),
    index IDX_SYSTEM_PARAMETER_1(parameter_name)
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
  index IDX_SYSTEM_LOGS(log_type)                   
);

--
-- 工位机
-- 


--
-- 组织
--
alter table work_organization_unit
   add rfid_controller_id  bigint not null default 0,  -- 工位：控制器
   add rfid_terminator_id  bigint not null default 0,  -- 工位：工位机
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
-- 工艺流程： 就是工艺路线
--

--
-- 产品 ： 就是物料
--

--
-- 发卡管理
--
create table rfid_card
(
  record_id      bigint  auto_increment  not null default 0,
  rfid_no        varchar(20)             not null,
  card_type      int                     not null,
  card_status    int                     not null,
  production_id  bigint                  not null,        -- （工艺数量卡）所代表的产品
  operation_id   bigint                  null,            -- （工艺数量卡）所代表的工艺
  qty            int                     null,            -- （工艺数量卡）数量
  operator_id    bigint                  null,            -- （员工卡）   操作员

  PRIMARY KEY(record_id),
  index IDX_RFID_CARD_0(rfid_no),
  index IDX_RFID_CARD_1(card_type),
  index IDX_RFID_CARD_2(card_status)       
);





