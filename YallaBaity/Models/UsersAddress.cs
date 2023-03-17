using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class UsersAddress
    {
        public UsersAddress()
        {
            FoodOrders = new HashSet<FoodOrder>();
        }

        public int UsersAddressId { get; set; }
        public string UsersAddressName { get; set; }
        public int UserId { get; set; }
        public string Address { get; set; }
        public int ApartmentNo { get; set; }
        public int BuildingNo { get; set; }
        public string Street { get; set; }
        public int Floor { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }

        public virtual User User { get; set; }
        public virtual ICollection<FoodOrder> FoodOrders { get; set; }
    }
}
