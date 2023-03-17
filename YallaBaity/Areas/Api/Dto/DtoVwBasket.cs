namespace YallaBaity.Areas.Api.Dto
{
    public class DtoVwBasket
    {
        public int BasketId { get; set; }
        public int FoodsSizesId { get; set; }
        public int UserId { get; set; }
        public int FoodId { get; set; }
        public string FoodName { get; set; }
        public string CookName { get; set; }
        public int? PreparationTime { get; set; }
        public decimal Rate { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public string ImagePath { get; set; }
        public string SizeName { get; set; } 
    }
}
