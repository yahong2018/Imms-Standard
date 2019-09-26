using Imms.Data;
using Imms.Data.Domain;
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
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeCardNo { get; set; }

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


    public class WorkShop : WorkOrganizationUnit
    {
        public string WorkShopCode { get { return base.OrganizationCode; } set { base.OrganizationCode = value; } }
        public string WorkShopName { get { return base.OrganizationName; } set { base.OrganizationName = value; } }
        public long OperationId { get; set; }

        public virtual Operation Operation { get; set; }
    }

    public class WorkStation : WorkOrganizationUnit
    {
        public string WorkStaitonCode { get { return base.OrganizationCode; } set { base.OrganizationCode = value; } }
        public string WorkStationName { get { return base.OrganizationName; } set { base.OrganizationName = value; } }

        public int RfidControllerId { get; set; }
        public int RfidTerminatorId { get; set; }

        public virtual RfidController RfidController { get; set; }
    }


    public class OperatorCapabilityConfigure : TrackableEntityConfigure<OperatorCapability>
    {
        protected override void InternalConfigure(EntityTypeBuilder<OperatorCapability> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("operator_capability");
            ImmsDbContext.RegisterEntityTable<OperatorCapability>("operator_capability");

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
            ImmsDbContext.RegisterEntityTable<Operator>("operator");

            builder.Property(e => e.OrganizationId).HasColumnName("organization_id").HasColumnType("bigint(20)");
            builder.Property(e => e.SupervisorId).HasColumnName("supervisor_id").HasColumnType("bigint(20)");
            builder.Property(e => e.UserId).HasColumnName("user_id").HasColumnType("bigint(20)");
            builder.Property(e => e.EmployeeId).HasColumnName("employee_id");
            builder.Property(e => e.EmployeeName).HasColumnName("employee_name");
            builder.Property(e => e.EmployeeCardNo).HasColumnName("employee_card_no");
        }
    }

    public class WorkShopConfigure : TrackableEntityConfigure<WorkShop>
    {
        protected override void InternalConfigure(EntityTypeBuilder<WorkShop> builder)
        {
            base.InternalConfigure(builder);

            ImmsDbContext.RegisterEntityTable<WorkShop>("work_organization_unit");
            builder.Ignore(e => e.WorkShopCode);
            builder.Ignore(e => e.WorkShopName);
            builder.Property(e => e.OperationId).HasColumnName("operation_id");
            builder.OwnsOne(e => e.Operation).HasForeignKey(e => e.RecordId).HasConstraintName("operation_id");

            builder.HasDiscriminator("organization_type", typeof(string))
               .HasValue<WorkShop>(GlobalConstants.TYPE_ORG_WORK_SHOP)
               ;
        }
    }

    public class WorkStationConfigure : TrackableEntityConfigure<WorkStation>
    {
        protected override void InternalConfigure(EntityTypeBuilder<WorkStation> builder)
        {
            base.InternalConfigure(builder);

            ImmsDbContext.RegisterEntityTable<WorkShop>("work_organization_unit");
            builder.Ignore(e => e.WorkStaitonCode);
            builder.Ignore(e => e.WorkStationName);
            builder.Property(e => e.RfidControllerId).HasColumnName("rfid_controller_id");
            builder.Property(e => e.RfidTerminatorId).HasColumnName("rfid_terminator_id");
            builder.OwnsOne(e => e.RfidController).HasForeignKey(e => e.RecordId).HasConstraintName("rfid_controller_id");

            builder.HasDiscriminator("organization_type", typeof(string))
               .HasValue<WorkStation>(GlobalConstants.TYPE_ORG_WORK_STATETION)
               ;
        }
    }
}
