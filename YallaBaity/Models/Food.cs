using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class Food
    {
        public Food()
        {
            Baskets = new HashSet<Basket>();
            FoodCategories = new HashSet<FoodCategory>();
            FoodsImages = new HashSet<FoodsImage>();
            FoodsSizes = new HashSet<FoodsSize>();
            OrderDetails = new HashSet<OrderDetail>();
            UserRatings = new HashSet<UserRating>();
            UsersFavorites = new HashSet<UsersFavorite>();
            UsersViews = new HashSet<UsersView>();
        }

        public int FoodId { get; set; }
        public string FoodName { get; set; }
        public decimal Price { get; set; }
        public string Description { get; set; }
        public int? PreparationTime { get; set; }
        public int UserId { get; set; }
        public bool IsApproved { get; set; }
        public bool IsDelete { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreationDate { get; set; }

        public virtual ICollection<Basket> Baskets { get; set; }
        public virtual ICollection<FoodCategory> FoodCategories { get; set; }
        public virtual ICollection<FoodsImage> FoodsImages { get; set; }
        public virtual ICollection<FoodsSize> FoodsSizes { get; set; }
        public virtual ICollection<OrderDetail> OrderDetails { get; set; }
        public virtual ICollection<UserRating> UserRatings { get; set; }
        public virtual ICollection<UsersFavorite> UsersFavorites { get; set; }
        public virtual ICollection<UsersView> UsersViews { get; set; }
    }
}
