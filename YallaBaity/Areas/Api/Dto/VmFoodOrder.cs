using System;
using System.Collections.Generic;

namespace YallaBaity.Models.ViewModels
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
        public string StatusName  { get; set; }
        public DateTime OrderDate { get; set; }
        public List<VmOrderDetails> OrderDetails { get; set; }

    }
}
