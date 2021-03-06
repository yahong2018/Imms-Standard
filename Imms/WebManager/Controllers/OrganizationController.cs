using System.Collections.Generic;
using System.Linq;
using Imms.Data;
using Imms.Data.Domain;
using Imms.Mes.Data;
using Imms.Mes.Data.Domain;
using Imms.WebManager.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager.Controllers
{
    [Route("api/imms/org/workshop")]
    public class WorkshopController : SimpleCRUDController<Workshop>
    {
        public WorkshopController()
        {
            this.Logic = new SimpleCRUDLogic<Workshop>();
        }
    }

    [Route("api/imms/org/workstation")]
    public class WorkstationController : SimpleCRUDController<Workstation>
    {
        public WorkstationController()
        {
            this.Logic = new WorkstationLogic();
        }

        [Route("getStationByWorkshop")]
        public ExtJsResult GetStationByWorkshop(long workshopId)
        {
            IQueryCollection query = this.HttpContext.Request.Query;

            int page = int.Parse(query["page"][0]);
            int start = int.Parse(query["start"][0]);
            int limit = int.Parse(query["limit"][0]);
            FilterExpression expression = new FilterExpression()
            {
                L = "parentId",
                O = "=",
                R = workshopId.ToString()
            };

            ExtJsResult result = Logic.GetAllWithExtResult(page, start, limit, new FilterExpression[] { expression });
            return result;
        }

        [Route("getWorkshopWocgList")]
        public ExtJsResult GetWorkshopWocgList(long workshopId)
        {
            WorkstationLogic workstationLogic = this.Logic as WorkstationLogic;
            List<string> wocgList = workstationLogic.GetWorkshopWocgList(workshopId);
            ExtJsResult result = new ExtJsResult();
            result.RootProperty = wocgList.Select(x => new { wocgCode = x }).ToList();
            result.total = wocgList.Count;
            return result;
        }

        [Route("getWorkshopLocList")]
        public ExtJsResult GetWorkshopLocList(long workshopId)
        {
            WorkstationLogic workstationLogic = this.Logic as WorkstationLogic;
            List<string> locList = workstationLogic.GetWorkshopLocList(workshopId);
            ExtJsResult result = new ExtJsResult();
            result.RootProperty = locList.Select(x => new { locCode = x }).ToList();
            result.total = locList.Count;
            return result;
        }
    }

    [Route("api/imms/org/operator")]
    public class OperatorController : SimpleCRUDController<Operator>
    {
        public OperatorController() => this.Logic = new OperatorLogic();

        protected override void Verify(Operator item, int operation)
        {
            Workshop workshop = Imms.Data.CommonRepository.GetOneByFilter<Workshop>(x => x.RecordId == item.orgId);
            if (workshop == null)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "所属车间错误!");
            }

            if (string.IsNullOrEmpty(item.EmployeeId) || string.IsNullOrEmpty(item.EmployeeName) || string.IsNullOrEmpty(item.EmployeeCardNo))
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "工号、姓名、工卡号都必须输入!");
            }
        }
    }
}