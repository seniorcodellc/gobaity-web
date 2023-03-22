using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class Ad
    {
        public int AdsId { get; set; }
        public string AdsImage { get; set; }
        public bool IsActive { get; set; }
        public string AdsName { get; set; }
        public decimal? Price { get; set; }
        public string Description { get; set; }
        public DateTime? CreationDate { get; set; }
        public bool? IsDelete { get; set; }
        public bool? IsApproved { get; set; }
    }
}
