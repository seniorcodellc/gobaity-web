using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwGroup
    {
        public long? Serial { get; set; }
        public int GroupId { get; set; }
        public string GroupAname { get; set; }
        public string GroupEname { get; set; }
        public bool IsActive { get; set; }
    }
}
