using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class OrderDetail
    {
        public OrderDetail()
        {
            OrderSizes = new HashSet<OrderSize>();
        }

        public int OrderDetailsId { get; set; }
        public int OrderId { get; set; }
        public int FoodId { get; set; }

        public virtual Food Food { get; set; }
        public virtual FoodOrder Order { get; set; }
        public virtual ICollection<OrderSize> OrderSizes { get; set; }
    }
}
