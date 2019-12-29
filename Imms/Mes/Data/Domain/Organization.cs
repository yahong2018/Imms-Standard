using Imms.Data;
using Imms.Data.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Text;

namespace Imms.Mes.Data.Domain
{
    public class Workshop : WorkOrganizationUnit
    {
        public string WorkshopCode { get { return base.OrgCode; } set { base.OrgCode = value; } }
        public string WorkshopName { get { return base.OrgName; } set { base.OrgName = value; } }

        public int OperationIndex { get; set; }
        public int PrevOperationIndex { get; set; }
        public int WorkshopType { get; set; }
    }

    public class Workstation : WorkOrganizationUnit
    {
        public string WorkStaitonCode { get { return base.OrgCode; } set { base.OrgCode = value; } }
        public string WorkStationName { get { return base.OrgName; } set { base.OrgName = value; } }

        public int RfidControllerId { get; set; }
        public int RfidTerminatorId { get; set; }
        public int RfidTemplateIndex { get; set; }
        public string WocgCode { get; set; }
        public int AutoReportCount { get; set; }

        public string LocCode { get; set; }

        public virtual RfidController RfidController { get; set; }
    }

    public partial class Operator : TrackableEntity<long>
    {
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeCardNo { get; set; }

        public long orgId { get; set; }
        public string orgCode { get; set; }
        public string orgName { get; set; }

        public static readonly string ROLE_WORKSHOP_OPERATOR = "WORKSHOP_OPERATOR";
    }


    public class WorkstationLogin : Entity<long>
    {
        public int RfidTerminatorId { get; set; }
        public int RfidControllerGroupId { get; set; }
        public string RfidCardNo { get; set; }
        public DateTime LoginTime { get; set; }
        public int RfidControllerId { get; set; }
        public long WorkstationId { get; set; }
        public long RfidCardId { get; set; }
        public long OperatorId { get; set; }

        public virtual RfidCard RfidCard { get; set; }
        public virtual Operator Operator { get; set; }
        public virtual Workstation WorkStation { get; set; }
        public virtual RfidController RfidController { get; set; }
    }

    public class WorkstationLoginConfigure : TrackableEntityConfigure<WorkstationLogin>
    {
        protected override void InternalConfigure(EntityTypeBuilder<WorkstationLogin> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("Workstation_login");
            ImmsDbContext.RegisterEntityTable<Operator>("Workstation_login");

            builder.Property(e => e.RfidTerminatorId).HasColumnName("rfid_terminator_id");
            builder.Property(e => e.RfidControllerGroupId).HasColumnName("rfid_controller_group_id");
            builder.Property(e => e.RfidCardNo).HasColumnName("rfid_card_no");
            builder.Property(e => e.LoginTime).HasColumnName("login_time");
            builder.Property(e => e.RfidControllerId).HasColumnName("rfid_controller_id");
            builder.Property(e => e.WorkstationId).HasColumnName("workstation_id");
            builder.Property(e => e.RfidCardId).HasColumnName("rfid_card_id");
            builder.Property(e => e.OperatorId).HasColumnName("operator_id");

            builder.HasOne(e => e.RfidCard).WithMany().HasForeignKey(e => e.RfidCardId).HasConstraintName("rfid_card_id");
            builder.HasOne(e => e.Operator).WithMany().HasForeignKey(e => e.OperatorId).HasConstraintName("operator_id");
            builder.HasOne(e => e.WorkStation).WithMany().HasForeignKey(e => e.WorkstationId).HasConstraintName("workstation_id");
            builder.HasOne(e => e.RfidController).WithMany().HasForeignKey(e => e.RfidControllerId).HasConstraintName("rfid_controller_id");
        }
    }


    public class OperatorConfigure : TrackableEntityConfigure<Operator>
    {
        protected override void InternalConfigure(EntityTypeBuilder<Operator> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("operator");
            ImmsDbContext.RegisterEntityTable<Operator>("operator");

            builder.Property(e => e.orgName).HasColumnName("org_name");
            builder.Property(e => e.orgId).HasColumnName("org_id");
            builder.Property(e => e.orgCode).HasColumnName("org_code");
            builder.Property(e => e.EmployeeId).HasColumnName("employee_id");
            builder.Property(e => e.EmployeeName).HasColumnName("employee_name");
            builder.Property(e => e.EmployeeCardNo).HasColumnName("employee_card_no");
        }
    }

    public class WorkshopConfigure : IEntityTypeConfiguration<Workshop>
    {
        public void Configure(EntityTypeBuilder<Workshop> builder)
        {
            ImmsDbContext.RegisterEntityTable<Workshop>("work_organization_unit");
            builder.Ignore(e => e.WorkshopCode);
            builder.Ignore(e => e.WorkshopName);

            builder.Property(e => e.OperationIndex).HasColumnName("operation_index");
            builder.Property(e => e.PrevOperationIndex).HasColumnName("prev_operation_index");
            builder.Property(e => e.WorkshopType).HasColumnName("workshop_type");
        }
    }

    public class WorkstationConfigure : IEntityTypeConfiguration<Workstation>
    {
        public void Configure(EntityTypeBuilder<Workstation> builder)
        {
            ImmsDbContext.RegisterEntityTable<Workstation>("work_organization_unit");

            builder.Ignore(e => e.WorkStaitonCode);
            builder.Ignore(e => e.WorkStationName);

            builder.Property(e => e.RfidControllerId).HasColumnName("rfid_controller_id");
            builder.Property(e => e.RfidTerminatorId).HasColumnName("Rfid_terminator_id");
            builder.Property(e => e.WocgCode).HasColumnName("wocg_code");

            builder.Property(e => e.RfidTemplateIndex).HasColumnName("rfid_template_index");
            builder.Property(e => e.AutoReportCount).HasColumnName("auto_report_count");
            builder.Property(e => e.LocCode).HasColumnName("loc_code");

            builder.HasOne(e => e.RfidController).WithMany().HasForeignKey(e => e.RfidControllerId).HasConstraintName("rfid_controller_id");
        }
    }

    public class WorkOrganizationUnitConfigure : IEntityTypeConfiguration<WorkOrganizationUnit>
    {
        public void Configure(EntityTypeBuilder<WorkOrganizationUnit> builder)
        {
            builder.HasDiscriminator("org_type", typeof(string))
               .HasValue<Workstation>(GlobalConstants.TYPE_ORG_WORK_STATETION)
               .HasValue<Workshop>(GlobalConstants.TYPE_ORG_WORK_SHOP)
               ;
        }
    }
}
