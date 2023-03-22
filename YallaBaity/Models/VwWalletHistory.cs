using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class VwWalletHistory
    {
        public int UserId { get; set; }
        public DateTime Date { get; set; }
        public decimal Amount { get; set; }
        public decimal Balance { get; set; }
        public int WalletHistoryId { get; set; }
        public decimal Commission { get; set; }
        public int Effect { get; set; }
        public int? OrderId { get; set; }
        public string ShortDate { get; set; }
    }
}
