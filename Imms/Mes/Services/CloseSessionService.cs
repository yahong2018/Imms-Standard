using System;
using System.Collections.Generic;
using System.Linq;
using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;

namespace Imms.Mes.Services
{
    public class CloseSessionService : BaseService
    {
        public CloseSessionService(Command2TerminatorService command2Terminator)
        {
            this._Command2Terminator = command2Terminator;
        }

        protected override void DoInternalThreadProc()
        {
            DateTime currentTime = DateTime.Now;
            this.dbContext.ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
            List<WorkstationSession> sessionList = this.dbContext.Set<WorkstationSession>().Where(x => x.CurrentStep < 255 && x.ExpireTime < currentTime).ToList();
            if (sessionList.Count > 0)
            {
                this.dbContext.ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.TrackAll;
            }

            foreach (WorkstationSession session in sessionList)
            {
                TerminatorCommand command = new TerminatorCommand();
                command.GID = session.GID;
                command.DID = session.DID;
                command.CmdContent = "9|1|1|210|128|129|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|100";
                this._Command2Terminator.RegisterCommand(command);
                session.CurrentStep = 255;
                GlobalConstants.ModifyEntityStatus<WorkstationSession>(session, this.dbContext);
            }

            if (sessionList.Count > 0)
            {
                this.dbContext.SaveChanges();
            }
        }

        protected override bool DoInternalStartup()
        {
            this.ThreadIntervals = 1000 * 10;//10秒钟检查1次

            this.dbContext = GlobalConstants.DbContextFactory.GetContext();


            return true;
        }

        private DbContext dbContext;
        private Command2TerminatorService _Command2Terminator;
    }
}