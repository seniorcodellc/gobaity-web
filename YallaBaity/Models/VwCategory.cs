using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwCategory
    {
        public long? Serial { get; set; }
        public int CategoryId { get; set; }
        public string CategoryAname { get; set; }
        public string CategoryEname { get; set; }
        public string CategoryAdescription { get; set; }
        public string CategoryEdescription { get; set; }
        public string ImagePath { get; set; }
        public int? BackgroundColor { get; set; }
        public bool IsActive { get; set; }
        public bool IsDelete { get; set; }
    }
}
