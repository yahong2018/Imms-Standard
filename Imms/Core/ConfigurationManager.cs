using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Imms
{
    public class ConfigurationManager
    {
        public readonly static IConfiguration Configuration;
        public readonly static ConnectionString ConnectionString;

        static ConfigurationManager()
        {
            Configuration = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: true)
                .Build();

            ConnectionString = new ConnectionString();
            ConnectionString.ConnectionUrl = Configuration["ConnectionStrings:IMMS-CONN:ConnectionUrl"];
            ConnectionString.ProviderType = (ProviderType) Enum.Parse(typeof(ProviderType), Configuration["ConnectionStrings:IMMS-CONN:ProviderType"]);
        }                
    }

    public class ConnectionString
    {
        public string ConnectionUrl { get; set; }
        public ProviderType ProviderType { get; set; }
    }

    public enum ProviderType
    {
        SqlServer,
        MySql,
        Oracle
    }
}
