using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;
using ReviewerNet.CustomFilters;
using ReviewerNet.ServicesAndHelpers;
using ReviewerNet.Models;

namespace ReviewerNet
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        
        readonly string AllowAllOrigins = "AllowAllOrigins";
        
        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddCors(options =>
            {
                options.AddPolicy(AllowAllOrigins,
                    builder => builder.AllowAnyOrigin()
                        .AllowAnyMethod()
                        .AllowAnyHeader()
                );
            });
            
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);

            services.AddDbContext<MainApiDbContext>(
                    options => options.UseSqlServer(Configuration["Data:MainApiDbContext:ConnectionString"])
                );
            
            services.AddDistributedMemoryCache();
            services.AddSession();
            
            services.AddTransient<EmailService, EmailService>();
            services.AddScoped<ReviewerNetActionFilter>();

            /*services.AddDefaultIdentity<Users>()
                    .AddEntityFrameworkStores<MainApiDbContext>()
                    .AddDefaultTokenProviders(); //Provider for token generation; used for password/username/email recovery and 2FA

            services.Configure<IdentityOptions>(options =>
            {
                options.Password.RequireDigit = true;
                options.Password.RequireLowercase = true;
                options.Password.RequireUppercase = true;
                options.Password.RequiredLength = 8;
                options.Password.RequiredUniqueChars = 4;

                options.User.RequireUniqueEmail = true;
                options.Lockout.AllowedForNewUsers = true;
                options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(30);
                options.Lockout.MaxFailedAccessAttempts = 5;
            });*/
            
            services.ConfigureApplicationCookie(options =>
            {
                options.Cookie.HttpOnly = true;
                options.Cookie.Expiration = TimeSpan.FromHours(2);
                options.Cookie.IsEssential = true;
                options.LoginPath = "/Account/Login";
                options.LogoutPath = "/";
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }
            
            app.UseCors(AllowAllOrigins);
            app.UseHttpsRedirection();
            app.UseSession();
            
            app.UseMvc(routes => {
                routes.MapRoute("OptionalParam", "{controller}/{action}/{id?}");
            });
            
            app.UseCookiePolicy();
            app.UseAuthentication();
        }
    }
}
