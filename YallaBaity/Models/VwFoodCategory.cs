using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwFoodCategory
    {
        public int FoodCategoriesId { get; set; }
        public int FoodId { get; set; }
        public int CategoryId { get; set; }
        public int UserId { get; set; }
    }
}
