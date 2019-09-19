using System;
using System.Diagnostics;
using Microsoft.Extensions.Logging;

namespace Imms.Data
{
    public class EFLoggerProvider : ILoggerProvider
    {
        public ILogger CreateLogger(string categoryName) => new EFLogger(categoryName);
        public void Dispose() { }
    }

    public class EFLogger : ILogger
    {
        private readonly string categoryName;

        public EFLogger(string categoryName) => this.categoryName = categoryName;

        public bool IsEnabled(LogLevel logLevel){
            return logLevel >= GlobalConstants.DefaultLogger.LogLevel;
        }

        public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception exception, Func<TState, Exception, string> formatter)
        {            
            //if (categoryName == "Microsoft.EntityFrameworkCore.Database.Command"/* && logLevel == LogLevel.Information*/)
            {
                var logContent = formatter(state, exception);
                GlobalConstants.DefaultLogger.WriteMessage(logContent,logLevel);
            }
        }
        public IDisposable BeginScope<TState>(TState state) => null;
    }
}