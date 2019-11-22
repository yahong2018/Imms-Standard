
using System.Linq;
using Imms.Data;
using Imms.Data.Domain;
using Imms.Mes.Data.Domain;
using Microsoft.EntityFrameworkCore;

namespace Imms.Mes.Data
{
    public class WorkshopLogic : SimpleCRUDLogic<Workshop>
    {
        public DbContext DbContext { get; set; }

        public WorkshopLogic()
        {
        }

        public WorkshopLogic(DbContext dbContext)
        {
            this.DbContext = dbContext;
        }

        public bool IsFinishedProductionWorkshop(Workshop org)
        {
            Workshop next =  this.DbContext.Set<Workshop>().Where(x => x.PrevOperationIndex == org.OperationIndex).FirstOrDefault();
            return next == null;
        }
    }
}