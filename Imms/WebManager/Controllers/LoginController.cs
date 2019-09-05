using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authentication;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.Cookies;

namespace Imms.WebManager.Controllers
{
    [TypeFilter(typeof(Microsoft.AspNetCore.Mvc.Authorization.AllowAnonymousFilter))]
    public class LoginController : Controller
    {
        private const string ID_ERROR_MESSAGE = "ErrorMessage";
       
        // GET: Login
        public ActionResult Index()
        {
            ViewBag.ErrorMessage = this.TempData[ID_ERROR_MESSAGE];            
            return View();
        }

        [HttpPost]
        public async Task<ActionResult> Login(string UserName, string Password)
        {
            //Login login = adminLogic.IsValidAccount(UserName, Password);
            //if (login != null)
            //{
            //    MvcAuthenticationFilter.CurrentUser = login;
            //    return RedirectToAction("Index", "Home");
            //}             

            if (string.IsNullOrEmpty(UserName) || string.IsNullOrEmpty(Password))
            {
                this.TempData[LoginController.ID_ERROR_MESSAGE] = "用户名或密码错误！";
                return RedirectToAction("Index");
            }

            var claims = new List<Claim>
                {
                    new Claim("UserName", UserName),
                    new Claim("Role", "Admin")
                };
            ClaimsIdentity claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            ClaimsPrincipal user = new ClaimsPrincipal(claimsIdentity);
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, user);

            return RedirectToAction("Index", "Home");
        }

        public async Task<ActionResult> Logout()
        {
            await HttpContext.SignOutAsync();
            return RedirectToAction("Index", "Home");
        }
    }
}