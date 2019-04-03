using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ReviewerNet.ServicesAndHelpers;
using ReviewerNet.Models;
using ReviewerNet.ViewModels;
using Microsoft.EntityFrameworkCore;

namespace ReviewerNet.Controllers
{
    [EnableCors("AllowAllOrigins")]
    public class AccountController : Controller
    {
        private readonly MainApiDbContext _context;
        private readonly EmailService _emailService;

        public AccountController(MainApiDbContext context)
        {
            _context = context;
            _emailService = new EmailService();
        }
        
        [AllowAnonymous]
        public IActionResult BeforeFilter(string value)
        {
            switch (value)
            {
                case "Unauthenticated":
                    return Json(new { result = "failed", message = value });
            }

            return null;
        }

        /* Function uses UserRegistrationAndLoginData as the ViewModel to serialize registration data
         * URL: /Account/Register/[data]
         */
        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> Register(UserRegistrationAndLoginData signupData)
        {
            System.Diagnostics.Debug.WriteLine("console diagnostic = " + signupData.Email + " " + signupData.Password + " " + signupData.UserName + " " + signupData.PhoneNumber);
            var (key, value) = signupData.CheckPassword();
            if (!key)
                return Json(new { result = "failed", message = value });

            (key, value) = await signupData.CheckUserName(_context);
            if (!key)
                return Json(new { result = "failed", message = value });
            
            (key, value) = await signupData.CheckEmail(_context);
            if (!key)
                return Json(new { result = "failed", message = value });
            
            if (!signupData.CheckPhoneNumber())
                return Json(new { result = "failed", message = "PhoneNumberFormat" });
            
            KeyValuePair<string, string> PasswordData = HashHelper.CreateHashedString(signupData.Password);
            
            var user = new Users
            {
                Username = signupData.UserName,
                PasswordHash = PasswordData.Value,
                PasswordSalt = PasswordData.Key,
                Email = signupData.Email,
                PhoneNumber = signupData.PhoneNumber
            };

            await _context.Users.AddAsync(user);
            var result = await _context.SaveChangesAsync();

            if (result <= 0) return Json(new {result = "failed", message = "InsertionFailed"});

            var newUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == user.Email);
            var confirmToken = HashHelper.Md5Hash(user.Email);
            
            newUser.EmailToken = confirmToken;
            await _context.SaveChangesAsync();
            
            //Send the Account Activation Email and return final result
            if (_emailService.SendUserAccountActivationEmail(newUser))
                return Json(new { result = "success" });
            else
                return Json(new { result = "failed", message = "EmailSentFailed" });

        }
        
        /* Function called from Email activation link to activate user account.
         * Params: emailToken - the token to verify if the user is valid, userEmail - the email address used to register account
         * URL: /Account/ActivateAccount/emailToken=...&userEmail=...
         */
        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> ActivateAccount(string emailToken, string userEmail)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == userEmail);

            if (user.EmailToken == emailToken)
            {
                user.IsEmailConfirmed = true;
                await _context.SaveChangesAsync();

                return Json(new { result = "success" });
            }

            return Json(new { result = "failed", message = "TokenMismatched" });
        }
        
        
        /* Function to login user using user's login credentials. After logging in, create Session and Cookie data to manage user activities.
         * URL: /Account/Login/[loginData]
         */
        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> Login(UserRegistrationAndLoginData loginData)
        {
            if (loginData.Email == string.Empty && loginData.UserName == string.Empty)
                return Json(new { result = "failed", message = "EmptyIdentity" });

            var success = false;
            var user = new Users();
            if (loginData.Email != string.Empty)
            {
                user = await _context.Users.FirstOrDefaultAsync(u => u.Email == loginData.Email);
                var loginPasswordHash = HashHelper.CreateHashedString(user.PasswordSalt, loginData.Password);
                
                if (user.PasswordHash == loginPasswordHash)
                    success = true;
            }

            if (loginData.UserName != string.Empty)
            {
                user = await _context.Users.FirstOrDefaultAsync(u => u.Username == loginData.UserName);
                var loginPasswordHash = HashHelper.CreateHashedString(user.PasswordSalt, loginData.Password);
                
                if (user.PasswordHash == loginPasswordHash)
                    success = true;
            }

            if (!success) return Json(new {result = "failed"});
            
            var sessionToken = HashHelper.Md5Hash(user.Email + user.PasswordHash);

            UserSession.SessionEnd = DateTime.UtcNow.AddMinutes(40.0);
            UserSession.SessionId = sessionToken;
            UserSession.SessionRole = "";
                
            return Json(new { result = "success", message = UserSession.SessionId });
        }

        [AllowAnonymous]
        public IActionResult TransferSessionInformation()
        {
            /*var options = new CookieOptions {Expires = DateTime.Now.AddHours(2)};
            Response.Cookies.Append(
                "UserData",
                "SessionId",
                new CookieOptions()
                {
                    Path = "/",
                    Expires = DateTime.UtcNow.AddHours(2)
                }
            );*/
            return Json(new { SessionId = UserSession.SessionId, SessionEnd = UserSession.SessionEnd, SessionRole = UserSession.SessionRole });
        }
    }
}