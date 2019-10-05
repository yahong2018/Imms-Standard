
using System;
using System.Linq;
using System.Collections.Generic;
using Imms.Data;
using Imms.Mes.Data.Domain;
using Microsoft.EntityFrameworkCore;
using Imms.Security.Data;
using Imms.Security.Data.Domain;

namespace Imms.Mes.Data
{
    public class OperatorLogic : SimpleCRUDLogic<Operator>
    {
        private SystemUserLogic _userLogic = new SystemUserLogic();

        protected override void BeforeInsert(Operator item, DbContext dbContext)
        { 
            // //新增操作员系统账号
            // SystemUser systemUser = new SystemUser();
            // systemUser.UserCode = item.EmployeeId;
            // systemUser.UserName = item.EmployeeName;
            // systemUser.Email = item.EmployeeId + "@zhxh.com";
            // _userLogic.Create(systemUser, dbContext);

            // //授予操作员权限
            // long roleId = dbContext.Set<SystemRole>().Where(x => x.RoleCode == Operator.ROLE_WORKSHOP_OPERATOR).Select(x => x.RecordId).Single();
            // RoleUser roleUser = new RoleUser();
            // roleUser.RoleId = roleId;
            // roleUser.UserId = systemUser.RecordId;
            // dbContext.Set<RoleUser>().Add(roleUser);
            // dbContext.SaveChanges();
        }


    }
}