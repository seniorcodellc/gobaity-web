using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.Entity;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using YallaBaity.Areas.Api.Repository; 
using YallaBaity.Models;
using YallaBaity.SignalrHubs;

namespace YallaBaity.Controllers
{
    public class HomeController : Controller
    {
        private readonly IHubContext<ProviderHubs> _hub;
        private readonly ILogger<HomeController> _logger;
        IUnitOfWork _unitOfWork;
        public HomeController(ILogger<HomeController> logger, IUnitOfWork unitOfWork, IHubContext<ProviderHubs> hub)
        {
            this._unitOfWork = unitOfWork;
            _logger = logger;
            _hub = hub;
        }

        public IActionResult auth()
        {
            Security.SecurityManager securityManager = new Security.SecurityManager();
            securityManager.SideSignin(this.HttpContext, new Models.User() { UserId = 1, UserName = "Omar" });
            return View("Index");
        }

        [AllowAnonymous]
        [Authorize(AuthenticationSchemes = "SideAuth")]
        public IActionResult Index()
        { 
            return View();
        }

        public async Task<int> IncreaseSignalR(int Count)
        {
            await _hub.Clients.All.SendAsync("orderCountValue", Count);
            return Count;
        }

        public IActionResult SignalR_Test()
        {
            return View();
        }

        public IActionResult SwitchLanguage()
        {
            Response.Cookies.Append(
            CookieRequestCultureProvider.DefaultCookieName,
            CookieRequestCultureProvider.MakeCookieValue(new RequestCulture(CultureInfo.CurrentUICulture.Name == "ar" ? "en" : "ar")),
            new CookieOptions { Expires = DateTimeOffset.UtcNow.AddYears(1) }
        );

            return Redirect(Request.Headers.SingleOrDefault(s => s.Key == "Referer").Value);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
