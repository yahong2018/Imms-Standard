using Imms.Data;
using Imms.Security.Data;
using Imms.Security.Data.Domain;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;

namespace Imms.WebManager
{
    [Route("security/systemUser")]
    public class SystemUserController : SimpleCRUDController<SystemUser>
    {
        public SystemUserController()
        {
            this.Logic = new SecurityLogic();
        }

        [Route("userRoles"), HttpGet]
        public List<SystemRole> getUserRoles(long userId)
        {
            List<SystemRole> result = null;
            CommonRepository.UseDbContext(dbContext =>
            {
                result = (from r in dbContext.Set<SystemRole>()
                          from ru in dbContext.Set<RoleUser>()
                          where ru.UserId == userId
                            && ru.RoleId == r.RecordId
                          select r).ToList();
            });

            return result;
        }

        [Route("resetPassword"), HttpGet]
        public int resetPassword(long userId)
        {
            return (Logic as SecurityLogic).resetPassword(userId);
        }

        [Route("enable"), HttpGet]
        public int enable(long userId)
        {
            return (Logic as SecurityLogic).changeUserStatus(userId, SystemUser.USER_STATUS_ENABLED);
        }

        [Route("disable"), HttpGet]
        public int disable(long userId)
        {
            return (Logic as SecurityLogic).changeUserStatus(userId, SystemUser.USER_STATUS_DISABLED);
        }
    }

    [Route("security/systemRole")]
    public class SystemRoleController : SimpleCRUDController<SystemRole>
    {
        public SystemRoleController()
        {
            this.Logic = new SimpleCRUDLogic<SystemRole>();
        }
    }
}