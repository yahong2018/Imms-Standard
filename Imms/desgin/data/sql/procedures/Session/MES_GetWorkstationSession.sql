create procedure MES_GetWorkstationSession(
    in     WorkstationId        bigint,
    out    SessionId            int,
    out    PrevStep             int,
    out    SessionType          int
)
begin
    select -1,-1,-1 into SessionId,PrevStep,SessionType;
    select record_id,current_step,session_type into SessionId,PrevStep,SessionType
        from workstation_session s
        where s.workstation_id = WorkstationId
        and s.current_step <= 250;
end;