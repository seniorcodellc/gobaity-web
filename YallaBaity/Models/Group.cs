using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class Group
    {
        public Group()
        {
            DashBoardUsers = new HashSet<DashBoardUser>();
            GroupPermissions = new HashSet<GroupPermission>();
        }

        public int GroupId { get; set; }
        public string GroupAname { get; set; }
        public string GroupEname { get; set; }
        public bool IsActive { get; set; }

        public virtual ICollection<DashBoardUser> DashBoardUsers { get; set; }
        public virtual ICollection<GroupPermission> GroupPermissions { get; set; }
    }
}
