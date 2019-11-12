create procedure MES_ReportWip_1
(
    /*
        MES_DoReportWip_1: 外发前工程报工，E/V前工程的车间进行生产报工。
    */
    in    WorkstaitonId        int,              -- 报工工位
    in    BindId               bigint,
    in    CardId               int,              -- RFID
    in    ReqTime              datetime,         -- 报工时间
    out   ReportQty            int,               -- 结果：报工数量
    out   LastBusinessId       bigint
)
begin
    declare OutSourceCardId bigint;
    declare OutSoruceCardNo,OutSourceCardNo,RfidNo varchar(20);

    -- 进行正常报工
    call MES_ReportWip_0(WorkstationId,CardId,ReqTime,ReportQty,LastBusinessId);

    -- 更新外发工位的绑定状态
    select record_id,outsource_card_id,outsource_card_no 
         into OutSourceCardId,OutSourceCardNo
     from outsource_workstation_bind
    where record_id = BindId;

    update outsource_workstation_bind
       set bind_status = 10
    where record_id = BindId;

    -- 工程内看板与外发看板的绑定对应关系
    insert into outsource_card_bind(outsource_card_id,outsource_card_no,qty_report_id,qty_card_id,qty_card_no,attach_time,workstation_bind_id)
       values(OutSourceCardId,OutSourceCardNo,LastBusinessId,RfidNo,Now(),BindId);
    
    -- 更新外发看板的完工数量
    update rfid_card
      set stock_qty = stock_qty + ifnull(ReportQty,0),
          card_status = 10   -- 外发看板已报工
    where record_id = OutSourceCardId;    
end;