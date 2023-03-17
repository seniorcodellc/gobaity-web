using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Localization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Areas.Api.Services;
using YallaBaity.SignalrHubs;

namespace YallaBaity
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //Authentication
            services.AddAuthentication("DashBoardAuth").AddCookie("DashBoardAuth", options =>
            {
                options.Cookie.Name = "DashBoardAuth";
                options.LoginPath = "/DashBoard/Account/Login";
                options.AccessDeniedPath = "/DashBoard/Account/AccessDenied";
                options.LogoutPath = "/DashBoard/Account/Login";
            });
            services.AddAuthentication("SideAuth").AddCookie("SideAuth", options =>
             {
                 options.Cookie.Name = "SideAuth";
                 options.LoginPath = "/Account?target=Login";
                 options.AccessDeniedPath = "/Account/AccessDenied";
                 options.LogoutPath = "/";
             });
            //services.AddAuthentication("BasicAuthentication").AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

            //Languages
            services.Configure<RequestLocalizationOptions>(options =>
            {
                var supportedCultures = new[]
                {
                    new CultureInfo("en"),
                    new CultureInfo("ar")
                };


                options.DefaultRequestCulture = new RequestCulture(culture: "ar", uiCulture: "ar");
                options.SupportedCultures = supportedCultures;
                options.SupportedUICultures = supportedCultures;
                options.RequestCultureProviders = new List<IRequestCultureProvider>
                {
                    new QueryStringRequestCultureProvider(){  QueryStringKey="lang"},
                    new CookieRequestCultureProvider(),
                    new AcceptLanguageHeaderRequestCultureProvider() ,
                   // new RouteDataRequestCultureProvider(),
                };
            });

            //Depentancy injection
            services.AddSingleton<IFilesServices, FilesServices>();
            services.AddTransient<IProcedureServices, ProcedureServices>();
            services.AddTransient<ILinqServices, LinqServices>();
            services.AddTransient(typeof(IBaseRepository<>), typeof(BaseRepository<>));
            services.AddTransient(typeof(IUnitOfWork), typeof(UnitOfWork));

            //Swagger
            services.AddSwaggerGen(options =>
            {
                options.AddSecurityDefinition("basic", new OpenApiSecurityScheme()
                {
                    Name = "Authorization",
                    Type = SecuritySchemeType.Http,
                    Scheme = "basic",
                    In = ParameterLocation.Header,
                    Description = "Basic Authorization header using the Bearer scheme."
                });

                options.AddSecurityRequirement(new OpenApiSecurityRequirement
            {
                {
                      new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme,
                                Id = "basic",

                            },In= ParameterLocation.Header,
                        },
                        new string[] {}
                }
            });
            });

            //DataBase Connection
            services.AddDbContext<Models.YallaBaityDBContext>(options => options.UseSqlServer(Configuration.GetConnectionString("AppConnection")));

            //Auto Mapper
            services.AddAutoMapper(typeof(Startup));

            //Add MVC
            services.AddControllersWithViews();

            //SignalR
            services.AddSignalR();

            //services.AddControllersWithViews().AddJsonOptions(options => {
            //    options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.Preserve;
            //}); 
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }

            app.UseHttpsRedirection();

            app.UseStaticFiles();

            app.UseRouting();

            //Authentication & Authorization
            app.UseAuthentication();
            app.UseAuthorization();

            //Languages
            app.UseRequestLocalization();

            //Swagger
            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "Yalla Baity Api v1");
            });

            //Endpoints
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(name: "default", pattern: "{controller=Home}/{action=Index}/{id?}");
                endpoints.MapControllerRoute(name: "areas", pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapHub<ProviderHubs>("/providerHubs").AllowAnonymous();
            });
        }
    }
}
