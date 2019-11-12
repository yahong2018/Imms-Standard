create procedure  MES_GetCardType(
    in  CardNo     varchar(20),
    out CardType   int, 
    out CardId     bigint
)
begin
   select -1,-1 into CardType,CardId;

   select record_id,card_type into CardId,CardType
      from rfid_card
      where rfid_no = CardNo;

   if(CardId = -1) then   -- 员工卡
        select record_id,1 into CardId,CardType 
          from  operator
        where employee_card_no = CardNo;
   end if;           
end;