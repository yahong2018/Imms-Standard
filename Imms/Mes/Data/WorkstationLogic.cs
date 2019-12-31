using System;
using System.Collections.Generic;
using System.Linq;
using Imms.Data;
using Imms.Mes.Data.Domain;

namespace Imms.Mes.Data{
    public class WorkstationLogic:SimpleCRUDLogic<Workstation>{
        public List<string> GetWorkshopWocgList(long workshopId){
            List<string> result=null;
            CommonRepository.UseDbContext(dbConext=>{
               result = dbConext.Set<Workstation>().Where(x=>x.ParentId==workshopId).Select(x=>x.WocgCode).Distinct().ToList();
            });

            return result;
        }

        public List<string> GetWorkshopLocList(long workshopId)
        {
            List<string> result=null;
            CommonRepository.UseDbContext(dbConext=>{
               result = dbConext.Set<Workstation>().Where(x=>x.ParentId==workshopId).Select(x=>x.LocCode).Distinct().ToList();
            });

            return result;
        }
    }
}