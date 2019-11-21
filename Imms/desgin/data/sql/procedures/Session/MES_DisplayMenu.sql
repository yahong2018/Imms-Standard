drop procedure MES_DisplayMenu;

create procedure MES_DisplayMenu(  
    out    RespHint              varchar(200),
    out    RespData              varchar(200)
)
begin
    set RespData = '3';  
    set RespData = CONCAT(RespData,'|1|请选择功能：|0');	 
    set RespData = CONCAT(RespData,'|2|1.工件退回|0');	 
    set RespData = CONCAT(RespData,'|3|2.给前工程发卡|0');	 
    
    set RespHint = '按键1和2进行功能选择';
end;
