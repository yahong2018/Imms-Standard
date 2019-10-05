
using Imms.Mes.Data;
using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager.Controllers
{
    [Route("imms/operator")]
    public class OperatorController : SimpleCRUDController<Operator>
    {
        public OperatorController()=>this.Logic = new OperatorLogic();

        protected override void Verify(Operator item, int operation)
        {
            Workshop workshop = Imms.Data.CommonRepository.GetOneByFilter<Workshop>(x => x.OrganizationCode == item.WorkshopCode);
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