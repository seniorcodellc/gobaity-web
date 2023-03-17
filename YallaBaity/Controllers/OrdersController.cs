using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace YallaBaity.Controllers
{
    [Route("[controller]")]
    public class OrdersController : Controller
    {
        [Authorize(AuthenticationSchemes = "SideAuth")]
        [Route("{orderId}"), HttpGet]
        public IActionResult Index(int orderId)
        {
            return View(orderId);
        }

        [Authorize(AuthenticationSchemes = "SideAuth")]
        [Route("[action]"), HttpGet]
        public IActionResult Cart()
        {
            return View();
        }
     
        [Authorize(AuthenticationSchemes = "SideAuth")]
        [Route("[action]"), HttpGet]
        public IActionResult Checkout()
        {
            return View();
        }
    }
}
