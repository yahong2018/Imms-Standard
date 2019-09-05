using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Imms.WebManager.Models;


namespace Imms.WebManager.Controllers
{
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

        [Route("/home/userMenu"),HttpGet]        
        public ActionResult<string> GetUserMenu()
        {            
            string path = this.host.WebRootPath + @"\resources\data\Administrator.json";           
            string menuData = System.IO.File.ReadAllText(path);

            return menuData;
        }

        [Route("/home/currentLogin"), HttpGet]
        public ActionResult<string> GetCurrentLogin()
        {
            return "{\"company\":\"爱三(佛山)汽车配件有限公司\", \"userName\":\"陶红安\",\"userCode\":\"ZHXH001\"}";
        }
    }
}
