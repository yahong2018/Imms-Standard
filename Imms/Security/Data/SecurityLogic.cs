using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using Imms.Data;
using Imms.Security.Data.Domain;
using Microsoft.EntityFrameworkCore;

namespace Imms.Security.Data
{
    public class SecurityLogic
    {
        public List<SystemProgram> getUserMenu(long userId)
        {
            using (Imms.Data.ImmsDbContext dbContext = new Imms.Data.ImmsDbContext())
            {
                return (from item in dbContext.Set<SystemProgram>().Include(x => x.Children) select item).ToList();
            }
        }

        public static SystemUser VerifyLogin(string userCode, string password)
        {
            SystemUser result = null;
            CommonRepository.UseDbContext(dbContext =>
            {
                result = dbContext.Set<SystemUser>()
                       .Where(x => x.UserCode == userCode)
                       .Include(x=>x.Roles)
                            .ThenInclude(x=>x.Role)
                        .FirstOrDefault();

                if (result == null || string.Compare(result.Pwd,GetMD5Hash(password),true)!=0)
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
                    sb.Append(data[i].ToString("X2"));
                }
            }
            return sb.ToString();
        }
    }
}