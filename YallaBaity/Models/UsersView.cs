using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class UsersView
    {
        public int UsersViewsId { get; set; }
        public int UserId { get; set; }
        public int FoodId { get; set; }

        public virtual Food Food { get; set; }
        public virtual User User { get; set; }
    }
}
