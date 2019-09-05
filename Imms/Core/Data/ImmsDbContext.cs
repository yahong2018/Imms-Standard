using System;
using System.Collections.Generic;
using System.Linq;
using Imms.Data.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.Extensions.Logging;

namespace Imms.Data
{
    public class ImmsDbContext : DbContext
    {
        public ImmsDbContext()
        {
        }

        public ImmsDbContext(DbContextOptions options)
            : base(options)
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                if (ConfigurationManager.ConnectionString.ProviderType == ProviderType.SqlServer)
                {
                    optionsBuilder.UseSqlServer(ConfigurationManager.ConnectionString.ConnectionUrl);
                }
                else if (ConfigurationManager.ConnectionString.ProviderType == ProviderType.MySql)
                {
                    optionsBuilder.UseMySQL(ConfigurationManager.ConnectionString.ConnectionUrl);
                }
            }

            var loggerFactory = new LoggerFactory();
            loggerFactory.AddProvider(new EFLoggerProvider());
            optionsBuilder.UseLoggerFactory(loggerFactory);

            base.OnConfiguring(optionsBuilder);
        }

        public override int SaveChanges()
        {
            ChangeTracker.DetectChanges();

            var modifiedEntities = this.ChangeTracker.Entries()
                .Where(x => x.State == EntityState.Modified
                     || x.State == EntityState.Added
                     || x.State == EntityState.Deleted
                ).ToList();

            List<DataChangedNotifyEvent> eventList = new List<DataChangedNotifyEvent>();
            foreach (EntityEntry entry in modifiedEntities)
            {
                this.FillTracableData(entry);
                this.FillOrderNo(entry);

                int dmlType = this.GetDmlType(entry);
                IEntity entity = entry.Entity as IEntity;

                eventList.Add(new DataChangedNotifyEvent() { Entity = entity, DMLType = dmlType });
            }
            int result = base.SaveChanges();
            foreach (DataChangedNotifyEvent e in eventList)
            {
                DataChangedNotifier.Instance.Notify(e);
            }
            return result;
        }

        private void FillOrderNo(EntityEntry entry)
        {
            IOrderEntry order = entry.Entity as IOrderEntry;
            if (order == null || entry.State != EntityState.Added || !string.IsNullOrEmpty(order.OrderNo))
            {
                return;
            }

            string key = order.GetType().FullName;
            CodeSeed seed = this.Set<CodeSeed>().Where(x => x.SeedNo == key).FirstOrDefault();
            if (seed == null)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_DATA_NOT_FOUND, $"没有为{key}配置CodeSeed!");
            }

            lock (typeof(ImmsDbContext))
            {
                int prefixLength = seed.Prefix.Length;
                order.OrderNo = seed.Prefix + (seed.InitialValue.ToString() + seed.Postfix).PadLeft(seed.TotalLength - prefixLength, '0');

                seed.InitialValue += 1;
                this.Attach(seed).State = EntityState.Modified;
            }
        }

        private int GetDmlType(EntityEntry e)
        {
            int dmlType = 0;
            if (e.State == EntityState.Added)
            {
                dmlType = GlobalConstants.DML_OPERATION_INSERT;
            }
            else if (e.State == EntityState.Deleted)
            {
                dmlType = GlobalConstants.DML_OPERATION_DELETE;
            }
            else if (e.State == EntityState.Modified)
            {
                dmlType = GlobalConstants.DML_OPERATION_UPDATE;
            }

            return dmlType;
        }

        private void FillTracableData(EntityEntry entry)
        {
            if (!(entry.Entity is ITrackableEntity))
                return;

            ITrackableEntity trackableEntity = entry.Entity as ITrackableEntity;
            if (entry.State == EntityState.Added)
            {
                trackableEntity.CreateBy = GlobalConstants.GetCurrentUser().RecordId;
                trackableEntity.CreateDate = DateTime.Now;
            }
            else if (entry.State == EntityState.Modified)
            {
                trackableEntity.UpdateBy = GlobalConstants.GetCurrentUser().RecordId;
                trackableEntity.UpdateDate = DateTime.Now;
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfiguration(new TreeCodeConfigure());
            modelBuilder.ApplyConfiguration(new SimpleCodeConfigure());
            modelBuilder.ApplyConfiguration(new CodeSeedConfigure());

            modelBuilder.ApplyConfiguration(new SysetmAppConfigure());
            modelBuilder.ApplyConfiguration(new DataExchangeRuleConfigure());
            modelBuilder.ApplyConfiguration(new DataExcahngeConfigure());

            modelBuilder.ApplyConfiguration(new MediaConfigure());
            foreach (ICustomModelBuilder customModelBuilder in customModelBuilders)
            {
                customModelBuilder.BuildModel(modelBuilder);
            }

            base.OnModelCreating(modelBuilder);
        }

        private static List<ICustomModelBuilder> customModelBuilders = new List<ICustomModelBuilder>();

        public static void RegisterModelBuilders(ICustomModelBuilder builder)
        {
            customModelBuilders.Add(builder);
        }
    }

    public interface ICustomModelBuilder
    {
        void BuildModel(ModelBuilder modelBuilder);
    }
}