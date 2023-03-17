using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Data;
using System.Globalization;
using System.Text.RegularExpressions;

namespace YallaBaity.Areas.DashBoard.Controllers
{
  
    [Area("DashBoard"), Authorize(AuthenticationSchemes = "DashBoardAuth")]
    public class HomeController : Controller
    {
        public IActionResult Index()
        {

            return View();
        }

        [HttpGet]
        public IActionResult ToggleLanguage(string culture, string redirect)
        {
            Response.Cookies.Append(
              CookieRequestCultureProvider.DefaultCookieName,
              CookieRequestCultureProvider.MakeCookieValue(new RequestCulture(culture)),
              new CookieOptions { Expires = DateTimeOffset.UtcNow.AddYears(1) }
          );

            return Redirect(redirect);
        }


    }
}
