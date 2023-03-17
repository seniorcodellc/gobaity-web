using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwProvider
    {
        public int CookId { get; set; }
        public string CookName { get; set; }
        public bool Gender { get; set; }
        public int? RateCount { get; set; }
        public int? Rate { get; set; }
    }
}
