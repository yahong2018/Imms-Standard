drop procedure MES_HandleErrorReq;

create procedure MES_HandleErrorReq(
  in     ReqData       varchar(20),
  out    RespData      varchar(200)
)
begin   
  set RespData = '3';  
  set RespData = CONCAT(RespData,'|1|无效输入:|0');	 
  set RespData = CONCAT(RespData,'|2|',ReqData,'|0');   

  call MES_Error(RespData);
end;
