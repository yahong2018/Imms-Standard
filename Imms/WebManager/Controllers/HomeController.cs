using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Imms.WebManager.Models;
using Imms.Data;
using Imms.Security.Data.Domain;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace Imms.WebManager.Controllers
{
    [Route("/")]
    [Route("/home")]
    public class HomeController : Controller
    {
        private readonly IHostingEnvironment host = null;
        public HomeController(IHostingEnvironment host)
        {
            this.host = host;
        }
        
        public IActionResult Index()
        {
            return View();
        }

        [Route("userMenu"), HttpGet]
        public List<SystemProgram> GetUserMenu()
        {
            long userId = long.Parse(this.HttpContext.User.Claims.First(x => x.Type == "UserId").Value);
            List<SystemProgram> programList = null;
            CommonRepository.UseDbContext(dbContext =>
            {
                programList =
                 (from rp in dbContext.Set<RolePrivilege>()
                  from r in dbContext.Set<RoleUser>()
                  from prg in dbContext.Set<SystemProgram>()
                  where rp.RoleId == r.RoleId
                     && prg.RecordId == rp.ProgramId
                     && string.IsNullOrEmpty(prg.ParentId)
                     && r.UserId == userId
                  select prg)
                  .Include(x => x.Children)
                  .ToList();
            });
            return programList;
        }

        [Route("currentLogin"), HttpGet]
        public ActionResult<string> GetCurrentLogin()
        {
            string userCode = this.HttpContext.User.Claims.First(x => x.Type == "UserCode").Value;
            string userName = this.HttpContext.User.Claims.First(x => x.Type == "UserName").Value;
            long userId = long.Parse(this.HttpContext.User.Claims.First(x => x.Type == "UserId").Value);
            string loginText = null;

            CommonRepository.UseDbContext(dbContext =>
            {
                var privilegeList = (
                    from rp in dbContext.Set<RolePrivilege>()
                    from ur in dbContext.Set<RoleUser>()
                    from r in dbContext.Set<SystemRole>()
                    where rp.RoleId == ur.RoleId
                       && r.RecordId == ur.RoleId
                       && ur.UserId == userId
                    select r
                ).Distinct()
                .SelectMany(x=>x.Privileges).ToList();

                string privilegeText = GlobalConstants.ToJson(privilegeList);

                loginText = "{\"company\":\"爱三(佛山)汽车配件有限公司\","
                           + "\"userName\":\"" + userName + "\","
                           + "\"userCode\":\"" + userCode + "\","
                           + "\"privielges\":" + privilegeText
                           + "}";
            });
            return loginText;
        }
    }
}
