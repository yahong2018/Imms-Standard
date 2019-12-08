drop procedure if exists MES_PartialReport_1;

create procedure MES_PartialReport_1
(    
    in WorkstationId    bigint,
    in CardId           bigint,		
    in DefaultIssueQty  int,
    out Success         int,
    out RespHint        varchar(200),
    out RespData        varchar(200)
)
top:begin       
    declare CardWorkWorkshopId,WorkshopId bigint;
    declare CardWorkshopName varchar(50);
    select -1,'','' into Success,RespData,RespHint;	 

    select c.workshop_id,c.workshop_name into CardWorkWorkshopId,CardWorkshopName from rfid_card c where c.record_id = CardId;
    select w.parent_id into WorkshopId from work_organization_unit w where record_id = WorkstationId; 

    call MES_Debug(CONCAT('MES_PartialReport_1 ---> CardWorkWorkshopId:',CardWorkWorkshopId,',WorkshopId:',WorkshopId,',CardId:',CardId,',WorkstationId:',WorkstationId));
    
    if CardWorkWorkshopId <> WorkshopId then
        set RespData='2';    
        set RespData = CONCAT(RespData,'|1|本看板可以报工车间:|0');			
        set RespData = CONCAT(RespData,'|2|',CardWorkshopName,'|0');

        leave top;
    end if;
        
    set RespData='4';    
    set RespData = CONCAT(RespData,'|1|剩余总数为:',DefaultIssueQty,'|0');			
    set RespData = CONCAT(RespData,'|2|请输入尾数，再按确定|0');					
    set RespData = CONCAT(RespData,'|4|使用剩余总数直接按确定|0');

    set RespHint = '输入尾数：';
    		
	set Success = 0;
end;
