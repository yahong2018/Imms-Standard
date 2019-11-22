drop procedure MES_HandleIssueCardError;
create procedure MES_HandleIssueCardError(
    in      CurrentStep     int,
    in      ReqDataType     int,
    in      ReqData         varchar(20),
    in      CardStatus      int,
    inout   RespData        varchar(200)
)
begin
    declare CardStatusName varchar(20);

    call MES_Debug('MES_HandleIssueCardError');

    if (CurrentStep = 0)  and  (ReqDataType <> 4) then
        set RespData='2';    
        set RespData = CONCAT(RespData,'|1|发卡第1步:|0');		       
        set RespData = CONCAT(RespData,'|2|请输入1或者2.|0');
    elseif(CurrentStep = 1) then
        if (ReqDataType <> 2) then
            set RespData='2';    
            set RespData = CONCAT(RespData,'|1|发卡第2步:|0');		       
            set RespData = CONCAT(RespData,'|2|请刷看板。|0');
        elseif( not CardStatus in (0,20,40)) then   -- 40为外发回厂投入
            call MES_ParseCardStatus(CardStatus,CardStatusName);
          
            set RespData='2';  
            set RespData = CONCAT(RespData,'|1|当前卡的状态为:',CardStatusName,'|0');  
            set RespData = CONCAT(RespData,'|2|只能派已移库或未使用的卡|0');		 
        end if;    
    elseif(CurrentStep = 2) and (ReqDataType <> 4)then        
        set RespData='2';    
        set RespData = CONCAT(RespData,'|1|发卡第3步:|0');		       
        set RespData = CONCAT(RespData,'|2|请输入正确的派发数量.|0'); 
    end if;
end;