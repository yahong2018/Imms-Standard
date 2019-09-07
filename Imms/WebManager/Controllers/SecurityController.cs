using Imms.Security.Data.Domain;
using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager{

    [Route("security/systemUser")]
    public class SystemUserController:SimpleCRUDController<SystemUser>
    {        
    }
}