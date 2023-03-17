using Microsoft.AspNetCore.Mvc;

namespace YallaBaity.Areas.DashBoard.Controllers
{
    [Area("DashBoard")]
    public class AccountController : Controller
    {
        public IActionResult Login()
        {
            return View();
        }

        public IActionResult EditPassword()
        {
            return View();
        }

        public IActionResult AccessDenied()
        {
            return View();
        }
    }
}
