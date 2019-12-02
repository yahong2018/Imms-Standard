-- 公网地址 http://202.105.31.227
-- 内网地址 http://192.168.121.11

-- 测试账套 1
-- 正式账号 63

-- select * from rfid_card c
--   where c.production_code not in(
--     select material_code from material
-- );

-- update rfid_card c, material m,work_organization_unit w
--    set c.card_type = 2,
--        c.card_status = 1,
-- 	   c.production_id = m.record_id,
-- 	   c.workshop_id = w.record_id,	   
-- 	 --  c.kanban_no='',
-- 	   c.stock_qty = 0,
-- 	   c.last_business_id = 0,
-- 	   c.create_by_id = 1,
-- 	   c.create_by_code='C00001',
-- 	   c.create_by_name = '刘永红',
-- 	   c.create_time = Now(),
-- 	   c.opt_flag = 0
-- where c.production_code = m.material_code
--   and c.workshop_code = w.org_code
--   ;

-- insert into material(material_code,material_name,auto_finished_progress,create_by_id,create_by_code,create_by_name,create_time,opt_flag)
-- select distinct production_code,production_name,0,1,'C00001','刘永红','2019/11/17',0
-- from rfid_card c
-- where not exists (
--    select * from material m where m.material_code = c.production_code
-- );  


-- YZ     0013036214   0011000720
-- CJG    0013035131   0011007033
-- MC-JG  0011020818   0011015954
-- THR    0002299238   0011010081


-- B      0005242241   0011018160
-- A      0005252159   0010995284

-- -- select * from rfid_card where rfid_no = '0002299238';
-- -- select * from rfid_card where rfid_no = '0011020818';
-- -- select * from rfid_card where rfid_no = '0013035131';
-- -- select * from rfid_card where rfid_no = '0013036214';

-- -- select * from operator where employee_card_no='0005242241';
-- -- select * from operator where employee_card_no='0005252159';

-- -- select * from rfid_card where rfid_no = '0011000720';
-- -- select * from rfid_card where rfid_no = '0011007033';
-- -- select * from rfid_card where rfid_no = '0011015954';

-- -- select * from rfid_card where rfid_no = '0011010081';

-- -- select * from operator where employee_card_no='0011018160';
-- -- select * from operator where employee_card_no='0010995284';


-- -- update excel_import_rfid_card c,material m
-- --    set c.production_id = m.record_id
-- -- where c.production_code = m.material_code;

-- -- 
-- -- update excel_import_rfid_card c,work_organization_unit w
-- --    set c.workshop_id = w.record_id
-- -- where c.workshop_code = w.org_code;
-- -- 
-- -- 
-- -- insert into rfid_card(kanban_no,rfid_no,card_type,card_status,
-- -- 		production_Id,production_code,production_name,
-- -- 		workshop_id,workshop_code,workshop_name,
-- -- 		issue_qty,stock_qty,last_business_id,
-- -- 		create_by_id,create_by_code,create_by_name,
-- -- 		opt_flag)
-- -- select e.kanban_no,e.rfid_no,2,1,
-- --        e.production_id,e.production_code,e.production_name,
-- -- 	   e.workshop_id,e.workshop_code,e.workshop_name,
-- -- 	   e.issue_qty,0,-1,
-- -- 	   1,'C00001','刘永红',
-- -- 	   0	   
-- --    from excel_import_rfid_card e


-- /Users/yahong/Desktop/pub_20191118



-- -- truncate excel_import_rfid_card;

-- -- update excel_import_rfid_card c,material m,work_organization_unit w
-- --    set c.production_id = m.record_id,
-- --        c.workshop_id = w.record_id,
-- --        c.workshop_name = w.org_name
-- --   where c.production_code = m.material_code
-- --      and c.workshop_code = w.org_code
-- -- 	 ;
-- --   
       
	   
-- -- select * from 	 excel_import_rfid_card
-- --   where production_id is null
-- --     or workshop_id is null
-- -- 

-- -- insert into rfid_card(
-- --      kanban_no,rfid_no,card_type,card_status,
-- -- 	 production_id,production_code,production_name,
-- -- 	 workshop_id,workshop_code,workshop_name,
-- -- 	 issue_qty,stock_qty,last_business_id,
-- -- 	 create_by_id,create_by_code,create_by_name,create_time,opt_flag)
-- -- select 	kanban_no,rfid_no,2,1,
-- -- 	    production_id,production_code,production_name,
-- -- 	    workshop_id,workshop_code,workshop_name,
-- -- 		issue_qty,0,-1,
-- -- 		1,'C00001','刘永红',Now(),0
-- -- from excel_import_rfid_card
-- -- ;
-- -- 
-- -- 					 

-- select * from rfid_card c0
--    where c0.record_id in(
-- 	select min(c1.record_id) as record_id  from rfid_card c1
--  	 where c1.rfid_no in(
-- 	select c2.rfid_no from rfid_card c2
-- 	   group by c2.rfid_no
-- 	   having count(c2.rfid_no) > 1
-- 	) group by c1.rfid_no
-- )



-- insert into material(material_code,material_name,auto_finished_progress,create_by_id,create_by_code,create_by_name,create_time,opt_flag)
-- select distinct production_code,production_name,0,1,'C00001','刘永红','2019/11/24',0
-- from excel_import_rfid_card c
-- where not exists (
--    select * from material m where m.material_code = c.production_code
-- );  

-- update rfid_card c,material m,work_organization_unit w
--    set c.production_id = m.record_id,
--        c.workshop_id = w.record_id,
--        c.workshop_name = w.org_name
--   where c.production_code = m.material_code
--      and c.workshop_code = w.org_code
-- 	 and c.workshop_id =0;  

-- --
-- -- update rfid_card
-- --   set card_status = 20
-- -- where tower_no in ('3I','3E','3B','3J','6A','9P','6B','9G','9I','9D','9C','6G','10F','10H','10D','10C','6C','1C','6I','5D','4H','5J','5C')
-- -- ;
-- -- 

-- -- 
-- --  update rfid_card
-- --    set card_status = 30
-- -- where tower_no in ('3F','3D','4D','8H','8G','8K','8M','7F','8D','5E','6H','1K','9E','9B','9O','9H','10E','10G','1L')
-- -- ;

--------------------------------------------------------------------
--
-- 2019/11/26 晚上
--

-- alter table work_organization_unit
-- add auto_report_count      int                         not null default 0;


-- alter table rfid_card
-- add tower_no               varchar(20)                 not null default '';

-- update rfid_card
--    set card_status = 10    
-- where tower_no in ('7A','7E','9Q','9A','9C','6D','9E','9K','4C','5P')
--     and card_status  = 1


--------------------------------------------------------------------
-- 2019/11/27

--  1125-02830  --> 1125-02831
--  1125-13ET0  --> 1125-08500

-- update material
--   set material_code = '1125-08500'
-- where material_code = '1125-13EJ0'
-- ;

-- update material_stock
--   set material_code = '1125-08500'
-- where material_code = '1125-13EJ0'
-- ;

-- update product_summary
--    set production_code = '1125-08500'
-- where production_code = '1125-13EJ0'
-- ;

-- update production_order_progress
--    set production_code = '1125-08500'
-- where production_code = '1125-13EJ0'
-- ;


-- update production_moving
--    set production_code = '1125-08500'
-- where production_code = '1125-13EJ0'
-- ;

-- update rfid_card
--    set production_code = '1125-08500'
-- where production_code = '1125-13EJ0'
-- ;


-- update quality_check
--    set production_code = '1125-08500'
-- where production_code = '1125-13EJ0'
-- ;
