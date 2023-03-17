using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class GroupPermission
    {
        public int GroupPermissionId { get; set; }
        public int GroupId { get; set; }
        public int PageId { get; set; }

        public virtual Group Group { get; set; }
        public virtual Page Page { get; set; }
    }
}
