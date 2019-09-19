﻿using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Microsoft.Extensions.Logging;

namespace Imms
{
    public class Logger : TextWriter
    {
        public LogLevel LogLevel { get; set; }

        protected internal Logger()
        {
#if DEBUG
            this.LogLevel = LogLevel.Information;
#else
            this.LoggerLevel= LoggerLevel.INFO;
#endif

        }

        public virtual void WriteMessage(string message, LogLevel level)
        {
            if (level >= this.LogLevel)
            {
                //string msg = string.Format(string.Format("[Imms.Core.Logger--{0:yyyy/MM/dd HH:mm:ss}-{1}]:{2}{3}", DateTime.Now, level, message.Trim(), Environment.NewLine), parameterValues);
                lock (this)
                {
                    Console.WriteLine();
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.Write(string.Format("[Imms.Core.Logger--{0:yyyy/MM/dd HH:mm:ss}-{1}]:", DateTime.Now, level));
                    Console.WriteLine(message);
                    Console.ResetColor();
                    //  File.AppendAllText(this.LoggerFileName, msg);
                }
            }
        }

        //private WriteTextHandler WriteTextFunc;

        public override System.Text.Encoding Encoding
        {
            get
            {
                return System.Text.Encoding.UTF8;
            }
        }

        public string LoggerFileName
        {
            get
            {
                return DateTime.Now.ToString("yyyyMMdd") + "_log.txt";
            }
        }


        public void Debug(string message)
        {
            this.WriteMessage(message, LogLevel.Debug);
        }

        public void Trace(string message)
        {
            this.WriteMessage(message, LogLevel.Trace);
        }

        public void Info(string message)
        {
            this.WriteMessage(message, LogLevel.Information);
        }

        public void Warning(string message)
        {
            //lock (typeof(Logger))
            //{
            //    SystemEnvironment.WarnCount += 1;
            //}

            this.WriteMessage(message, LogLevel.Warning);
        }

        public void Error(string message)
        {
            //lock (typeof(Logger))
            //{
            //    SystemEnvironment.ErrorCount += 1;
            //}

            this.WriteMessage(message, LogLevel.Error);
        }
    }

    //internal delegate void WriteTextHandler(string str);
}