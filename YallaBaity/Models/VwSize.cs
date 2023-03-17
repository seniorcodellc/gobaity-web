using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwSize
    {
        public long? Serial { get; set; }
        public int SizeId { get; set; }
        public string SizeAname { get; set; }
        public string SizeEname { get; set; }
        public bool IsActive { get; set; }
        public bool IsDelete { get; set; }
    }
}
