using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class Wallet
    {
        public Wallet()
        {
            WalletHistories = new HashSet<WalletHistory>();
        }

        public int UserId { get; set; }
        public decimal Balance { get; set; }

        public virtual User User { get; set; }
        public virtual ICollection<WalletHistory> WalletHistories { get; set; }
    }
}
