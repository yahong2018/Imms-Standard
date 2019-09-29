using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager.Controllers
{
    [Route("/chat")]
    public class ChatController : Controller{
        public IActionResult Index()
        {
            return View();
        }
    }
}
