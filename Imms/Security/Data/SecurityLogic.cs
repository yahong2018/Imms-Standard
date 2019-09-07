using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using Imms.Data;
using Imms.Security.Data.Domain;
using Microsoft.EntityFrameworkCore;

namespace Imms.Security.Data
{
    public class SecurityLogic : SimpleCRUDLogic<SystemUser>
    {
        public static SystemUser VerifyLogin(string userCode, string password)
        {
            SystemUser result = null;
            CommonRepository.UseDbContext(dbContext =>
            {
                result = dbContext.Set<SystemUser>()
                       .Where(x => x.UserCode == userCode)
                       .Include(x => x.Roles)
                            .ThenInclude(x => x.Role)
                        .FirstOrDefault();

                if (result == null || string.Compare(result.Pwd, GetMD5Hash(password), true) != 0)
                {
                    throw new BusinessException(GlobalConstants.EXCEPTION_CODE_DATA_NOT_FOUND, "用户名或密码错误!");
                }
            });
            return result;
        }

        public static string GetMD5Hash(string str)
        {
            StringBuilder sb = new StringBuilder();
            using (MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider())
            {
                byte[] data = md5.ComputeHash(Encoding.UTF8.GetBytes(str));
                int length = data.Length;
                for (int i = 0; i < length; i++)
                {
                    sb.Append(data[i].ToString("x2"));
                }
            }
            return sb.ToString();
        }

        protected override void beforeInsert(SystemUser item, DbContext dbContext)
        {
            item.Pwd = SecurityLogic.GetMD5Hash("888888");
        }

        protected override void beforeUpdate(SystemUser item, DbContext dbContext)
        {
            if (string.IsNullOrEmpty(item.Pwd))
            {
                SystemUser dbItem = dbContext.Set<SystemUser>().Find(item.RecordId);
                item.Pwd = dbItem.Pwd;
            }
        }
    }
}