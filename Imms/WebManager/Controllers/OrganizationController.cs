using Imms.Data;
using Imms.Data.Domain;
using Imms.Mes.Data;
using Imms.Mes.Data.Domain;
using Imms.WebManager.Models;
using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager.Controllers
{
    [Route("imms/org/workshop")]
    public class WorkshopController : SimpleCRUDController<Workshop>
    {
        public WorkshopController()
        {
            this.Logic = new SimpleCRUDLogic<Workshop>();
        }

        protected override void Verify(Workshop item, int operation)
        {
            if (item.NextWorkShopId == item.RecordId)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_PARAMETER_INVALID, "下一车间不可以与本车间等同！");
            }
        }
    }

    [Route("imms/org/workstation")]
    public class WorkstationController : SimpleCRUDController<Workstation>
    {
        public WorkstationController()
        {
            this.Logic = new WorkstationLogic();            
        }
    }
}