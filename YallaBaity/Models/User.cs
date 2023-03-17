using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class User
    {
        public User()
        {
            Baskets = new HashSet<Basket>();
            FoodOrders = new HashSet<FoodOrder>();
            UserRatings = new HashSet<UserRating>();
            UsersAddresses = new HashSet<UsersAddress>();
            UsersFavorites = new HashSet<UsersFavorite>();
            UsersViews = new HashSet<UsersView>();
        }

        public int UserId { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string Phone { get; set; }
        public string Image { get; set; }
        public bool Gender { get; set; }
        public bool IsProvider { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public int? GovernorateId { get; set; }
        public string Address { get; set; }
        public string NationalIdcard1 { get; set; }
        public string NationalIdcard2 { get; set; }
        public bool? IsApproved { get; set; }
        public bool IsActive { get; set; }
        public bool IsDelete { get; set; }
        public DateTime CreationDate { get; set; }
        public int? Otpcode { get; set; }
        public int? OtpnumberOfTimesSent { get; set; }
        public DateTime? OtpdateOfLastSent { get; set; }

        public virtual Governorate Governorate { get; set; }
        public virtual Wallet Wallet { get; set; }
        public virtual ICollection<Basket> Baskets { get; set; }
        public virtual ICollection<FoodOrder> FoodOrders { get; set; }
        public virtual ICollection<UserRating> UserRatings { get; set; }
        public virtual ICollection<UsersAddress> UsersAddresses { get; set; }
        public virtual ICollection<UsersFavorite> UsersFavorites { get; set; }
        public virtual ICollection<UsersView> UsersViews { get; set; }
    }
}
