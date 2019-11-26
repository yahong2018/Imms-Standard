drop procedure if exists MES_HandleErrorReq;

create procedure MES_HandleErrorReq(
  in     ReqData       varchar(20),
  out    RespData      varchar(200)
)
begin     
  set RespData = '2';  
  set RespData = CONCAT(RespData,'|1||0');	   
  set RespData = CONCAT(RespData,'|2|无效输入:',ReqData,'|0');   
end;
