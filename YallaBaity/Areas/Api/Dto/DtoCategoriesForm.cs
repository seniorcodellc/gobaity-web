using Microsoft.AspNetCore.Http;

namespace YallaBaity.Areas.Api.Dto
{
    public class DtoCategoriesForm
    { 
        public string CategoryAname { get; set; }
        public string CategoryEname { get; set; }
        public string CategoryAdescription { get; set; }
        public string CategoryEdescription { get; set; }
        public IFormFile Image { get; set; }
        public int BackgroundColor { get; set; }
        public bool IsActive { get; set; }
    }
}
