using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class BasketSize
    {
        public int BasketSizesId { get; set; }
        public int FoodsSizesId { get; set; }
        public int Quantity { get; set; }
        public int BasketId { get; set; }

        public virtual Basket Basket { get; set; }
        public virtual FoodsSize FoodsSizes { get; set; }
    }
}
