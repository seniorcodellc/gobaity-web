using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class Basket
    {
        public Basket()
        {
            BasketSizes = new HashSet<BasketSize>();
        }

        public int BasketId { get; set; }
        public int FoodId { get; set; }
        public int UserId { get; set; }

        public virtual Food Food { get; set; }
        public virtual User User { get; set; }
        public virtual ICollection<BasketSize> BasketSizes { get; set; }
    }
}
