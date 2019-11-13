using System;
using System.Collections.Generic;
using Imms.Data;
using Imms.Data.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Imms.Mes.Data.Domain
{
    public partial class ProductionOrder : OrderEntity<long>
    {
        public long ProductionId { get; set; }
        public string ProductionCode { get; set; }
        public string ProductionName { get; set; }

        // public long WorkshopId { get; set; }
        // public string WorkshopCode { get; set; }
        // public string WorkshopName { get; set; }

        public DateTime PlanDate { get; set; }  //计划生产日期

        public int QtyPlanned { get; set; }
        public int QtyGood { get; set; }
        public int QtyBad { get; set; }

        public virtual Material Production { get; set; }
        // public virtual Workshop Workshop { get; set; }
        public virtual List<QualityCheck> QualityChecks { get; set; } = new List<QualityCheck>();
        public virtual List<ProductionOrderProgress> Progresses { get; set; } = new List<ProductionOrderProgress>();
    }

    public class ProductionOrderProgress : TrackableEntity<long>
    {
        public long ProductionOrderId { get; set; }
        public string ProductionOrderNo { get; set; }

        public long WorkshopId { get; set; }
        public string WorkshopCode { get; set; }
        public string WorkshopName { get; set; }

        public long WorkstationId { get; set; }
        public string WorkstationCode { get; set; }
        public string WorkstationName { get; set; }
        public string WocgCode { get; set; }

        public long RfidTerminatorId { get; set; }
        public long RfidControllerId { get; set; }

        public long ProductionId { get; set; }
        public string ProductionCode { get; set; }
        public string ProductionName { get; set; }

        public DateTime TimeOfOrigin { get; set; }
        public DateTime TimeOfOriginWork { get; set; }
        public int ShiftId { get; set; }

        public int Qty { get; set; }
        public string RfidCardNo { get; set; }
        public int ReportType { get; set; }

        public long OperatorId { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }

        public string Remark { get; set; }

        public virtual Material Production { get; set; }
        public virtual Workstation Workstation { get; set; }
        public virtual Workshop Workshop { get; set; }
        public virtual ProductionOrder ProductionOrder { get; set; }
    }

    public class ProductSummary : Entity<long>
    {
        public DateTime ProductDate { get; set; }
        public long WorkshopId { get; set; }
        public string WorkshopCode { get; set; }
        public string WorkshopName { get; set; }
        public long ProductionId { get; set; }
        public string ProductionCode { get; set; }
        public string ProductionName { get; set; }
        public int QtyGood_0 { get; set; }
        public int QtyDefect_0 { get; set; }
        public int QtyGood_1 { get; set; }
        public int QtyDefect_1 { get; set; }
    }


    public class Defect : Entity<long>
    {
        public string DefectCode { get; set; }
        public string DefectName { get; set; }
    }

    public class QualityCheck : TrackableEntity<long>
    {
        public long ProductionOrderId { get; set; }
        public string ProductionOrderNo { get; set; }

        public long ProductionId { get; set; }
        public string ProductionCode { get; set; }
        public string ProductionName { get; set; }

        public long WorkshopId { get; set; }
        public string WorkshopCode { get; set; }
        public string WorkshopName { get; set; }

        public long DefectId { get; set; }
        public string DefectCode { get; set; }
        public string DefectName { get; set; }

        public DateTime TimeOfOrigin { get; set; }
        public DateTime TimeOfOriginWork { get; set; }
        public int ShiftId { get; set; }

        public int Qty { get; set; }
        public string WocgCode { get; set; }

        public virtual ProductionOrder ProductionOrder { get; set; }
        public virtual Material Production { get; set; }
    }

    public class ProductionMoving : TrackableEntity<long>
    {
        public long ProductionOrderId { get; set; }
        public string ProductionOrderNo { get; set; }

        public long ProductionId { get; set; }
        public string ProductionCode { get; set; }
        public string ProductionName { get; set; }

        public long RfidCardId { get; set; }
        public string RfidNo { get; set; }

        public int RfidTerminatorId { get; set; }
        public int RfidControllerGroupId { get; set; }

        public int Qty { get; set; }

        public long OperatorId { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }

        public DateTime TimeOfOrigin { get; set; }
        public DateTime TimeOfOriginWork { get; set; }
        public int ShiftId { get; set; }

        public long WorkstationId { get; set; }
        public string WorkstationCode { get; set; }
        public string WorkstationName { get; set; }

        public long WorkshopId { get; set; }
        public string WorkshopCode { get; set; }
        public string WorkshopName { get; set; }

        public long WorkshopIdFrom { get; set; }
        public string WorkshopCodeFrom { get; set; }
        public string WorkshopNameFrom { get; set; }

        public long OperatorIdFrom { get; set; }
        public string EmployeeIdFrom { get; set; }
        public string EmployeeNameFrom { get; set; }

        public long PrevProgressRecordId { get; set; }

        public virtual RfidCard RfidCard { get; set; }
        public virtual ProductionOrder ProductionOrder { get; set; }
        public virtual Material Production { get; set; }
        public virtual Workshop Workshop { get; set; }
        public virtual Workstation Workstation { get; set; }
        public virtual Operator Operator { get; set; }
    }

    public class ProductionMovingConfigure : TrackableEntityConfigure<ProductionMoving>
    {
        protected override void InternalConfigure(EntityTypeBuilder<ProductionMoving> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("production_moving");
            ImmsDbContext.RegisterEntityTable<ProductionOrder>("production_moving");

            builder.Property(e => e.ProductionOrderId).HasColumnName("production_order_id");
            builder.Property(e => e.ProductionOrderNo).HasColumnName("production_order_no");

            builder.Property(e => e.ProductionId).HasColumnName("production_id");
            builder.Property(e => e.ProductionCode).HasColumnName("production_code");
            builder.Property(e => e.ProductionName).HasColumnName("production_name");

            builder.Property(e => e.RfidCardId).HasColumnName("rfid_card_id");
            builder.Property(e => e.RfidNo).HasColumnName("rfid_no");

            builder.Property(e => e.RfidTerminatorId).HasColumnName("rfid_terminator_id");
            builder.Property(e => e.RfidControllerGroupId).HasColumnName("rfid_controller_group_id");

            builder.Property(e => e.Qty).HasColumnName("qty");

            builder.Property(e => e.OperatorId).HasColumnName("operator_id");
            builder.Property(e => e.EmployeeId).HasColumnName("employee_id");
            builder.Property(e => e.EmployeeName).HasColumnName("employee_name");

            builder.Property(e => e.TimeOfOrigin).HasColumnName("time_of_origin");
            builder.Property(e => e.TimeOfOriginWork).HasColumnName("time_of_origin_work");
            builder.Property(e => e.ShiftId).HasColumnName("shift_id");

            builder.Property(e => e.WorkstationId).HasColumnName("workstation_id");
            builder.Property(e => e.WorkstationCode).HasColumnName("workstation_code");
            builder.Property(e => e.WorkstationName).HasColumnName("workstation_name");

            builder.Property(e => e.WorkshopId).HasColumnName("workshop_id");
            builder.Property(e => e.WorkshopCode).HasColumnName("workshop_code");
            builder.Property(e => e.WorkshopName).HasColumnName("workshop_name");

            builder.Property(e => e.WorkshopIdFrom).HasColumnName("workshop_id_from");
            builder.Property(e => e.WorkshopCodeFrom).HasColumnName("workshop_code_from");
            builder.Property(e => e.WorkshopNameFrom).HasColumnName("workshop_name_from");

            builder.Property(e => e.OperatorIdFrom).HasColumnName("operator_id_from");
            builder.Property(e => e.EmployeeIdFrom).HasColumnName("employee_id_from");
            builder.Property(e => e.EmployeeNameFrom).HasColumnName("employee_name_from");

            builder.Property(e => e.PrevProgressRecordId).HasColumnName("prev_progress_record_id");

            builder.HasOne(e => e.RfidCard).WithMany().HasForeignKey(e => e.RfidCardId).HasConstraintName("rfid_card_id");
            builder.HasOne(e => e.ProductionOrder).WithMany().HasForeignKey(e => e.ProductionOrderId).HasConstraintName("production_order_id");
            builder.HasOne(e => e.Production).WithMany().HasForeignKey(e => e.ProductionId).HasConstraintName("production_id");
            builder.HasOne(e => e.Workshop).WithMany().HasForeignKey(e => e.WorkshopId).HasConstraintName("workshop_id");
            builder.HasOne(e => e.Workstation).WithMany().HasForeignKey(e => e.WorkstationId).HasConstraintName("workstation_id");
            builder.HasOne(e => e.Operator).WithMany().HasForeignKey(e => e.OperatorId).HasConstraintName("operator_id");
        }
    }

    public class ProductionOrderProgressConfigure : TrackableEntityConfigure<ProductionOrderProgress>
    {
        protected override void InternalConfigure(EntityTypeBuilder<ProductionOrderProgress> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("production_order_progress");
            ImmsDbContext.RegisterEntityTable<ProductionOrder>("production_order_progress");

            builder.Property(e => e.ProductionOrderId).HasColumnName("production_order_id");
            builder.Property(e => e.ProductionOrderNo).HasColumnName("production_order_no");

            builder.Property(e => e.WorkshopId).HasColumnName("workshop_id");
            builder.Property(e => e.WorkshopCode).HasColumnName("workshop_code");
            builder.Property(e => e.WorkshopName).HasColumnName("workshop_name");

            builder.Property(e => e.WorkstationId).HasColumnName("workstation_id");
            builder.Property(e => e.WorkstationCode).HasColumnName("workstation_code");
            builder.Property(e => e.WorkstationName).HasColumnName("workstation_name");

            builder.Property(e => e.ProductionId).HasColumnName("production_id");
            builder.Property(e => e.ProductionCode).HasColumnName("production_code");
            builder.Property(e => e.ProductionName).HasColumnName("production_name");

            builder.Property(e => e.RfidTerminatorId).HasColumnName("rfid_terminator_id");
            builder.Property(e => e.RfidControllerId).HasColumnName("rfid_controller_id");

            builder.Property(e => e.TimeOfOrigin).HasColumnName("time_of_origin");
            builder.Property(e => e.TimeOfOriginWork).HasColumnName("time_of_origin_work");
            builder.Property(e => e.ShiftId).HasColumnName("shift_id");

            builder.Property(e => e.Qty).HasColumnName("qty");
            builder.Property(e => e.RfidCardNo).HasColumnName("rfid_card_no");
            builder.Property(e => e.ReportType).HasColumnName("report_type");

            builder.Property(e => e.OperatorId).HasColumnName("operator_id");
            builder.Property(e => e.EmployeeId).HasColumnName("employee_id");
            builder.Property(e => e.EmployeeName).HasColumnName("employee_name");
            builder.Property(e => e.WocgCode).HasColumnName("wocg_code");

            builder.HasOne(e => e.Production).WithMany().HasForeignKey(e => e.ProductionId).HasConstraintName("production_id");
            builder.HasOne(e => e.Workstation).WithMany().HasForeignKey(e => e.WorkstationId).HasConstraintName("workstation_id");
            builder.HasOne(e => e.Workshop).WithMany().HasForeignKey(e => e.WorkshopId).HasConstraintName("workshop_id");
        }
    }

    public class ProductSummaryConfigure : EntityConfigure<ProductSummary>
    {
        protected override void InternalConfigure(EntityTypeBuilder<ProductSummary> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("product_summary");
            ImmsDbContext.RegisterEntityTable<ProductionOrder>("product_summary");

            builder.Property(e => e.ProductDate).HasColumnName("product_date");

            builder.Property(e => e.WorkshopId).HasColumnName("workshop_id");
            builder.Property(e => e.WorkshopCode).HasColumnName("workshop_code");
            builder.Property(e => e.WorkshopName).HasColumnName("workshop_name");

            builder.Property(e => e.ProductionId).HasColumnName("production_id");
            builder.Property(e => e.ProductionCode).HasColumnName("production_code");
            builder.Property(e => e.ProductionName).HasColumnName("production_name");

            builder.Property(e => e.QtyGood_0).HasColumnName("qty_good_0");
            builder.Property(e => e.QtyDefect_0).HasColumnName("qty_defect_0");

            builder.Property(e => e.QtyGood_1).HasColumnName("qty_good_1");
            builder.Property(e => e.QtyDefect_1).HasColumnName("qty_defect_1");
        }
    }

    public class ProductionOrderConfigure : OrderEntityConfigure<ProductionOrder>
    {
        protected override void InternalConfigure(EntityTypeBuilder<ProductionOrder> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("production_order");
            ImmsDbContext.RegisterEntityTable<ProductionOrder>("production_order");

            builder.Property(e => e.ProductionId).HasColumnName("production_id");
            builder.Property(e => e.ProductionCode).HasColumnName("production_code");
            builder.Property(e => e.ProductionName).HasColumnName("production_name");

            // builder.Property(e => e.WorkshopId).HasColumnName("workshop_id").HasColumnType("bigint(20)");
            // builder.Property(e => e.WorkshopCode).HasColumnName("workshop_code");
            // builder.Property(e => e.WorkshopName).HasColumnName("workshop_name");

            builder.Property(e => e.PlanDate).HasColumnName("plan_date");

            builder.Property(e => e.QtyPlanned).HasColumnName("qty_planned").HasColumnType("int(11)");
            builder.Property(e => e.QtyGood).HasColumnName("qty_good").HasColumnType("int(11)");
            builder.Property(e => e.QtyBad).HasColumnName("qty_bad").HasColumnType("int(11)");

            builder.HasOne(e => e.Production).WithMany().HasForeignKey(e => e.ProductionId).HasConstraintName("production_id");
            // builder.HasOne(e => e.Workshop).WithMany().HasForeignKey(e => e.WorkshopId).HasConstraintName("workshop_id");
            builder.HasMany(e => e.QualityChecks).WithOne(e => e.ProductionOrder).HasForeignKey(e => e.ProductionOrderId).HasConstraintName("production_order_id");
            builder.HasMany(e => e.Progresses).WithOne(e => e.ProductionOrder).HasForeignKey(e => e.ProductionOrderId).HasConstraintName("production_order_id");
        }
    }

    public class DefectConfigure : EntityConfigure<Defect>
    {
        protected override void InternalConfigure(EntityTypeBuilder<Defect> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("defect");
            ImmsDbContext.RegisterEntityTable<Defect>("defect");

            builder.Property(e => e.DefectCode).HasColumnName("defect_code");
            builder.Property(e => e.DefectName).HasColumnName("defect_name");

        }
    }

    public class QualityCheckConfigure : TrackableEntityConfigure<QualityCheck>
    {
        protected override void InternalConfigure(EntityTypeBuilder<QualityCheck> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("quality_check");
            ImmsDbContext.RegisterEntityTable<ProductionOrder>("quality_check");

            builder.Property(e => e.ProductionOrderId).HasColumnName("production_order_id");
            builder.Property(e => e.ProductionOrderNo).HasColumnName("production_order_no");

            builder.Property(e => e.ProductionId).HasColumnName("production_id");
            builder.Property(e => e.ProductionCode).HasColumnName("production_code");
            builder.Property(e => e.ProductionName).HasColumnName("production_name");

            builder.Property(e => e.TimeOfOrigin).HasColumnName("time_of_origin");
            builder.Property(e => e.TimeOfOriginWork).HasColumnName("time_of_origin_work");
            builder.Property(e => e.ShiftId).HasColumnName("shift_id");

            builder.Property(e => e.WorkshopId).HasColumnName("workshop_id");
            builder.Property(e => e.WorkshopCode).HasColumnName("workshop_code");
            builder.Property(e => e.WorkshopName).HasColumnName("workshop_name");

            builder.Property(e => e.DefectId).HasColumnName("defect_id");
            builder.Property(e => e.DefectCode).HasColumnName("defect_code");
            builder.Property(e => e.DefectName).HasColumnName("defect_name");
            builder.Property(e => e.Qty).HasColumnName("qty");
            builder.Property(e => e.WocgCode).HasColumnName("wocg_code");

            builder.HasOne(e => e.ProductionOrder).WithMany(e => e.QualityChecks).HasForeignKey(e => e.ProductionOrderId).HasConstraintName("production_order_id");
            builder.HasOne(e => e.Production).WithMany().HasForeignKey(e => e.ProductionId).HasConstraintName("production_id");
        }
    }

}