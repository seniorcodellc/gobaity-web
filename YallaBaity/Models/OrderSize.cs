using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class OrderSize
    {
        public int OrderSizesId { get; set; }
        public int FoodsSizesId { get; set; }
        public int Quantity { get; set; }
        public int OrderDetailsId { get; set; }

        public virtual FoodsSize FoodsSizes { get; set; }
        public virtual OrderDetail OrderDetails { get; set; }
    }
}
