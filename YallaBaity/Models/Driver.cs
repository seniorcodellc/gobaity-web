using System;
using System.Collections.Generic;

#nullable disable

namespace YallaBaity.Models
{
    public partial class Driver
    {
        public Driver()
        {
            FoodOrders = new HashSet<FoodOrder>();
        }

        public int DriverId { get; set; }
        public string DriverName { get; set; }
        public string Phone { get; set; }
        public string Password { get; set; }
        public string NationalIdcardFace { get; set; }
        public string NationalIdcardBack { get; set; }
        public string HealthCertificateFace { get; set; }
        public string HealthCertificateBack { get; set; }
        public string DrivingLicenseFace { get; set; }
        public string DrivingLicenseBack { get; set; }
        public string PersonalLicenseFace { get; set; }
        public string PersonalLicenseBack { get; set; }
        public bool IsDelete { get; set; }
        public bool IsApproved { get; set; }
        public bool IsActive { get; set; }

        public virtual ICollection<FoodOrder> FoodOrders { get; set; }
    }
}
