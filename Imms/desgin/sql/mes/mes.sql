
create table work_organization_unit  
(
  record_id                bigint auto_increment           not null,
  organization_type        varchar(128)                    not null,  -- 生产组织单元类别：工厂,工作中心,生产线,工位
  organization_code        varchar(50)                     not null,
  organization_name        varchar(50)                     not null,
  description              varchar(250)                    null ,  
  parent_organization_id   bigint                          null,  -- 上级生产单元，顶级为0

  operator_id              bigint                          null default 0,  -- 当前操作员
  
  create_by                            bigint                       not null,
  create_date                          datetime                     not null,
  update_by                            bigint                       null,
  update_date                          datetime                     null,
  opt_flag                             int                          not null default 0,

  primary key (record_id) ,  
  index idx_work_organization_unit_01(organization_code),
  index idx_work_organization_unit_02(organization_type),
  index idx_work_organization_unit_03(parent_organization_id),
  index idx_work_organization_unit_04(parent_organization_code)
);