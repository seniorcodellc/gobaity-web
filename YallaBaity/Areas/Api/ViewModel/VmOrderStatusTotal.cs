namespace YallaBaity.Areas.Api.ViewModel
{
    public class VmOrderStatusTotal
    {
        public int Pending { get; set; }
        public int Preparing { get; set; }
        public int Prepared { get; set; }
        public int Delivering { get; set; }
        public int Delivered { get; set; }
    }
}
