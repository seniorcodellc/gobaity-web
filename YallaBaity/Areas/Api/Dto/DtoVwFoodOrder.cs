using System;

namespace YallaBaity.Areas.Api.Dto
{
    public class DtoVwFoodOrder 
    {
        public int OrderId { get; set; }
        public string OrderCode { get; set; }
        public string OrderDate { get; set; }
        public string ShortDate { get; set; }
        public int? DriverId { get; set; }
        public int UserId { get; set; }
        public string HandDate { get; set; }
        public decimal DeliveryCost { get; set; }
        public decimal Total { get; set; }
        public decimal NetTotal { get; set; }
        public int UsersAddressId { get; set; }
        public string UsersAddressName { get; set; }
        public int BuildingNo { get; set; }
        public int ApartmentNo { get; set; }
        public string Street { get; set; }
        public int Floor { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string Address { get; set; }
        public int? OrderStatusId { get; set; }
        public string OrderStatusName { get; set; } 
        public string PaymentMethodsName { get; set; } 
    }
}
