
using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager.Controllers
{
    [Route("imms/opertor")]
    public class OperatorController : SimpleCRUDController<Operator>
    {
        protected override void Verify(Operator item, int operation)
        {
            Workstation workstation = Imms.Data.CommonRepository.GetOneByFilter<Workstation>(x => x.RecordId == item.OrganizationId);
            if (workstation == null)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "操作员所属工位错误!");
            }

            if (string.IsNullOrEmpty(item.EmployeeId) || string.IsNullOrEmpty(item.EmployeeName) || string.IsNullOrEmpty(item.EmployeeCardNo))
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "工号、姓名、工卡号都必须输入!");
            }
        }
    }
}