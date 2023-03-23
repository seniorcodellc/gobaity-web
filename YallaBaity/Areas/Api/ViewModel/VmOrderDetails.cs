using System;
using System.Collections.Generic;

namespace YallaBaity.Areas.Api.ViewModel
{
    public class VmOrderDetails
    {
        public VmOrderDetails()
        {
            OrderDetailSizes = new List<VmOrderDetailSizes>();
        }
        public int ID { get; set; }
        public int Quantity { get; set; }
        public int FoodId { get; set; }
        public string FoodName { get; set; }
        public int ProviderId { get; set; }
        public string ProviderName { get; set; }
        public string ImagePath { get; set; }
        public List<VmOrderDetailSizes> OrderDetailSizes { get; set; }
    }
}
