create procedure MES_GetWorkDayAndShiftId(
   in  ReqTime              datetime,
   out TimeOfOriginWork     datetime,
   out ShiftId              int
)
begin
  declare ReqYear,ReqMonth,ReqDay,ReqHour,ReqMinute int;
  -- 设置工作班次和工作日
  select Year(ReqTime),Month(ReqTime),Day(ReqTime),Hour(ReqTime),Minute(ReqTime)   into ReqYear,ReqMonth,ReqDay,ReqHour,ReqMinute;
  set TimeOfOriginWork = ReqTime;
	set ShiftId = 0;
	
  if (ReqHour <= 8) and (ReqMinute<30) then
    set TimeOfOriginWork = date_add(ReqTime, interval -1 day);    
    set ShiftId = 1;
  end if;
  if (ReqHour >= 20) then
    set ShiftId = 1;
  end if;
  select Year(TimeOfOriginWork),Month(TimeOfOriginWork),Day(TimeOfOriginWork)   into ReqYear,ReqMonth,ReqDay;    
  set TimeOfOriginWork = cast(CONCAT(ReqYear,'/',ReqMonth,'/',ReqDay) as datetime);   
end;