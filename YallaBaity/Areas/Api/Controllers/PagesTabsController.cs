using Microsoft.AspNetCore.Authorization; 
using Microsoft.AspNetCore.Mvc; 
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Repository; 
using YallaBaity.Models;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/[controller]")]
   // [Authorize(Roles = "group_permissions")]
    [ApiController]
    public class PagesTabsController : ControllerBase
    {
        IBaseRepository<PagesTab> _pagesTap; 
        public PagesTabsController(IBaseRepository<PagesTab> pagesTap)
        {
            _pagesTap = pagesTap;
        }

        [HttpGet]
        public IActionResult GET()
        {
            var pagesTabs = _pagesTap.GetAll();
            return Ok(new DtoResponseModel(){ State = true, Message = "", Data = pagesTabs });
        }
    }
}
