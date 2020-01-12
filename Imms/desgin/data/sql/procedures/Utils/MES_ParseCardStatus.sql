drop procedure if exists MES_ParseCardStatus;

create procedure MES_ParseCardStatus(
    in     StatusCode    int,
    out    StatusName    varchar(20)
)
begin
   if StatusCode = 0 then
      set StatusName = '未派发';
   elseif(StatusCode = 1) then 
      set StatusName = '已派发';
   elseif(StatusCode = 2) then
      set StatusName = '已退回';
   elseif(StatusCode = 3) then
      set StatusName = '已绑定';
   elseif(StatusCode = 4) then   -- 外发看板 
      set StatusName = '已外发';
   elseif(StatusCode = 10) then
      set StatusName = '已报工(已回厂)';
   elseif(StatusCode = 20) then
      set StatusName = '已移库(已投入)';
   elseif(StatusCode = 255) then
      set StatusName = '已作废';
   else
      set StatusName = '未注册';
   end if;
end;

/*
   1.前加工报工的时候，不要更改外发看板的状态
   2.外发看板在打卡外发的时候，将状态更改为"4.已外发" 
      if (CardType = 3) and (CardOpIndex = WorkshopOpIndex) and (CardStatus <> 3) then
         pirintf "没有绑卡，不可以外发";
         leave top;
      end if;

      update rfid_card
        set card_status = 4
      where card_id = CardId;
*/