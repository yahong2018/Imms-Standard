
using System.Collections.Generic;
using System.Linq;
using Imms.Data;
using Imms.Mes.Data.Domain;
using Microsoft.EntityFrameworkCore;

namespace Imms.WebManager.Models{
    public class WorkstationLogic:SimpleCRUDLogic<Workstation>{
        protected override List<Workstation> DoGetData(string sql, DbContext dbContext){
            return dbContext.Set<Workstation>().FromSql(sql).Include(x=>x.Parent).ToList();
        }
    }
}