using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Text;
using Imms.Data;
using Imms.Security.Data.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication;
using System;

namespace Imms.Security.Data
{
    public class SecurityLogic : SimpleCRUDLogic<SystemUser>
    {
        public static async void Login(SystemUser systemUser, Microsoft.AspNetCore.Http.HttpContext httpContext)
        {
            var claims = new List<Claim>
                {
                    new Claim("UserId",systemUser.RecordId.ToString()),
                    new Claim("UserCode", systemUser.UserCode),
                    new Claim("UserName",systemUser.UserName)
                };
            foreach (RoleUser roleUser in systemUser.Roles)
            {
                claims.Add(new Claim("RoleCode", roleUser.Role.RoleCode));
            }
            ClaimsIdentity claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            ClaimsPrincipal user = new ClaimsPrincipal(claimsIdentity);
            await httpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, user);

            systemUser.LastLoginTime = DateTime.Now;

            new SecurityLogic().update(systemUser);
        }


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
            item.Pwd = SecurityLogic.DEAFULT_PASSWORD;
        }

        protected override void beforeUpdate(SystemUser item, DbContext dbContext)
        {
            if (string.IsNullOrEmpty(item.Pwd))
            {
                SystemUser dbItem = dbContext.Set<SystemUser>().Find(item.RecordId);
                item.Pwd = dbItem.Pwd;
            }
        }

        public int resetPassword(long userId)
        {
            SystemUser old = CommonRepository.AssureExistsByFilter<SystemUser>(x => x.RecordId == userId);
            old.Pwd = SecurityLogic.DEAFULT_PASSWORD;
            this.update(old);
            return 1;
        }

        public int changeUserStatus(long userId, byte userStatus)
        {
            SystemUser old = CommonRepository.AssureExistsByFilter<SystemUser>(x => x.RecordId == userId);
            old.UserStatus = userStatus;
            this.update(old);

            return 1;
        }

        public static readonly string DEAFULT_PASSWORD = GetMD5Hash("888888");
    }
}