using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class FoodsSize
    {
        public FoodsSize()
        {
            BasketSizes = new HashSet<BasketSize>();
            OrderSizes = new HashSet<OrderSize>();
        }

        public int FoodsSizesId { get; set; }
        public decimal Price { get; set; }
        public int SizeId { get; set; }
        public string SizeDescription { get; set; }
        public int FoodId { get; set; }

        public virtual Food Food { get; set; }
        public virtual Size Size { get; set; }
        public virtual ICollection<BasketSize> BasketSizes { get; set; }
        public virtual ICollection<OrderSize> OrderSizes { get; set; }
    }
}
