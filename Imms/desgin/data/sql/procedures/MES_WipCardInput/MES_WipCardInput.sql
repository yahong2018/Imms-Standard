create procedure MES_WipCardInput(     
    in     WorkstationId       bigint,
    in     CardType            int,           -- 1. 工卡    2. 工程内看板    3.外发看板   4.键盘输入
    in     RfidNo              varchar(20),
    in     CardId              bigint,   
    in     ReqTime             datetime,
    out    RespData            varchar(200)
)
top:begin    
    declare CardStatus,WorkshopType,WorkshopOpIndex,WorkshopPreIndex,CardOpIndex,CardPreOpIndex int;
    declare CardWorkshopId,WorkshopId,LogId bigint;
    declare CardWorkshopName varchar(50);

    select c.workshop_id,c.workshop_name,c.card_status,w.operation_index,w.prev_operation_index
         into CardWorkshopId,CardWorkshopName,CardStatus,CardOpIndex,CardPreOpIndex
      from rfid_card c join work_organization_unit w on c.workshop_id = w.record_id
    where c.record_id = CardId;

    select record_id,workshop_type,operation_index,prev_operation_index
           into WorkshopId, WorkshopType,WorkshopOpIndex,WorkshopPreIndex
      from work_organization_unit 
    where record_id = (
        select parent_Id from work_organization_unit where record_id = WorkstationId
    ); 

    /*
      工程内看板可以进行的操作
           1.报工   CardStatus in(1,2) and  CardWorkshopId = LoginedWorkshopId   
                =>  1.card_status = 10 ,
                    2.如果是外发前工程，则还需要更新所绑定外发看板的状态  outsource_card.status = 10                    

           2.移库   CardStatus = 10    and  CardOpIndex =  WorkshopPrevOpIndex   
                =>  1.card_status = 20
                    2.如果是外发前工程

           3.退回   CardStatus = 20    and  CardWorkshopId = LoginedWorkshopId   =>  card_status = 2

        外发看板可以进行的操作
            1. 绑定工位    CardStatus = 1   and   CardPreOpIndex =  WorkshopOpIndex   (卡的前工序 = 车间的工序)  
                => card_status = 3
            2. 外发移库    CardStatus = 10  and   WorkstationIndex = BindWorkstationIndex (外发工位 = 绑定工位) 
                =>  card_status = 20
            3. 回厂报工    CardStatus = 20  and   CardOpIndex = WorkshopPreOpIndex 
                => 1. 报工  card_status = 30
                   2. 移库
    */

    if ((CardType = 2) and (CardStatus in (1,2)) and (CardOpIndex = WorkshopOpIndex)) then  -- 工程内报工       
        if(CardWorkshopId <> WorkshopId) then
            set RespData=	'2|1|3';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|看板可以报工的车间:|0');            
            set RespData = CONCAT(RespData,'|2|',CardWorkshopName,':|0');            

            leave top;           
        end if;
        call MES_Debug('MES_ReportWip:工程内报工',LogId);	
        call MES_ReportWip(WorkstationId,WorkshopType,CardId,CardType,CardStatus,ReqTime,RespData); 
    elseif(CardType = 2) and (CardStatus in (2,10)) and (CardOpIndex = WorkshopPreIndex) then  -- 工程内移库
        if WorkshopPreIndex <> CardOpIndex then
            set RespData=	'2|1|3';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|只有上下工序之间|0');            
            set RespData = CONCAT(RespData,'|2|才可以进行移库|0');            

            leave top;                              
        end if;
        call MES_Debug('MES_MoveWip:工程内移库',LogId);	
        call MES_MoveWip(WorkstationId,WorkshopType,CardId,CardType,CardStatus,ReqTime,RespData);
   -- elseif(CardType = 2) and (CardStatus = 20) then   退后: 本存储过程不处理后工序退回
   --     call return_back
    elseif(CardType = 3) and (CardStatus = 1) then  -- 外发绑卡
        if(WorkshopType <> 3) then
            set RespData=	'2|1|3';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|只有外发前工程车间|0');            
            set RespData = CONCAT(RespData,'|2|才可以绑定外发看板|0');            

            leave top;    
        end if;

        if(WorkshopOpIndex <> CardPreOpIndex) then        
            set RespData=	'2|1|3';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|该外发看板不能|0');            
            set RespData = CONCAT(RespData,'|2|在本车间绑卡|0');            

            leave top;              
        end if;

        call MES_Debug('MES_BindOutsourceCard:外发绑卡',LogId);	
        call MES_BindOutsourceCard(WorkstationId,CardId,RfidNo,RespData);
    elseif(CardType = 3) and (CardStatus = 10) then  -- 外发移库
        if(WorkshopType <> 3) then
            set RespData=	'2|1|3';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|只有外发前工程车间|0');            
            set RespData = CONCAT(RespData,'|2|才可以外发|0');            

            leave top;           
        end if;

        if not exists(
            select * from outsource_workstation_bind where workstation_id = WorkstationId and outsource_card_id = CardId and bind_status = 10
        ) then 
            set RespData=	'2|1|3';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|必须在所绑定工位|0');            
            set RespData = CONCAT(RespData,'|2|才可以打卡外发|0');            

            leave top;                   
        end if;        

        call MES_Debug('MES_MoveWip:外发移库',LogId);	
        call MES_MoveWip(WorkstationId,WorkshopType,CardId,CardType,CardStatus,ReqTime,RespData);
    elseif(CardType = 3) and (CardStatus = 20) then  -- 外发回厂报工
        if WorkshopType <> 5 then 
            set RespData=	'2|1|2';
            set RespData = CONCAT(RespData, '|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|150'); 
            set RespData = CONCAT(RespData,'|1|非后工程车间|0');            
            leave top;        
        end if;

        call MES_Debug('MES_ReportWip:外发回厂报工',LogId);	
        call MES_ReportWip(WorkstationId,WorkshopType,CardId,CardType,CardStatus,ReqTime,RespData); 
    end if;
end;
