using Microsoft.AspNetCore.Mvc; 
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Models;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AdsController : ControllerBase
    {
        IBaseRepository<Ad> _ad;
        public AdsController(IBaseRepository<Ad> ad)
        {
            _ad = ad; 
        }
         
        [HttpGet]
        public IActionResult GET()
        { 
            var ads = _ad.GetAll();
            return Ok(new DtoResponseModel() { State = true, Message = "", Data = ads });
        }
         
    }
}
