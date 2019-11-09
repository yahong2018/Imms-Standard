create procedure MES_DoMoveWipEx(  
  in    WorkstationId        bigint,  
  in    CardId               bigint,  
  in    ReqTime              datetime,
  out   RespData             varchar(200)
)
begin  
    declare ShiftId,BindStatus,BasketCount,TotalQty int;
    declare TimeOfOriginWork datetime;	
	declare WorkstationCode varchar(20),WorkstationName varchar(50),GID int,DID int,WocgCode varchar(20),WorkshopId bigint, WorkshopCode varchar(20) WorkshopName varchar(50);
	
	declare LastBusinessId bigint;
	declare StockQty int;
	
	select last_business_id,stock_qty into LastBusinessId,StockQty
		from rfid_card 
	where record_id = CardId;		
		
    -- 移库记录
    if CardType = 2 then		
		call MES_DoMoveWipByQtyCard(WorkstaitonId,LastBusinessId,CardId,ReqTime);
			
		-- 返回结果
		set RespData=	'2|1|2';
		set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次
		set RespData = CONCAT(RespData,'|1|已移库',StockQty,'个|0');  	
    else  -- 外发卡 CardType = 3
		if (WorkstationBindStatus = 10) then -- 如果是外发出厂
				call MES_DoMoveWipByOutSourceCard_Out(WorkstationId,CardId,LastBusinessId,ReqTime);						
		elseif (WorkstationBindStatus = 20) then -- 如果是外发回厂
				insert into production_order_progress(
						production_order_id,production_order_no,production_id,production_code,production_name,
						workshop_id,workshop_code,workshop_name,
						workstation_id,workstation_code,workstation_name,	wocg_code,		
						rfid_terminator_id,rfid_controller_id,			
						rfid_card_id,rfid_card_no,report_type,			
						operator_id,employee_id,employee_name,			
						create_by_id,create_by_code,create_by_name,create_time,			
						update_by_id,update_by_code,update_by_name,update_time,opt_flag,
						time_of_origin,time_of_origin_work,shift_id,qty,card_qty    
				) select 
						-1,'',p.production_id,p.production_code,p.production_name,
						CardWorkshopId,CardWorkshopCode,CardWorkshopName,
						-1,'','','',
						DID,GID,			
						CardId,RfidNo,0,
						-1,'','',			
						1,'SYS','数据采集平台',Now(),			
						null,null,null,null,0,
						ReqTime,TimeOfOriginWork,ShiftId,p.qty,p.card_qty
				from production_order_progress p
				where p.record_id in(
					select qty_report_id from outsource_card_bind
						where workstation_bind_id = WorkstationBindId
				);           

				insert into production_moving(
						production_order_id,production_order_no,production_id,production_code,production_name,
						rfid_no,rfid_card_id,rfid_terminator_id,rfid_controller_group_id,qty,
						operator_id,employee_id,employee_name,time_of_origin,time_of_origin_work,shift_id,
						workstation_id,workstation_code,workstation_name,workshop_id,workshop_code,workshop_name,
						workshop_id_from,workshop_code_from,workshop_name_from,
						create_by_id,create_by_code,create_by_name,create_time,
						update_by_id,update_by_code,update_by_name,update_time,opt_flag,prev_progress_record_id
				)select 
						-1,'',ProductionId,ProductionCode,ProductionName,
						RfidNo,CardId,DID,GID,p.qty,
						-1,'','',ReqTime,TimeOfOriginWork,ShiftId,
						WorkstationId,WorkstationCode,WorkstationName,LoginedWorkshopId,LoginedWorkshopCode,LoginedWorkshopName,
						CardWorkshopId,CardWorkshopCode,CardWorkshopName,
						1,'SYS','数据采集平台',Now(),
						null,null,null,null,0,p.record_id
				from production_order_progress p
				where p.record_id in(
						select qty_report_id from outsource_card_bind
							where workstation_bind_id = WorkstationBindId
				);
		end if;		
			  
		select count(*),sum(qty) into BasketCount,TotalQty
        from production_order_progress p
        where p.record_id in(
            select qty_report_id from outsource_card_bind
              where workstation_bind_id = WorkstationBindId
        );  			  
				
		-- 返回结果
		set RespData=	'2|1|2';
		set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');  -- 锁定所有的键盘，发声一次
		set RespData = CONCAT(RespData,'|1|已移库:',BasketCount,'项,|0');  			
		set RespData = CONCAT(RespData,'|2|共计',TotalQty,'个,|0');  
	
    end if;

    -- 更新状态和卡的库存数量
    if CardType = 2 then
        update rfid_card
          set card_status = 20  -- 0. 未使用   1. 已派发     10. 已报工   20. 已移库收货         
        where record_id = CardId;        
    else 
        update rfid_card
          set card_status = 20  
        where record_id in(
            select qty_card_id from outsource_card_bind
              where workstation_bind_id = WorkstationBindId          
        );
    end if;

    if CardType = 3 then  
       if WorkstationBindStatus = 1 then   -- 外发
          update outsource_workstation_bind
              set out_time = Now(),
                  bind_status = bind_status + 1
          where record_id = WorkstationBindId;
        else   -- -- 回厂
          update outsource_workstation_bind
              set back_time = Now(),
                  bind_status = bind_status + 1
          where record_id = WorkstationBindId;        
        end if;
    end if;	 
end