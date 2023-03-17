using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class Size
    {
        public Size()
        {
            FoodsSizes = new HashSet<FoodsSize>();
        }

        public int SizeId { get; set; }
        public string SizeAname { get; set; }
        public string SizeEname { get; set; }
        public bool IsActive { get; set; }
        public bool IsDelete { get; set; }

        public virtual ICollection<FoodsSize> FoodsSizes { get; set; }
    }
}
