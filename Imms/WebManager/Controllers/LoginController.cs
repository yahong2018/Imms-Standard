using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authentication;
using Imms.Security.Data;
using Imms.Security.Data.Domain;

namespace Imms.WebManager.Controllers
{
    [TypeFilter(typeof(Microsoft.AspNetCore.Mvc.Authorization.AllowAnonymousFilter))]
    public class LoginController : Controller
    {
        private const string ID_ERROR_MESSAGE = "ErrorMessage";

        public ActionResult Index()
        {
            ViewBag.ErrorMessage = this.TempData[ID_ERROR_MESSAGE];
            return View();
        }

        [HttpPost]
        public ActionResult Login(string userCode, string password)
        {
            if (string.IsNullOrEmpty(userCode) || string.IsNullOrEmpty(password))
            {
                this.TempData[LoginController.ID_ERROR_MESSAGE] = "账号和密码都必须输入！";
                return RedirectToAction("Index");
            }
            try
            {
               // SystemUser systemUser = SystemUserLogic.VerifyLogin(userCode, password);
               // SystemUserLogic.Login(systemUser,HttpContext);

                SystemUserLogic.Login(userCode,password,this.HttpContext);
                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                this.TempData[ID_ERROR_MESSAGE] = ex.Message;
                return RedirectToAction("Index");
            }
        }

        public async Task<ActionResult> Logout()
        {
            await HttpContext.SignOutAsync();
            return RedirectToAction("Index", "Home");
        }
    }
}