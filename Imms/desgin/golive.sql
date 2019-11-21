公网地址 http://202.105.31.227
内网地址 http://192.168.121.11

测试账套 1
正式账号 63

select * from rfid_card c
  where c.production_code not in(
    select material_code from material
);

update rfid_card c, material m,work_organization_unit w
   set c.card_type = 2,
       c.card_status = 1,
	   c.production_id = m.record_id,
	   c.workshop_id = w.record_id,	   
	 --  c.kanban_no='',
	   c.stock_qty = 0,
	   c.last_business_id = 0,
	   c.create_by_id = 1,
	   c.create_by_code='C00001',
	   c.create_by_name = '刘永红',
	   c.create_time = Now(),
	   c.opt_flag = 0
where c.production_code = m.material_code
  and c.workshop_code = w.org_code
  ;

insert into material(material_code,material_name,auto_finished_progress,create_by_id,create_by_code,create_by_name,create_time,opt_flag)
select distinct production_code,production_name,0,1,'C00001','刘永红','2019/11/17',0
from rfid_card c
where not exists (
   select * from material m where m.material_code = c.production_code
);  


YZ     0013036214   0011000720
CJG    0013035131   0011007033
MC-JG  0011020818   0011015954
THR    0002299238   0011010081


B      0005242241   0011018160
A      0005252159   0010995284

-- select * from rfid_card where rfid_no = '0002299238';
-- select * from rfid_card where rfid_no = '0011020818';
-- select * from rfid_card where rfid_no = '0013035131';
-- select * from rfid_card where rfid_no = '0013036214';

-- select * from operator where employee_card_no='0005242241';
-- select * from operator where employee_card_no='0005252159';

-- select * from rfid_card where rfid_no = '0011000720';
-- select * from rfid_card where rfid_no = '0011007033';
-- select * from rfid_card where rfid_no = '0011015954';

-- select * from rfid_card where rfid_no = '0011010081';

-- select * from operator where employee_card_no='0011018160';
-- select * from operator where employee_card_no='0010995284';


-- update excel_import_rfid_card c,material m
--    set c.production_id = m.record_id
-- where c.production_code = m.material_code;

-- 
-- update excel_import_rfid_card c,work_organization_unit w
--    set c.workshop_id = w.record_id
-- where c.workshop_code = w.org_code;
-- 
-- 
-- insert into rfid_card(kanban_no,rfid_no,card_type,card_status,
-- 		production_Id,production_code,production_name,
-- 		workshop_id,workshop_code,workshop_name,
-- 		issue_qty,stock_qty,last_business_id,
-- 		create_by_id,create_by_code,create_by_name,
-- 		opt_flag)
-- select e.kanban_no,e.rfid_no,2,1,
--        e.production_id,e.production_code,e.production_name,
-- 	   e.workshop_id,e.workshop_code,e.workshop_name,
-- 	   e.issue_qty,0,-1,
-- 	   1,'C00001','刘永红',
-- 	   0	   
--    from excel_import_rfid_card e


/Users/yahong/Desktop/pub_20191118