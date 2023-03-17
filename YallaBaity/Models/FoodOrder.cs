using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class FoodOrder
    {
        public FoodOrder()
        {
            OrderDetails = new HashSet<OrderDetail>();
            WalletHistories = new HashSet<WalletHistory>();
        }

        public int OrderId { get; set; }
        public string OrderCode { get; set; }
        public DateTime OrderDate { get; set; }
        public int? DriverId { get; set; }
        public int UserId { get; set; }
        public bool? IsSchedule { get; set; }
        public DateTime? HandDate { get; set; }
        public decimal DeliveryCost { get; set; }
        public decimal Total { get; set; }
        public decimal NetTotal { get; set; }
        public int? OrderStatusId { get; set; }
        public int UsersAddressId { get; set; }
        public int? PaymentMethodsId { get; set; }
        public bool? IsDeleted { get; set; }

        public virtual Driver Driver { get; set; }
        public virtual OrderStatus OrderStatus { get; set; }
        public virtual PaymentMethod PaymentMethods { get; set; }
        public virtual User User { get; set; }
        public virtual UsersAddress UsersAddress { get; set; }
        public virtual ICollection<OrderDetail> OrderDetails { get; set; }
        public virtual ICollection<WalletHistory> WalletHistories { get; set; }
    }
}
