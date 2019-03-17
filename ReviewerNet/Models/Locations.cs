using System;
using System.Collections.Generic;

namespace ReviewerNet.Models
{
    public partial class Locations
    {
        public Locations()
        {
            ProfilesPobLocation = new HashSet<Profiles>();
            ProfilesPodLocation = new HashSet<Profiles>();
            ProfilesRestingPlace = new HashSet<Profiles>();
            Users = new HashSet<Users>();
        }

        public int Id { get; set; }
        public string BuildingName { get; set; }
        public string BuildingAddress { get; set; }
        public string StreetAddress { get; set; }
        public string CityDistrict { get; set; }
        public string ProvinceState { get; set; }
        public string SuburbWard { get; set; }
        public string Postcode { get; set; }
        public string Country { get; set; }
        public string CountryCode { get; set; }
        public string FormerAddress { get; set; }
        public string Description { get; set; }
        public string AvatarName { get; set; }
        public string CombinedAddress { get; set; }
        public string SimpleAddress { get; set; }

        public virtual ICollection<Profiles> ProfilesPobLocation { get; set; }
        public virtual ICollection<Profiles> ProfilesPodLocation { get; set; }
        public virtual ICollection<Profiles> ProfilesRestingPlace { get; set; }
        public virtual ICollection<Users> Users { get; set; }
    }
}
