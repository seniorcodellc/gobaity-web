using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace YallaBaity.Areas.DashBoard.Controllers
{
    [Area("DashBoard")]
    public class AuthorityController : Controller
    {
        [Authorize(Roles = "users",AuthenticationSchemes = "DashBoardAuth")]
        public IActionResult DashBoardUsers()
        {
            return View();
        }
        [Authorize(Roles = "groups", AuthenticationSchemes = "DashBoardAuth")]
        public IActionResult Groups()
        {
            return View();
        }
        [Authorize(Roles = "group_permissions", AuthenticationSchemes = "DashBoardAuth")]
        public IActionResult GroupPermission()
        {
            return View();
        }
    }
}
