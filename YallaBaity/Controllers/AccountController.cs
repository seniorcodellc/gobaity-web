using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace YallaBaity.Controllers
{
    public class AccountController : Controller
    {
        [AllowAnonymous]
        [Authorize(AuthenticationSchemes = "SideAuth")]
        public IActionResult Index()
        {
            return View();
        }

        [Authorize(AuthenticationSchemes = "SideAuth")]
        public IActionResult Profile()
        {
            return View();
        }

        [Authorize(AuthenticationSchemes = "SideAuth")]
        public IActionResult JoinAsProvider()
        {
            return View();
        }

        public IActionResult Logout()
        {
            Security.SecurityManager securityManager=new Security.SecurityManager();
            securityManager.SignOut(this.HttpContext, "SideAuth");

            Response.Cookies.Delete("userId");

            return Redirect(Request.Headers.SingleOrDefault(s => s.Key == "Referer").Value);
        }
    }
}
