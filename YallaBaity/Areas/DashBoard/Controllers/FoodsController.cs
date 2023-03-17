using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace YallaBaity.Areas.DashBoard.Controllers
{
    [Area("DashBoard")]
    public class FoodsController : Controller
    { 
        public IActionResult Sizes()
        {
            return View();
        }

        public IActionResult Categorys()
        {
            return View();
        }

        public IActionResult Foods()
        {
            return View();
        }

        public IActionResult FoodPending()
        {
            return View();
        }
        
    }
}
