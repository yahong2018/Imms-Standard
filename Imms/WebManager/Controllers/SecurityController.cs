using Imms.Security.Data;
using Imms.Security.Data.Domain;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Imms.WebManager
{
    [Route("security/systemUser")]
    public class SystemUserController : SimpleCRUDController<SystemUser>
    {
        public SystemUserController()
        {
            base.Logic = new SecurityLogic();
        }
    }
}