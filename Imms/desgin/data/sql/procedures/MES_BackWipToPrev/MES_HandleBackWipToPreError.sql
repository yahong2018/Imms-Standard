drop procedure MES_HandleBackWipToPreError;
create procedure MES_HandleBackWipToPreError(
    in        CurrentStep     int,
    in        ReqDataType     int,    
    in        CardStatus      int,
    inout     RespData        varchar(200)    
)
begin
    declare StatusName varchar(20);

    if (CurrentStep = 0) and (ReqDataType <> 4) then  
       set RespData='2';    
       set RespData = CONCAT(RespData,'|1|工件退回第1步:|0');		       
       set RespData = CONCAT(RespData,'|2|请输入1.|0');
    elseif(CurrentStep = 1)  then    
        if ReqDataType <> 2 then
            set RespData='2';    
            set RespData = CONCAT(RespData,'|1|工件退回第2步:|0');		       
            set RespData = CONCAT(RespData,'|2|请刷看板.|0');
        end if;

        if CardStatus <> 20 then
            set RespData='2';    
            call MES_ParseCardStatus(CardStatus,StatusName);
            set RespData = CONCAT(RespData,'|1|当前看板状态为:',StatusName,'|0');
            set RespData = CONCAT(RespData,'|2|不可以退回.|0');        
        end if;
    elseif(CurrentStep = 2) then
        if (ReqDataType <> 4) then
            set RespData='2';    
            set RespData = CONCAT(RespData,'|1|工件退回第3步:|0');		       
            set RespData = CONCAT(RespData,'|2|请输入退回数量.|0');        
        end if;
    elseif(CurrentStep = 3) then
        if (ReqDataType <> 1) then
            set RespData='2';    
            set RespData = CONCAT(RespData,'|1|工件退回最后一步:|0');		       
            set RespData = CONCAT(RespData,'|2|请接收人刷卡.|0');                
        end if;
    end if;
end;