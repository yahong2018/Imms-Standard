using Imms.Data;
using Imms.Data.Domain;
using Imms.Mes.Data;
using Imms.Mes.Data.Domain;
using Imms.WebManager.Models;
using Microsoft.AspNetCore.Http;
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
            if (item.NextWorkShopId == item.RecordId && item.NextWorkShopId != 0)
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
            this.Logic = new SimpleCRUDLogic<Workstation>();
        }

        [Route("getStationByWorkshop")]
        public ExtJsResult GetStationByWorkshop(long workshopId)
        {
            IQueryCollection query = this.HttpContext.Request.Query;

            int page = int.Parse(query["page"][0]);
            int start = int.Parse(query["start"][0]);
            int limit = int.Parse(query["limit"][0]);
            string filterStr = "parent_organization_id = " + workshopId;
            ExtJsResult result = Logic.GetAllByPage(page, start, limit, filterStr);
            return result;
        }
    }
}