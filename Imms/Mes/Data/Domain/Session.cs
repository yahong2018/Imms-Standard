using System;
using Imms.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Imms.Mes.Data.Domain
{
    public class WorkstationSession : Entity<long>
    {
        public int WorkstationId { get; set; }
        public int SessionType { get; set; }
        public int CurrentStep { get; set; }

        public int OperatorId { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeCardNo { get; set; }
        public int GID { get; set; }
        public int DID { get; set; }
        public DateTime CreateTime { get; set; }
        public DateTime LastProcessTime { get; set; }
        public DateTime ExpireTime { get; set; }
    }

    public class WorkstationSessionConfigure : EntityConfigure<WorkstationSession>
    {
        protected override void InternalConfigure(EntityTypeBuilder<WorkstationSession> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("workstation_session");
            ImmsDbContext.RegisterEntityTable<Operator>("workstation_session");

            builder.Property(e => e.WorkstationId).HasColumnName("workstation_id");
            builder.Property(e => e.SessionType).HasColumnName("session_type");
            builder.Property(e => e.CurrentStep).HasColumnName("current_step");
            builder.Property(e => e.OperatorId).HasColumnName("operator_id");
            builder.Property(e => e.EmployeeId).HasColumnName("employee_id");
            builder.Property(e => e.EmployeeName).HasColumnName("employee_name");
            builder.Property(e => e.EmployeeCardNo).HasColumnName("employee_card_no");
            builder.Property(e => e.GID).HasColumnName("GID");
            builder.Property(e => e.DID).HasColumnName("DID");
            builder.Property(e => e.CreateTime).HasColumnName("create_time");
            builder.Property(e => e.LastProcessTime).HasColumnName("last_process_time");
            builder.Property(e => e.ExpireTime).HasColumnName("expire_time");
        }
    }
}