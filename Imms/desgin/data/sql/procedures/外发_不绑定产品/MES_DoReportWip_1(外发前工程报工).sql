drop procedure MES_DoReportWip_1;

create procedure MES_DoReportWip_1
(
    /*
        MES_DoReportWip_1: 外发前工程报工，E/V前工程的车间进行生产报工。
    */
    in    WorkstaitonId        int,              -- 报工工位
    in    CardId               int,              -- RFID
    in    ReqTime              datetime,         -- 报工时间
    out   ReportQty            int               -- 结果：报工数量
)
begin
    declare LastBusinessId,WorkstationBindId,OutSourceCardId bigint;
    declare OutSoruceCardNo,OutSourceCardNo,RfidNo varchar(20);

    -- 进行正常报工
    call MES_DoReportWip_0(WorkstationId,CardId,ReqTime,ReportQty);

    -- 前工程绑定记录
    select record_id,outsource_card_id,outsource_card_no 
         into WorkstationBindId,OutSourceCardId,OutSourceCardNo
     from outsource_workstation_bind
    where workstation_id = WorkstationId         
    order by attach_time desc
    limit 1;

    update outsource_workstation_bind
       set bind_status = 10
    where record_id = WorkstationBindId;

    insert into outsource_card_bind(outsource_card_id,outsource_card_no,qty_report_id,qty_card_id,qty_card_no,attach_time,workstation_bind_id)
       values(OutSourceCardId,OutSoruceCardNo,LastBusinessId,RfidNo,Now(),WorkstationBindId);

    set ReportQty = ifnull(ReportQty,0);
end;