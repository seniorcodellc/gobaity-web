using System;

namespace YallaBaity.Areas.Api.Dto
{
    public class DtoFoodOrder
    {
        public bool IsSchedule { get; set; }
        public string HandDate { get; set; }
        public int UsersAddressId { get; set; }
        public int PaymentMethodsId { get; set; }
    }
}
