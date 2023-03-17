using System;

namespace YallaBaity.Areas.Api.Dto
{
    public class DtoOrderDetail
    {
        public int OrderDetailsId { get; set; }
        public int OrderId { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public string SizeName { get; set; }
        public int? FoodId { get; set; }
        public string FoodName { get; set; }
        public string CookName { get; set; }
        public string ImagePath { get; set; }
        public string OrderDate { get; set; }
        public string ShortDate { get; set; }
        public int UserId { get; set; }
        public decimal NetTotal { get; set; }
        public decimal Total { get; set; }
        public decimal DeliveryCost { get; set; }
        public int? ProviderId { get; set; }
        public string OrderCode { get; set; }
        public string OrderStatusName { get; set; } 
        public string PaymentMethodsName { get; set; }
    }
}
