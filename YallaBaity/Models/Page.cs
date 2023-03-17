using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class Page
    {
        public Page()
        {
            GroupPermissions = new HashSet<GroupPermission>();
        }

        public int PageId { get; set; }
        public string PageAname { get; set; }
        public string PageEname { get; set; }
        public string PageKey { get; set; }
        public int PagesTabId { get; set; }

        public virtual PagesTab PagesTab { get; set; }
        public virtual ICollection<GroupPermission> GroupPermissions { get; set; }
    }
}
