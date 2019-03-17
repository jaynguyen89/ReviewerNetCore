using System;
using System.Collections.Generic;

namespace ReviewerNet.Models
{
    public partial class Profiles
    {
        public Profiles()
        {
            Users = new HashSet<Users>();
        }

        public int Id { get; set; }
        public bool? IsUserProfile { get; set; }
        public int? PodLocationId { get; set; }
        public int? PobLocationId { get; set; }
        public int? RestingPlaceId { get; set; }
        public string PlacesOfLiving { get; set; }
        public string OtherNames { get; set; }
        public string ParentsName { get; set; }
        public string HighLights { get; set; }
        public string Relationships { get; set; }
        public string Education { get; set; }
        public string Languages { get; set; }
        public string WorkHistory { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string GiveName { get; set; }
        public string PhoneNumber { get; set; }
        public string AvatarName { get; set; }
        public string AvatarTitle { get; set; }
        public string FacebookProfile { get; set; }
        public string TwitterProfile { get; set; }
        public string BlogLink { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public DateTime? DateOfDeath { get; set; }
        public string CauseOfDeath { get; set; }
        public string Occupations { get; set; }
        public string FavoriteQuotes { get; set; }
        public string ProfileContent { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdateRecords { get; set; }

        public virtual Locations PobLocation { get; set; }
        public virtual Locations PodLocation { get; set; }
        public virtual Locations RestingPlace { get; set; }
        public virtual ICollection<Users> Users { get; set; }
    }
}
