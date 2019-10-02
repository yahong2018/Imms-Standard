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
        public long WorkshopId { get; set; }
        public int QtyPlanned { get; set; }
        public int QtyGood { get; set; }
        public int QtyBad { get; set; }        

        public virtual Material Production { get; set; }
        public virtual Workshop Workshop { get; set; }
        public virtual List<QualityCheck> QualityChecks { get; set; } = new List<QualityCheck>();
        public virtual List<ProductionOrderProgress> Progresses { get; set; } = new List<ProductionOrderProgress>();
    }

    public class ProductionOrderProgress : TrackableEntity<long>
    {
        public long ProductionOrderId { get; set; }
        public long OperationId { get; set; }
        public long RfidTerminatorId { get; set; }
        public long RfidControllerId { get; set; }
        public long ProductionId { get; set; }
        public DateTime ReportTime { get; set; }
        public int GoodQty { get; set; }
        public int BadQty { get; set; }
        public string RfidCardNo { get; set; }
        public int ReportType { get; set; }
        public long WorkstationId { get; set; }
        public long WorkshopId { get; set; }

        public virtual Material Production { get; set; }
        public virtual Workstation Workstation { get; set; }
        public virtual Workshop Workshop { get; set; }
        public virtual ProductionOrder ProductionOrder { get; set; }
    }

    public class QualityCheck : TrackableEntity<long>
    {
        public long ProductionOrderId { get; set; }
        public long ProductionId { get; set; }

        public long DiscoverId { get; set; }
        public DateTime DiscoverTime { get; set; }

        public long ProducerId { get; set; }
        public DateTime ProduceTime { get; set; }

        public long ResponseId { get; set; }

        public string DefectTypeId { get; set; }

        public string DefectDescription { get; set; }

        public virtual ProductionOrder ProductionOrder { get; set; }
        public virtual Material Production { get; set; }
        public virtual Operator Discover { get; set; }
        public virtual Operator Producer { get; set; }
        public virtual Operator Responser { get; set; }
    }

    public class ProductionMoving : TrackableEntity<long>
    {
        public string RfidNo { get; set; }
        public long RfidCardId { get; set; }
        public int RfidTerminatorId { get; set; }
        public int RfidControllerGroupId { get; set; }

        public long ProductionOrderId { get; set; }
        public long ProductionId { get; set; }
        public int Qty { get; set; }

        public long OperatorId { get; set; }
        public DateTime MovingTime { get; set; }

        public long WorkstationId { get; set; }
        public long WorkshopId { get; set; }
        public long PrevWorkshopId { get; set; }
        public long PrevWorkstationId { get; set; }

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

            builder.Property(e => e.RfidNo).HasColumnName("rfid_no");
            builder.Property(e => e.RfidCardId).HasColumnName("rfid_card_id");
            builder.Property(e => e.RfidTerminatorId).HasColumnName("rfid_terminator_id");
            builder.Property(e => e.RfidControllerGroupId).HasColumnName("rfid_controller_group_id");

            builder.Property(e => e.ProductionOrderId).HasColumnName("production_order_id");
            builder.Property(e => e.ProductionId).HasColumnName("production_id");
            builder.Property(e => e.Qty).HasColumnName("qty");

            builder.Property(e => e.OperatorId).HasColumnName("operator_id");
            builder.Property(e => e.MovingTime).HasColumnName("moving_time");

            builder.Property(e => e.WorkstationId).HasColumnName("workstation_id");
            builder.Property(e => e.WorkshopId).HasColumnName("workshop_id");
            builder.Property(e => e.PrevWorkshopId).HasColumnName("prev_workshop_id");
            builder.Property(e => e.PrevWorkstationId).HasColumnName("prev_workstation_id");

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
            builder.Property(e => e.OperationId).HasColumnName("operation_id");
            builder.Property(e => e.RfidTerminatorId).HasColumnName("rfid_terminator_id");
            builder.Property(e => e.RfidControllerId).HasColumnName("rfid_controller_id");
            builder.Property(e => e.ProductionId).HasColumnName("production_id");
            builder.Property(e => e.ReportTime).HasColumnName("report_time");
            builder.Property(e => e.GoodQty).HasColumnName("good_qty");
            builder.Property(e => e.BadQty).HasColumnName("bad_qty");
            builder.Property(e => e.RfidCardNo).HasColumnName("rfid_card_no");
            builder.Property(e => e.ReportType).HasColumnName("report_type");
            builder.Property(e => e.WorkstationId).HasColumnName("workstation_id");
            builder.Property(e => e.WorkshopId).HasColumnName("workshop_id");

            builder.HasOne(e => e.Production).WithMany().HasForeignKey(e => e.ProductionId).HasConstraintName("production_id");
            builder.HasOne(e => e.Workstation).WithMany().HasForeignKey(e => e.WorkstationId).HasConstraintName("workstation_id");
            builder.HasOne(e => e.Workshop).WithMany().HasForeignKey(e => e.WorkshopId).HasConstraintName("workshop_id");
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
            builder.Property(e => e.WorkshopId).HasColumnName("workshop_id").HasColumnType("bigint(20)");
            builder.Property(e => e.QtyPlanned).HasColumnName("qty_planned").HasColumnType("int(11)");            
            builder.Property(e => e.QtyGood).HasColumnName("qty_finished").HasColumnType("int(11)");
            builder.Property(e => e.QtyBad).HasColumnName("qty_second_quality").HasColumnType("int(11)");            

            builder.HasOne(e => e.Production).WithMany().HasForeignKey(e => e.ProductionId).HasConstraintName("production_id");
            builder.HasOne(e => e.Workshop).WithMany().HasForeignKey(e => e.WorkshopId).HasConstraintName("workshop_id");
            builder.HasMany(e => e.QualityChecks).WithOne(e => e.ProductionOrder).HasForeignKey(e => e.ProductionOrderId).HasConstraintName("production_order_id");
            builder.HasMany(e => e.Progresses).WithOne(e => e.ProductionOrder).HasForeignKey(e => e.ProductionOrderId).HasConstraintName("production_order_id");
        }
    }

    public class QualityCheckConfigure : OrderEntityConfigure<QualityCheck>
    {
        protected override void InternalConfigure(EntityTypeBuilder<QualityCheck> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("quality_check");
            ImmsDbContext.RegisterEntityTable<ProductionOrder>("quality_check");

            builder.Property(e => e.ProductionOrderId).HasColumnName("production_order_id");
            builder.Property(e => e.ProductionId).HasColumnName("production_id");
            builder.Property(e => e.DiscoverId).HasColumnName("discover_id");
            builder.Property(e => e.DiscoverTime).HasColumnName("discover_time");
            builder.Property(e => e.ProducerId).HasColumnName("producer_id");
            builder.Property(e => e.ProduceTime).HasColumnName("produce_time");
            builder.Property(e => e.ResponseId).HasColumnName("response_id");
            builder.Property(e => e.DefectTypeId).HasColumnName("defect_type_id");
            builder.Property(e => e.DefectDescription).HasColumnName("defect_description");

            builder.HasOne(e => e.ProductionOrder).WithMany().HasForeignKey(e => e.ProductionOrderId).HasConstraintName("production_order_id");
            builder.HasOne(e => e.Production).WithMany().HasForeignKey(e => e.ProductionId).HasConstraintName("production_id");
            builder.HasOne(e => e.Discover).WithMany().HasForeignKey(e => e.DiscoverId).HasConstraintName("discover_id");
            builder.HasOne(e => e.Producer).WithMany().HasForeignKey(e => e.ProducerId).HasConstraintName("producer_id");
            builder.HasOne(e => e.Responser).WithMany().HasForeignKey(e => e.ResponseId).HasConstraintName("response_id");
        }
    }

}