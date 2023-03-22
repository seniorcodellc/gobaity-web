using System;

namespace YallaBaity.Areas.Api.Dto
{
    public class DtoFoodOrder
    {
        public bool IsSchedule { get; set; }
        public int UsersAddressId { get; set; }
        public int PaymentMethodsId { get; set; }
        public string DeliveryTime { get; set; }
        public int Provider_Id { get; set;}

    }
}
