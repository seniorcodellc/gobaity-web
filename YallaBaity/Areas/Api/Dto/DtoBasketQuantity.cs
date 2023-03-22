using YallaBaity.Areas.Api.Enums;

namespace YallaBaity.Areas.Api.Dto
{
    public class DtoBasketQuantity
    {
        public BasketsEnum basketstype { get; set; }
        public int BasketId { get; set; }
        public int FoodsSizesId { get; set; }
    }
}
