using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class PaymentMethod
    {
        public PaymentMethod()
        {
            FoodOrders = new HashSet<FoodOrder>();
        }

        public int PaymentMethodsId { get; set; }
        public string PaymentMethodsAname { get; set; }
        public string PaymentMethodsEname { get; set; }

        public virtual ICollection<FoodOrder> FoodOrders { get; set; }
    }
}
