using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Imms.Data;
using System.Data.Common;

namespace Imms.Mes.Services
{
    public class Command2TerminatorService : BaseService
    {
        protected override void DoInternalThreadProc()
        {
            lock (this)
            {
                while (commandList.Count > 0)
                {
                    TerminatorCommand termiComand = commandList[0];
                                        
                    var gidParam = dbCommand.CreateParameter();
                    gidParam.Value = termiComand.GID;
                    gidParam.ParameterName="GID";

                    var didParam = dbCommand.CreateParameter();
                    didParam.Value = termiComand.DID;
                    didParam.ParameterName = "DID";

                    var cmdContentParam = dbCommand.CreateParameter();
                    cmdContentParam.Value = termiComand.CmdContent;
                    cmdContentParam.ParameterName = "Command";
                    
                    this.dbContext.Database.ExecuteSqlCommand("call MES_Command2Terminator(GID,DID,Command)", gidParam, didParam, cmdContentParam);                    

                    commandList.RemoveAt(0);
                }
            }
        }

        public void RegisterCommand(TerminatorCommand command)
        {
            lock (this)
            {
                commandList.Add(command);
            }
        }

        protected override bool DoInternalStartup()
        {
            lock (this)
            {
                this.dbContext = GlobalConstants.DbContextFactory.GetContext();
                this.dbCommand = this.dbContext.Database.GetDbConnection().CreateCommand();

                this.ThreadIntervals = 1000; //1秒钟发送一次
            }

            return true;
        }

        protected override bool DoInternalShutdown()
        {
            lock (this)
            {
                this.dbContext.Dispose();
                this.dbContext = null;

                this.dbCommand.Dispose();
                this.dbCommand = null;
            }
            return true;
        }

        private DbContext dbContext;
        private DbCommand dbCommand;
        private List<TerminatorCommand> commandList = new List<TerminatorCommand>();
    }

    public class TerminatorCommand
    {
        public int GID { get; set; }
        public int DID { get; set; }
        public string CmdContent { get; set; }
    }
}