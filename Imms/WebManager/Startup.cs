using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Imms.WebManager.Filters;
using Imms.Data;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Serialization;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Diagnostics;
using System.Net.WebSockets;
using System.Threading;

namespace Imms.WebManager
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
            services.Configure<CookiePolicyOptions>(options =>
            {
                // This lambda determines whether user consent for non-essential cookies is needed for a given request.
                options.CheckConsentNeeded = context => true;
                options.MinimumSameSitePolicy = SameSiteMode.None;
            });
            services.AddSession();
            services.AddMvc(config =>
            {
                config.Filters.Add(new AuthenticationFilter());
                config.Filters.Add(new ExtJsResponseBodyFilter());
            })
            .SetCompatibilityVersion(CompatibilityVersion.Version_2_2)
            .AddJsonOptions(x =>
            {
                x.SerializerSettings.ContractResolver = new DefaultContractResolver
                {
                    NamingStrategy = new CamelCaseNamingStrategy()
                };
                x.SerializerSettings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore;
                x.SerializerSettings.Formatting = Formatting.Indented;
            });

            services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie();
            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            GlobalConstants.DbContextFactory = new DbContextFactory();

            ImmsDbContext.RegisterModelBuilders(new Imms.Security.Data.SecurityModelBuilder());
            ImmsDbContext.RegisterModelBuilders(new Imms.Mes.Data.MesModelBuilder());

            GlobalConstants.GetCurrentUserDelegate = Security.Data.SystemUserLogic.GetCurrentUser;

            services.AddSignalR(); 
            services.AddSingleton<RealtimeDataPushTask,RealtimeDataPushTask>();          
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            app.UseExceptionHandler(builder =>
              {
                  builder.Run(async context =>
                  {
                      context.Response.StatusCode = StatusCodes.Status500InternalServerError;
                      context.Response.ContentType = "application/json";

                      var ex = context.Features.Get<IExceptionHandlerFeature>();
                      await context.Response.WriteAsync(ex?.Error?.Message ?? "出现系统错误");
                  });
              });

            if (env.IsDevelopment())
            {
                //  注释以禁用开发异常处理功能
                // app.UseDeveloperExceptionPage();
                //
            }
            else
            {
                // app.UseExceptionHandler("/Home/Error");

                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }
            app.UseSession();

            app.UseHttpsRedirection();
            app.UseStaticFiles();
            app.UseCookiePolicy();
            app.UseAuthentication();

            Imms.HttpContext.Configure(app.ApplicationServices.GetRequiredService<Microsoft.AspNetCore.Http.IHttpContextAccessor>());

            app.UseSignalR(routes =>
            {
                routes.MapHub<KanbanRealtimeHub>("/kanbanHub/realtime");
            });            
            
            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Home}/{action=Index}/{id?}");
            });

            RealtimeDataPushTask task = app.ApplicationServices.GetService<RealtimeDataPushTask>();
            task.Start();
        }
    }

    public class DbContextFactory : IDbContextFactory
    {
        public DbContext GetContext()
        {
            return new ImmsDbContext();
        }

        public DbContext GetContext(string connectionString)
        {
            throw new NotImplementedException();
        }
    }
}
