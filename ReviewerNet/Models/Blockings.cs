using System;
using System.Collections.Generic;

namespace ReviewerNet.Models
{
    public partial class Blockings
    {
        public int Id { get; set; }
        public int BlockerId { get; set; }
        public int BlockedId { get; set; }
        public DateTime CreatedOn { get; set; }

        public virtual Users Blocked { get; set; }
        public virtual Users Blocker { get; set; }
    }
}
