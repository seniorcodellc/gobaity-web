using Microsoft.AspNetCore.Http;
using System.Collections.Generic;

namespace YallaBaity.Areas.Api.Dto
{
    public class DtoProviter
    {
        public string Latitude { get; set; }
        public string Longitude { get; set; } 
        public List<IFormFile> NationalIdcard { get; set; }
        public int GovernorateId { get; set; }
        public string Address { get; set; } 
    }
}
