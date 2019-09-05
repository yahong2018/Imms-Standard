using Imms.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Text;

namespace Imms.Mes.Data.Domain
{
    public partial class Operator : TrackableEntity<long>
    {
        public long UserId { get; set; }
        public long OrganizationId { get; set; }
        public long SupervisorId { get; set; }

        public virtual List<OperatorCapability> OperatorCapabilities { get; set; } = new List<OperatorCapability>();
        
    }

    public partial class OperatorCapability : TrackableEntity<long>
    {
        public long OperatorId { get; set; }
        public long OperationId { get; set; }
        public byte SkillLevel { get; set; }

        public virtual Operator Operator { get; set; }
        public virtual Operation Operation { get; set; }
    }

    public class OperatorCapabilityConfigure : TrackableEntityConfigure<OperatorCapability>
    {
        protected override void InternalConfigure(EntityTypeBuilder<OperatorCapability> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("operator_capability");

            builder.Property(e => e.OperationId).HasColumnName("operation_id").HasColumnType("bigint(20)");
            builder.Property(e => e.OperatorId).HasColumnName("operator_id").HasColumnType("bigint(20)");
            builder.Property(e => e.SkillLevel).HasColumnName("skill_level").HasColumnType("tinyint(4)");

            builder.HasOne(e => e.Operation).WithMany().HasForeignKey(e => e.OperationId).HasConstraintName("operation_id");
            builder.HasOne(e => e.Operator).WithMany(e => e.OperatorCapabilities).HasForeignKey(e => e.OperatorId).HasConstraintName("operator_id");
        }
    }

    public class OperatorConfigure : TrackableEntityConfigure<Operator>
    {
        protected override void InternalConfigure(EntityTypeBuilder<Operator> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("operator");

            builder.Property(e => e.OrganizationId).HasColumnName("organization_id").HasColumnType("bigint(20)");
            builder.Property(e => e.SupervisorId).HasColumnName("supervisor_id").HasColumnType("bigint(20)");
            builder.Property(e => e.UserId).HasColumnName("user_id").HasColumnType("bigint(20)");
        }
    }

}
