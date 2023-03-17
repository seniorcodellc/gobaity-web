using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class FoodsImage
    {
        public int FoodsImagesId { get; set; }
        public string ImagePath { get; set; }
        public int FoodId { get; set; }

        public virtual Food Food { get; set; }
    }
}
