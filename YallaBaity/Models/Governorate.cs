using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class Governorate
    {
        public Governorate()
        {
            Users = new HashSet<User>();
        }

        public int GovernorateId { get; set; }
        public string GovernorateAname { get; set; }
        public string GovernorateEname { get; set; }

        public virtual ICollection<User> Users { get; set; }
    }
}
