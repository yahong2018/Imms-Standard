using Imms.Data;
using Imms.Data.Domain;
using Imms.Mes.Data;
using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager.Controllers
{
    public class OrganizationController<T> : SimpleCRUDController<T> where T : WorkOrganizationUnit
    {
        public OrganizationController() => this.Logic = new SimpleCRUDLogic<T>();
    }

    [Route("imms/org/workshop")]
    public class WorkshopController : OrganizationController<Workshop>
    {
        public WorkshopController()
        {
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
    public class WorkstationController : OrganizationController<Workstation>
    {
        public WorkstationController()
        {
        }
    }
}