-- 按照存储区域同步数据给ERP
alter table quality_check add loc_code varchar(20);
alter table work_organization_unit add loc_code varchar(20);

update work_organization_unit
   set loc_code = parent_code
where parent_code <>'THR'
  and org_type = 'ORG_WORK_STATION';

update work_organization_unit
  set loc_code = wocg_code
where parent_code = 'THR'
  and org_type = 'ORG_WORK_STATION';    

