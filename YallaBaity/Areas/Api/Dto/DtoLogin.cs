namespace YallaBaity.Areas.Api.Dto
{
    public class DtoLogin
    {
        public string Phone { get; set; }
        public string Password { get; set; }
        public bool Login { get; set; } = false;
    }
}
