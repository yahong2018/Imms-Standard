-- 增加外发数量字段
alter table rfid_card add outsource_qty int not null default 0;

-- 修改EV的数据，很多数据是错误的
/*
   从以下数据可以看出来，当前E/V前加工的看板的数据是错误的，需要重新配置
*/
select * from bom where material_code = '13711-0V030';      -- 成品
select * from bom where material_code = '13711-0V030-08';   -- 后加工
select * from bom where material_code = '13711-0V030-30';   -- 外发
select * from bom where material_code = '13711-0V030-04';   -- 前加工
select * from bom where material_code = '13711-0V030-70';   -- 切断
select * from bom where material_code = '13711-0V030-10';   -- 锻造
select * from bom where material_code = '31251001';         -- 原材料

/*
   需要对数据进行如下修改，将E/V前加工的看板的物料数据按照bom表进行配置
*/
select * from rfid_card where production_code = '13711-0V030' and workshop_code = 'QJG';
-- 205	13711-0V030-04	6AR进气阀前加工
update rfid_card 
  set production_id = 205,
	    production_code = '13711-0V030-04',
			production_name = '6AR进气阀前加工'
where production_code = '13711-0V030' 
  and workshop_code = 'QJG';			
			
/*
   修改存储过程
       MES_IssueCard_2
       MES_MoveWip(全部)
       MES_PartialReport_2
       MES_ReportWip,MES_ReportWip_0,MES_ReportWip_1
       MES_WipCardInput
       MES_AssureMaterialStock
       MES_ParseCardStatus
*/

/*
    修改、升级程序
*/



