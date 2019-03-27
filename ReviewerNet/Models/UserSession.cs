using System;

namespace ReviewerNet.Models
{
    public static class UserSession
    {
        public static DateTime SessionEnd { get; set; }
        
        public static string SessionId { get; set; }
        
        public static string SessionRole { get; set; }

        static UserSession()
        {
            SessionId = string.Empty;
        }
    }
}