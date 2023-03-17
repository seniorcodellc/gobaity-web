using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class PagesTab
    {
        public PagesTab()
        {
            Pages = new HashSet<Page>();
        }

        public int PagesTabId { get; set; }
        public string PagesTabAname { get; set; }
        public string PagesTabEname { get; set; }

        public virtual ICollection<Page> Pages { get; set; }
    }
}
