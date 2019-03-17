using System;
using System.Collections.Generic;

namespace ReviewerNet.Models
{
    public partial class UserConnections
    {
        public int Id { get; set; }
        public int RequesterId { get; set; }
        public int ReceiverId { get; set; }
        public bool? IsAccepted { get; set; }
        public string Message { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime? UpdatedOn { get; set; }

        public virtual Users Receiver { get; set; }
        public virtual Users Requester { get; set; }
    }
}
