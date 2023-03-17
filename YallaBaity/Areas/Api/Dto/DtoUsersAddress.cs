namespace YallaBaity.Areas.Api.Dto
{
    public class DtoUsersAddress
    {
        public string UsersAddressName { get; set; }
        public string Address { get; set; }
        public int ApartmentNo { get; set; }
        public int BuildingNo { get; set; } 
        public string Street { get; set; }
        public int Floor { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}
