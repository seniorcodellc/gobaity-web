using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class OrderStatus
    {
        public OrderStatus()
        {
            FoodOrders = new HashSet<FoodOrder>();
        }

        public int OrderStatusId { get; set; }
        public string OrderStatusAname { get; set; }
        public string OrderStatusEname { get; set; }

        public virtual ICollection<FoodOrder> FoodOrders { get; set; }
    }
}
