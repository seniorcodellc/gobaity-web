using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class UserRating
    {
        public int UserRatingId { get; set; }
        public int FoodId { get; set; }
        public int UserId { get; set; }
        public int Rating { get; set; }
        public string Description { get; set; }
        public DateTime? RatingDate { get; set; }

        public virtual Food Food { get; set; }
        public virtual User User { get; set; }
    }
}
