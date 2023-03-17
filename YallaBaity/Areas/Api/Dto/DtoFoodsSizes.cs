namespace YallaBaity.Areas.Api.Dto
{
    public class DtoFoodsSizes
    {
        public int FoodsSizesId { get; set; }
        public decimal Price { get; set; }
        public string SizeDescription { get; set; }
        public int FoodId { get; set; }
        public int SizeId { get; set; }
        public string SizeName { get; set; } 
    }
}
