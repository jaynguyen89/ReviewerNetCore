using System;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using ReviewerNet.Models;

namespace ReviewerNet.ServicesAndHelpers
{
    public class EmailService
    {
        static readonly string BASE_DIR = AppDomain.CurrentDomain.BaseDirectory;

        public bool SendUserAccountActivationEmail(Users newUser)
        {
            string[] DirTokens = BASE_DIR.Split(@"\");
            var UserRegistration_EmailConfirm_Template = string.Empty;
            for (var i = 0; i < DirTokens.Length - 4; i++)
                UserRegistration_EmailConfirm_Template += DirTokens[i] + @"\";

            UserRegistration_EmailConfirm_Template += @"\EmailTemplates\UserRegistration_EmailConfirm.html";
            
            var FileReader = new StreamReader(UserRegistration_EmailConfirm_Template);

            var TemplateContent = FileReader.ReadToEnd();
            FileReader.Close();

            var MailContent = TemplateContent.Replace("[Username]", newUser.Username);
            MailContent = MailContent.Replace("[EmailToken]", newUser.EmailToken);
            MailContent = MailContent.Replace("[UserEmail]", newUser.Email);
            
            const string MailSubject = "ReviewerNet - Email Confirmation";
            MailMessage _confirmationEmail = new MailMessage();

            _confirmationEmail.IsBodyHtml = true;
            _confirmationEmail.From = new MailAddress("nguyen.le.kim.phuc@gmail.com");
            _confirmationEmail.To.Add(newUser.Email);
            _confirmationEmail.Subject = MailSubject;
            _confirmationEmail.Body = MailContent;

            return SendMail(_confirmationEmail);
        }

        private bool SendMail(MailMessage _mail)
        {
            try
            {
                SmtpClient _smtp = new SmtpClient();

                _smtp.Host = "smtp.gmail.com";
                _smtp.Port = 587;
                _smtp.EnableSsl = true;
                _smtp.Credentials = new NetworkCredential("nguyen.le.kim.phuc@gmail.com", "Chay571990");

                _smtp.Send(_mail);
            }
            catch (SmtpException)
            {
                return false;
            }
            
            return true;
        }
    }
}