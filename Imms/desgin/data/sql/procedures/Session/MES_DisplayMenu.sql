create procedure MES_DisplayMenu(  
  out    RespData              varchar(200)
)
begin
  set RespData = '|2|1|4';
  set RespData = CONCAT(RespData,'|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
  set RespData = CONCAT(RespData,'|1|请选择功能：|0');	 
  set RespData = CONCAT(RespData,'|2|1.工件退回|0');	 
  set RespData = CONCAT(RespData,'|3|2.给前工程发卡|0');	 
end;
