using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwFoodsSize
    {
        public int FoodsSizesId { get; set; }
        public decimal Price { get; set; }
        public string SizeDescription { get; set; }
        public int FoodId { get; set; }
        public int SizeId { get; set; }
        public string SizeAname { get; set; }
        public string SizeEname { get; set; }
    }
}
