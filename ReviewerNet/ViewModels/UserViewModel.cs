using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using ReviewerNet.Models;

namespace ReviewerNet.ViewModels
{
    public class UserRegistrationAndLoginData
    {
        public string UserName { get; set; }
        
        public string Email { get; set; }
        
        public string Password { get; set; }
        
        public string ConfirmPassword { get; set; }
        
        public string PhoneNumber { get; set; }

        public bool Remember { get; set; }

        public UserRegistrationAndLoginData()
        {
            UserName = string.Empty;
            Email = string.Empty;
            Password = string.Empty;
            ConfirmPassword = string.Empty;
            PhoneNumber = string.Empty;
            Remember = false;
        }

        public async Task<KeyValuePair<bool, string>> CheckUserName(MainApiDbContext context)
        {
            //Reprocess the UserName string to remove all characters as \s \t \r \n
            UserName = string.Concat(UserName.Where(c => !char.IsWhiteSpace(c)));
            
            //Check if UserName is already used
            if (await context.Users.AnyAsync(u => u.Username == UserName))
                return new KeyValuePair<bool, string>(false, "UsernameClashed");
            
            //Check if UserName matches the required format
            var regex = new Regex(@"^[\w\d_]{4,12}$");
            return !regex.Match(UserName).Success
                ? new KeyValuePair<bool, string>(false, "RegexMismatched")
                : new KeyValuePair<bool, string>(true, string.Empty);
        }

        public async Task<KeyValuePair<bool, string>> CheckEmail(MainApiDbContext context)
        {
            //Remove all starting and trailing spaces
            Email = Email.Trim(' ').ToLower();
            
            //Since dots has no matter in email, simplify it by removing all dots
            var simplified = Email.Replace(".", string.Empty);
            
            //Check if Email is already used
            if (await context.Users.AnyAsync(u => u.Email.Replace(".", string.Empty) == simplified))
                return new KeyValuePair<bool, string>(false, "EmailClashed");
            
            //Check for Email format
            var regex = new Regex(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$");
            return !regex.Match(Email).Success
                ? new KeyValuePair<bool, string>(false, "InvalidEmail")
                : new KeyValuePair<bool, string>(true, string.Empty);
        }

        public KeyValuePair<bool, string> CheckPassword()
        {
            //Match all special characters except " and \s
            var regex = new Regex(@"^([\w\d-!@/%_=`~';:><,&\.\#\$\*\+\^\\\(\)\[\]\{\}\|\?])+$");
            if (!regex.Match(Password).Success)
                return new KeyValuePair<bool, string>(false, "PasswordRegex");

            return Password == ConfirmPassword
                ? new KeyValuePair<bool, string>(true, string.Empty)
                : new KeyValuePair<bool, string>(false, "ConfirmMismatched");
        }

        public bool CheckPhoneNumber()
        {
            //Remove all starting and trailing spaces
            PhoneNumber = PhoneNumber.Trim(' ');

            var regex = new Regex(@"^([\d\s-\#\(\)\+\*])+$");
            return regex.Match(PhoneNumber).Success && PhoneNumber.Length >= 9 && PhoneNumber.Length < 30;
        }
    }
}