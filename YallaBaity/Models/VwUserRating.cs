using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwUserRating
    {
        public int UserRatingId { get; set; }
        public int FoodId { get; set; }
        public int UserId { get; set; }
        public int Rating { get; set; }
        public string Description { get; set; }
        public string UserName { get; set; }
        public string RatingDate { get; set; }
    }
}
