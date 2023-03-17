using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace YallaBaity.Areas.DashBoard.Controllers
{
    [Area("DashBoard")]
    public class UsersController : Controller
    {
        public IActionResult Users()
        {
            return View();
        }

        public IActionResult Providers()
        {
            return View();
        }

        public IActionResult ProviderPending()
        {
            return View();
        }
    }
}
