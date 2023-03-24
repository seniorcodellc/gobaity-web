using System.Collections.Generic;

namespace YallaBaity.Areas.Api.Dto
{
    public class DtoFoodSearch
    {
        public int page { get; set; } = 0;
        public int size { get; set; } = 30;
        public List<int> categoryId { get; set; } = new List<int>();
        public int userId { get; set; } = -1;
        public double priceFrom { get; set; } = -1;
        public double priceTo { get; set; } = -1;
        public string foodName { get; set; } = "";
        public string order { get; set; } = "";
        public string latitude { get; set; } = "";
        public string longitude { get; set; } = "";
        public bool isApproved { get; set; } = true;
        
    }

    public class DtoFoodSearchNew
    { 
        public double priceFrom { get; set; } = -1;
        public double priceTo { get; set; } = -1;
        public string foodName { get; set; } = "";
        public string latitude { get; set; } = "";
        public string longitude { get; set; } = "";
        public int StatusId { get; set; } = -1;
        public int page { get; set; } = 0;
        public int size { get; set; } = 30;
        public List<int> categoryId { get; set; } = new List<int>();

    }
}
