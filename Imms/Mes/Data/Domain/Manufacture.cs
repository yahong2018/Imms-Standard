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
        public long WorkShopId { get; set; }
        public int QtyPlanned { get; set; }
        public int QtyFinished { get; set; }
        public int QtySecondQuality { get; set; }
        public int QtyDefect { get; set; }
        public int QtyActual { get; set; }

        public virtual Material Production { get; set; }
        public virtual WorkShop WorkShop { get; set; }
        public virtual List<QualityCheck> QualityChecks { get; set; } = new List<QualityCheck>();
        public virtual List<ProductionOrderProgress> Progresses { get; set; } = new List<ProductionOrderProgress>();
    }

    public class ProductionOrderConfigure : OrderEntityConfigure<ProductionOrder>
    {
        protected override void InternalConfigure(EntityTypeBuilder<ProductionOrder> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("production_order");
            ImmsDbContext.RegisterEntityTable<ProductionOrder>("production_order");

            builder.Property(e => e.ProductionId).HasColumnName("production_id");
            builder.Property(e => e.WorkShopId).HasColumnName("work_shop_id").HasColumnType("bigint(20)");
            builder.Property(e => e.QtyPlanned).HasColumnName("qty_planned").HasColumnType("int(11)");
            builder.Property(e => e.QtyActual).HasColumnName("qty_actual").HasColumnType("int(11)");
            builder.Property(e => e.QtyFinished).HasColumnName("qty_finished").HasColumnType("int(11)");
            builder.Property(e => e.QtySecondQuality).HasColumnName("qty_second_quality").HasColumnType("int(11)");
            builder.Property(e => e.QtyDefect).HasColumnName("qty_defect").HasColumnType("int(11)");

            builder.HasOne(e => e.Production).WithMany().HasForeignKey(e => e.ProductionId).HasConstraintName("production_id");
            builder.HasOne(e => e.WorkShop).WithMany().HasForeignKey(e => e.WorkShopId).HasConstraintName("work_shop_id");
            builder.HasMany(e => e.QualityChecks).WithOne(e => e.ProductionOrder).HasForeignKey(e => e.ProductionOrderId).HasConstraintName("production_order_id");
            builder.HasMany(e => e.Progresses).WithOne(e => e.ProductionOrder).HasForeignKey(e => e.ProductionOrderId).HasConstraintName("production_order_id");
        }
    }


    public class ProductionOrderProgress : TrackableEntity<long>
    {
        public long ProductionOrderId { get; set; }
        public long OperationId { get; set; }
        public long RfidTerminatorId { get; set; }
        public long RfidControllerId { get; set; }
        public long ProductionId { get; set; }
        public DateTime ReportTime { get; set; }
        public int ReportQty { get; set; }
        public string RfidCardNo { get; set; }
        public int ReportType { get; set; }
        public long WorkStationId { get; set; }
        public long WorkShopId { get; set; }

        public virtual Operation Operation { get; set; }
        public virtual Material Production { get; set; }
        public virtual WorkStation WorkStation { get; set; }
        public virtual WorkShop WorkShop { get; set; }
        public virtual ProductionOrder ProductionOrder { get; set; }
    }

    public class ProductionOrderProgressConfigure : OrderEntityConfigure<ProductionOrderProgress>
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
            builder.Property(e => e.ReportQty).HasColumnName("report_qty");
            builder.Property(e => e.RfidCardNo).HasColumnName("rfid_card_no");
            builder.Property(e => e.ReportType).HasColumnName("report_type");
            builder.Property(e => e.WorkStationId).HasColumnName("work_station_id");
            builder.Property(e => e.WorkShopId).HasColumnName("work_shop_id");

            builder.HasOne(e => e.Operation).WithMany().HasForeignKey(e => e.OperationId).HasConstraintName("operation_id");
            builder.HasOne(e => e.Production).WithMany().HasForeignKey(e => e.ProductionId).HasConstraintName("production_id");
            builder.HasOne(e => e.WorkStation).WithMany().HasForeignKey(e => e.WorkStationId).HasConstraintName("work_station_id");
            builder.HasOne(e => e.WorkShop).WithMany().HasForeignKey(e => e.WorkShopId).HasConstraintName("work_shop_id");
        }
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
            builder.HasOne(e=>e.Production).WithMany().HasForeignKey(e=>e.ProductionId).HasConstraintName("production_id");
            builder.HasOne(e=>e.Discover).WithMany().HasForeignKey(e=>e.DiscoverId).HasConstraintName("discover_id");
            builder.HasOne(e=>e.Producer).WithMany().HasForeignKey(e=>e.ProducerId).HasConstraintName("producer_id");
            builder.HasOne(e=>e.Responser).WithMany().HasForeignKey(e=>e.ResponseId).HasConstraintName("response_id");
        }
    }

}