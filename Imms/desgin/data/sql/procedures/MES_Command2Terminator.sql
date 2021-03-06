drop procedure if exists MES_Command2Terminator;

create procedure MES_Command2Terminator(
    GID             int,
    DID             int,
    Command         varchar(200)
)
begin
    declare DeviceCmdID int;    
    
    call GetNewDeviceCmdID(DeviceCmdID);

    insert into DeviceCmdList(DeviceCmdID,CmdType,GID,DID,CmdNumber,CmdContent,CmdMakeTime,RetryTimes)
                       values(DeviceCmdID,0,GID,DID,28,Command,Now(),3);
end;