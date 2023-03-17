using System.Collections.Generic;

namespace YallaBaity.Areas.Api.Dto
{
    public class DtoBasket
    {
        public int FoodId { get; set; }  
        public List<DtoBasketSizes> BasketSizes { get; set; }
    }
}
