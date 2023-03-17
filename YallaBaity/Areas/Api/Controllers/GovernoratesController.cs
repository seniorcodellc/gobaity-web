using AutoMapper; 
using Microsoft.AspNetCore.Mvc; 
using System.Collections.Generic;
using System.Globalization;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Repository; 
using YallaBaity.Models; 

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GovernoratesController : Controller
    {
        IBaseRepository<Governorate> _governorate;
        IMapper _mapper;
        public GovernoratesController(IBaseRepository<Governorate> governorate, IMapper mapper)
        {
            _governorate = governorate;
            _mapper = mapper;
        }

        [HttpGet]
        public IActionResult GET()
        {
            var governorates = _governorate.GetAll();
            string lang = CultureInfo.CurrentCulture.Name;

            return Ok(new DtoResponseModel() { State = true, Message = "", Data = _mapper.Map<List<DtoGovernorates>>(governorates, opt => { opt.Items["culture"] = lang; }) });
        }
    }
}
