using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwOrderDetail
    {
        public int OrderDetailsId { get; set; }
        public int OrderId { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public int? FoodId { get; set; }
        public string FoodName { get; set; }
        public string CookName { get; set; }
        public int? CookId { get; set; }
        public string ImagePath { get; set; }
        public string ShortDate { get; set; }
        public DateTime OrderDate { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public decimal NetTotal { get; set; }
        public decimal Total { get; set; }
        public decimal DeliveryCost { get; set; }
        public int? ProviderId { get; set; }
        public string OrderCode { get; set; }
        public string OrderStatusAname { get; set; }
        public string OrderStatusEname { get; set; }
        public string PaymentMethodsAname { get; set; }
        public string PaymentMethodsEname { get; set; }
        public bool? IsSchedule { get; set; }
        public string SizeEname { get; set; }
        public string SizeAname { get; set; }
        public DateTime? DeliveryTime { get; set; }
    }
}
