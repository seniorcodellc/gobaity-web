using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class Category
    {
        public Category()
        {
            FoodCategories = new HashSet<FoodCategory>();
        }

        public int CategoryId { get; set; }
        public string CategoryAname { get; set; }
        public string CategoryEname { get; set; }
        public string CategoryAdescription { get; set; }
        public string CategoryEdescription { get; set; }
        public string ImagePath { get; set; }
        public int? BackgroundColor { get; set; }
        public bool IsActive { get; set; }
        public bool IsDelete { get; set; }

        public virtual ICollection<FoodCategory> FoodCategories { get; set; }
    }
}
