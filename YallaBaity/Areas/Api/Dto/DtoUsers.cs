using Microsoft.AspNetCore.Http;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using YallaBaity.Resources;

namespace YallaBaity.Areas.Api.Dto
{
    public class DtoUsers
    {
        [Required(ErrorMessageResourceType = typeof(AppResource), ErrorMessageResourceName = "lbRequirdMsg")]
        public string UserName { get; set; }
        [Required(ErrorMessageResourceType = typeof(AppResource), ErrorMessageResourceName = "lbRequirdMsg")]
        public string Password { get; set; }
        [Required(ErrorMessageResourceType = typeof(AppResource), ErrorMessageResourceName = "lbRequirdMsg")]
        [RegularExpression("^01\\d{9}$", ErrorMessageResourceType = typeof(AppResource), ErrorMessageResourceName = "lbEnterThePhoneCorrectly")]
        public string Phone { get; set; }
        public IFormFile Image { get; set; }
        public bool IsProvider { get; set; }
        public bool Gender { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public string Address { get; set; }
        public int GovernorateId { get; set; }
        public List<IFormFile> NationalIdcard { get; set; } = default;
    }
}
