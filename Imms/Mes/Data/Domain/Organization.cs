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
    }

    public class WorkShop : WorkOrganizationUnit
    {
        public string WorkShopCode { get { return base.OrganizationCode; } set { base.OrganizationCode = value; } }
        public string WorkShopName { get { return base.OrganizationName; } set { base.OrganizationName = value; } }
        public long NextWorkShopId { get; set; }

        public virtual WorkShop NextWorkShop { get; set; }
    }

    public class WorkStation : WorkOrganizationUnit
    {
        public string WorkStaitonCode { get { return base.OrganizationCode; } set { base.OrganizationCode = value; } }
        public string WorkStationName { get { return base.OrganizationName; } set { base.OrganizationName = value; } }

        public int RfidControllerId { get; set; }
        public int RfidTerminatorId { get; set; }

        public virtual RfidController RfidController { get; set; }
    }

    public class WorkstationLogin:Entity<long>
    {
        public int RfidTerminatorId;
        public int RfidControllerGroupId;
        public string RfidCardNo;
        public DateTime LoginTime;
        public long RfidControllerId;
        public long WorkstationId;
        public long RfidCardId;
        public long OperatorId;

        public virtual RfidCard RfidCard{get;set;}
        public virtual Operator Operator{get;set;}
        public virtual WorkStation WorkStation{get;set;}
        public virtual RfidController RfidController{get;set;}
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

            builder.HasOne(e=>e.RfidCard).WithMany().HasForeignKey(e=>e.RfidCardId).HasConstraintName("rfid_card_id");
            builder.HasOne(e=>e.Operator).WithMany().HasForeignKey(e=>e.OperatorId).HasConstraintName("operator_id");
            builder.HasOne(e=>e.WorkStation).WithMany().HasForeignKey(e=>e.WorkstationId).HasConstraintName("workstation_id");
            builder.HasOne(e=>e.RfidController).WithMany().HasForeignKey(e=>e.RfidControllerId).HasConstraintName("rfid_controller_id");
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

    public class WorkShopConfigure : IEntityTypeConfiguration<WorkShop>
    {
        public void Configure(EntityTypeBuilder<WorkShop> builder)
        {
            ImmsDbContext.RegisterEntityTable<WorkShop>("work_organization_unit");
            builder.Ignore(e => e.WorkShopCode);
            builder.Ignore(e => e.WorkShopName);

            builder.Property(e => e.NextWorkShopId).HasColumnName("next_work_shop_id");
            builder.HasOne(e => e.NextWorkShop).WithMany().HasForeignKey(e => e.NextWorkShopId).HasConstraintName("next_work_shop_id");
        }
    }

    public class WorkStationConfigure : IEntityTypeConfiguration<WorkStation>
    {
        public void Configure(EntityTypeBuilder<WorkStation> builder)
        {
            ImmsDbContext.RegisterEntityTable<WorkShop>("work_organization_unit");
            builder.Ignore(e => e.WorkStaitonCode);
            builder.Ignore(e => e.WorkStationName);

            builder.Property(e => e.RfidControllerId).HasColumnName("rfid_controller_id");
            builder.Property(e => e.RfidTerminatorId).HasColumnName("Rfid_terminator_id");
            builder.HasOne(e => e.RfidController).WithMany().HasForeignKey(e => e.RfidControllerId).HasConstraintName("rfid_controller_id");
        }
    }

    public class WorkOrganizationUnitConfigure : IEntityTypeConfiguration<WorkOrganizationUnit>
    {
        public void Configure(EntityTypeBuilder<WorkOrganizationUnit> builder)
        {
            builder.HasDiscriminator("organization_type", typeof(string))
               .HasValue<WorkStation>(GlobalConstants.TYPE_ORG_WORK_STATETION)
               .HasValue<WorkShop>(GlobalConstants.TYPE_ORG_WORK_SHOP)
               ;
        }
    }
}
