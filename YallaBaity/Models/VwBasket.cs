using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwBasket
    {
        public int BasketId { get; set; }
        public int FoodsSizesId { get; set; }
        public int UserId { get; set; }
        public int FoodId { get; set; }
        public string FoodName { get; set; }
        public string CookName { get; set; }
        public int? PreparationTime { get; set; }
        public decimal Rate { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public string ImagePath { get; set; }
        public string SizeEname { get; set; }
        public string SizeAname { get; set; }
    }
}
