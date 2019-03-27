using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using ReviewerNet.Models;

namespace ReviewerNet.CustomFilters
{
    public class ReviewerNetActionFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);
            
            if (UserSession.SessionId == string.Empty &&
                !CheckRequestedActionAllowedBeforeAuth(filterContext.HttpContext.Request.Path.Value))
                filterContext.Result = new RedirectToActionResult("BeforeFilter", "Account", new { value = "Unauthenticated" });
        }

        private bool CheckRequestedActionAllowedBeforeAuth(string route)
        {
            return route.Contains("/Account/Register") || route.Contains("/Account/ActivateAccount") || route.Contains("/Account/Login");
        }
    }
}