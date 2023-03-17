using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace YallaBaity.Controllers
{
    [Route("[controller]")]
    public class FoodsController : Controller
    {
        [AllowAnonymous]
        [Authorize(AuthenticationSchemes = "SideAuth")]
        [Route("{categoryId?}/{categoryName?}"), HttpGet]
        public IActionResult Index(int categoryId, string categoryName)
        {
            ViewBag.CategoryId = categoryId;
            return View();
        }

        [AllowAnonymous]
        [Authorize(AuthenticationSchemes = "SideAuth")]
        [Route("[action]/{foodId?}/{foodName?}"), HttpGet]
        public IActionResult Details(int foodId, string foodName)
        {
            return View(foodId);
        }

        [AllowAnonymous]
        [Authorize(AuthenticationSchemes = "SideAuth")]
        [Route("[action]/{proviterId}/{proviterName}"), HttpGet]
        public IActionResult ProviterFoods(int proviterId, string proviterName)
        {
            return View(proviterId);
        }
         
        [Authorize(AuthenticationSchemes = "SideAuth")]
        [Route("[action]"), HttpGet]
        public IActionResult Add()
        {
            return View("FoodsActions");
        }

        [Authorize(AuthenticationSchemes = "SideAuth")]
        [Route("[action]/{foodId}"), HttpGet]
        public IActionResult Edit(int foodId)
        {
            return View("FoodsActions", foodId);
        }
    }
}
