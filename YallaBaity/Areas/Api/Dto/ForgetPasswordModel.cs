using YallaBaity.Models;

namespace YallaBaity.Areas.Api.Dto
{
    public class ForgetPasswordModel
    {
        public int Code { get; set; }
        public int UserId { get; set; }
    }
}
