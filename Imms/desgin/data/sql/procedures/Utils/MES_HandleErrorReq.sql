create procedure MES_HandleErrorReq(
  in     ReqData       varchar(20),
  out    RespData      varchar(200)
)
begin
  set RespData = '|2|1|3';
  set RespData = CONCAT(RespData,'|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150');
  set RespData = CONCAT(RespData,'|1|无效输入:|0');	 
  set RespData = CONCAT(RespData,'|2|',ReqData,'|0');   
end;
