using System;
using System.Collections.Generic;

namespace ReviewerNet.Models
{
    public partial class Users
    {
        public Users()
        {
            BlockingsBlocked = new HashSet<Blockings>();
            BlockingsBlocker = new HashSet<Blockings>();
            UserConnectionsReceiver = new HashSet<UserConnections>();
            UserConnectionsRequester = new HashSet<UserConnections>();
        }

        public int Id { get; set; }
        public int? LocationId { get; set; }
        public int? ProfileId { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string TempPassword { get; set; }
        public string ConfirmToken { get; set; }
        public bool? IsEmailConfirmed { get; set; }
        public string PhoneNumber { get; set; }
        public bool? IsPhoneComfirmed { get; set; }
        public bool? Is2Faenabled { get; set; }
        public byte? TwoFadestination { get; set; }
        public string TwoFatoken { get; set; }
        public DateTime? TwoFatokenSentOn { get; set; }
        public string FamilyName { get; set; }
        public string MiddleName { get; set; }
        public string GiveName { get; set; }
        public DateTime? DateOfBith { get; set; }
        public string Headline { get; set; }
        public string AvatarName { get; set; }
        public bool? IsActive { get; set; }
        public DateTime? LastLogin { get; set; }
        public DateTime? LastActive { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime? UpdatedOn { get; set; }

        public virtual Locations Location { get; set; }
        public virtual Profiles Profile { get; set; }
        public virtual ICollection<Blockings> BlockingsBlocked { get; set; }
        public virtual ICollection<Blockings> BlockingsBlocker { get; set; }
        public virtual ICollection<UserConnections> UserConnectionsReceiver { get; set; }
        public virtual ICollection<UserConnections> UserConnectionsRequester { get; set; }
    }
}
