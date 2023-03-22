using System.Collections.Generic;
using YallaBaity.Areas.Api.Dto;

namespace YallaBaity.Areas.Api.ViewModel
{
    public class VmBasket
    {
        public VmBasket()
        {
            BasketItems = new List<DtoVwBasket>(); 
        }
        public decimal Total { get; set; }
        public int Delivery { get; set; }
        public decimal Net { get; set; }
        public List<DtoVwBasket> BasketItems { get; set; }
    }
}
