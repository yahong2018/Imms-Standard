drop procedure if exists MES_DisplayMenu;
delimiter $$
create procedure MES_DisplayMenu(  
    out    RespHint              varchar(200),
    out    RespData              varchar(200)
)
begin
    set RespData = '4';  
    set RespData = CONCAT(RespData,'|1|请选择功能：|0');	 
    set RespData = CONCAT(RespData,'|2|1.工件退回|0');	 
    set RespData = CONCAT(RespData,'|3|2.给前工程发卡|0');	 
    set RespData = CONCAT(RespData,'|4|3.尾数报工|0');	 
    
    set RespHint = '按键1,2,3进行功能选择';
end $$

delimiter ;
