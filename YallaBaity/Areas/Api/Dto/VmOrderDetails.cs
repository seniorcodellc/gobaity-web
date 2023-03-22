using System;
using System.Collections.Generic;

namespace YallaBaity.Models.ViewModels
{
    public class VmOrderDetails
    {
        public VmOrderDetails() {
           OrderDetailSizes = new List<VmOrderDetailSizes>();
        }
        public int ID { get; set; }
        public int Quantity { get; set; }
        public int FoodId { get; set; }
        public string FoodName { get; set; }
        public int ProviderId { get; set; }
        public string ProviderName { get; set; }
        public List<VmOrderDetailSizes> OrderDetailSizes { get;  set; }
    }
}
