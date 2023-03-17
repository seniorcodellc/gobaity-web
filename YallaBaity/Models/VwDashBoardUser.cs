using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwDashBoardUser
    {
        public long? Serial { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public int GroupId { get; set; }
        public bool IsActive { get; set; }
        public string GroupAname { get; set; }
        public string GroupEname { get; set; }
    }
}
