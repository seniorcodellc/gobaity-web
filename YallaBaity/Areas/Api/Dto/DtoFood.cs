using Microsoft.AspNetCore.Http;

namespace YallaBaity.Areas.Api.Dto
{
    public class DtoFood
    { 
        public string FoodName { get; set; }
        public decimal Price { get; set; }
        public string Description { get; set; }
        public int UserId { get; set; }
        public int PreparationTime { get; set; } 
        //Get As Json 
        public string Categories { get; set; }
        //Get As Json 
        public string Sizes { get; set; }
        public IFormFileCollection images { get; set; }
    }
}
