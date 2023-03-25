using System;
using System.Collections.Generic;

namespace YallaBaity.Areas.Api.ViewModel
{
    public class VmFoodOrder
    {
        public int ID { get; set; }
        public int ClientId { get; set; }
        public string ClientName { get; set; }
        public string ClientAddress { get; set; }
        public string ClientAddressLink { get; set; }
        public decimal NetTotal { get; set; }
        public decimal DeliveryCost { get; set; }
        public decimal Total { get; set; }
        public int? StatusId { get; set; }
        public string StatusName { get; set; }
        public DateTime OrderDate { get; set; }
        public List<VmOrderDetails> OrderDetails { get; set; }

    }

    public class VmFoodOrderWithDetails
    {
        public int OrderId { get; set; }
        public string OrderDateTime { get; set; }
        public int FoodsSizesId { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public int FoodId { get; set; }
        public string FoodName { get; set; }
        public string CookName { get; set; }
        public int CookId { get; set; }
        public int? PreparationTime { get; set; }
        public decimal Rate { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public string ImagePath { get; set; }
        public string SizeName { get; set; }
        public string Date { get; set; }
    }
}
