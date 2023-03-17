using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwPagesGroupPermission
    {
        public long? Serial { get; set; }
        public int GroupPermissionId { get; set; }
        public int GroupId { get; set; }
        public int PageId { get; set; }
        public string PageKey { get; set; }
    }
}
