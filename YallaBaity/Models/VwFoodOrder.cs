using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwFoodOrder
    {
        public int OrderId { get; set; }
        public string OrderCode { get; set; }
        public string ShortDate { get; set; }
        public DateTime OrderDate { get; set; }
        public int? DriverId { get; set; }
        public int UserId { get; set; }
        public DateTime? HandDate { get; set; }
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
        public string OrderStatusAname { get; set; }
        public string OrderStatusEname { get; set; }
        public string PaymentMethodsAname { get; set; }
        public string PaymentMethodsEname { get; set; }
        public bool? IsSchedule { get; set; }
    }
}
