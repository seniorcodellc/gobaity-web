using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class FoodCategory
    {
        public int FoodCategoriesId { get; set; }
        public int FoodId { get; set; }
        public int CategoryId { get; set; }

        public virtual Category Category { get; set; }
        public virtual Food Food { get; set; }
    }
}
