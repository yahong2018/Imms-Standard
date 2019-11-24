drop procedure if exists MES_HandlePartialReportError ;
create procedure MES_HandlePartialReportError(
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
        set RespData = CONCAT(RespData,'|1|尾数报工第1步:|0');		       
        set RespData = CONCAT(RespData,'|2|请输入3.|0');
    elseif(CurrentStep = 1) then
        if (ReqDataType <> 2) then
            set RespData='2';    
            set RespData = CONCAT(RespData,'|1|发卡第2步:|0');		       
            set RespData = CONCAT(RespData,'|2|请刷工程内看板。|0');
        elseif( not CardStatus in (1,10)) then   -- 40为外发回厂投入
            call MES_ParseCardStatus(CardStatus,CardStatusName);
          
            set RespData='2';
            set RespData = CONCAT(RespData,'|1|当前卡的状态为:',CardStatusName,'|0');  
            set RespData = CONCAT(RespData,'|2|已派发的卡才可以报工.|0');		 
        end if;    
    elseif(CurrentStep = 2) and (ReqDataType <> 4)then        
        set RespData='2';    
        set RespData = CONCAT(RespData,'|1|尾数报工第3步:|0');		       
        set RespData = CONCAT(RespData,'|2|请输入正确的派发数量.|0'); 
    end if;
end;