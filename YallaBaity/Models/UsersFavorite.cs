using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class UsersFavorite
    {
        public int UsersFavoriteId { get; set; }
        public int FoodId { get; set; }
        public int UserId { get; set; }

        public virtual Food Food { get; set; }
        public virtual User User { get; set; }
    }
}
