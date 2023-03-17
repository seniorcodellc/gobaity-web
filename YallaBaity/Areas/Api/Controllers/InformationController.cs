using Microsoft.AspNetCore.Mvc;
using System.Linq;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Models;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class Information : ControllerBase
    {
        IUnitOfWork _unitOfWork;
        public Information(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        [HttpGet]
        public IActionResult GET()
        {
            var Informations = _unitOfWork.Informations.GetAll().FirstOrDefault();
            return Ok(new DtoResponseModel() { State = true, Message = "", Data = Informations });
        }
    }
}
