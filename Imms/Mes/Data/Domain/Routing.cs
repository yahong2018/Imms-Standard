using Imms.Data;
using Imms.Data.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Text;

namespace Imms.Mes.Data.Domain
{
    public partial class BaseOperation : TrackableEntity<long>
    {
        public string OperationNo { get; set; }
        public string Description { get; set; }

        public long MachineTypeId { get; set; }
        public double? StandardTime { get; set; }
        public double? StandardPrice { get; set; }
        public string SectionType { get; set; }
        public string SectionName { get; set; }
        public bool IsOutsource { get; set; }
        public string QaProcedure { get; set; }
        public string Requirement { get; set; }
        public string RequiredLevel { get; set; }

        public virtual EquipmentType MachineType { get; set; }
    }

    public partial class Operation : BaseOperation
    {
        public virtual List<OperationMedia> Medias { get; set; } = new List<OperationMedia>();
    }

    public class OperationMedia : TrackableEntity<long>
    {
        public long MediaId { get; set; }
        public long OperationId { get; set; }
        public int MediaType { get; set; }

        public virtual Media Media { get; set; }
        public virtual Operation Operation { get; set; }
    }

    public partial class OperationRouting : BaseOperation
    {
        public long OperationRoutingOrderId { get; set; }
        public long OperationId { get; set; }
        public long NextOperationId { get; set; }
        public string NextOpertionNo { get; set; }
        public long? NextRoutingId { get; set; }

        public virtual OperationRoutingOrder RoutingOrder { get; set; }
        public virtual OperationRouting NextRouting { get; set; }
        public virtual List<OperationRouting> PrevOpreatons { get; set; } = new List<OperationRouting>();

        public virtual Operation Operation { get; set; }
    }

    public partial class OperationRoutingOrder : OrderEntity<long>
    {
        public int OrderType { get; set; }
        public long MaterialId { get; set; }

        public virtual Material Material { get; set; }
        public virtual List<OperationRouting> Routings { get; set; } = new List<OperationRouting>();
    }

    public class BaseOperationConfigure<E> : TrackableEntityConfigure<E> where E : BaseOperation
    {
        protected override void InternalConfigure(EntityTypeBuilder<E> builder)
        {
            base.InternalConfigure(builder);
            
            builder.Property(e => e.OperationNo).IsRequired().HasColumnName("operation_no").HasMaxLength(20).IsUnicode(false);
            builder.Property(e => e.Description).IsRequired().HasColumnName("description").HasMaxLength(3000).IsUnicode(false);
            builder.Property(e => e.MachineTypeId).HasColumnName("machine_type_id").HasColumnType("bigint(20)");
            builder.Property(e => e.IsOutsource).HasColumnName("is_outsource").HasColumnType("bit(1)");
            builder.Property(e => e.QaProcedure).HasColumnName("qa_procedure").HasMaxLength(1000).IsUnicode(false);
            builder.Property(e => e.SectionName).HasColumnName("section_name").HasMaxLength(30).IsUnicode(false);
            builder.Property(e => e.SectionType).HasColumnName("section_type").HasMaxLength(12).IsUnicode(false);
            builder.Property(e => e.Requirement).HasColumnName("requirement").HasMaxLength(1000).IsUnicode(false);
            builder.Property(e => e.RequiredLevel).HasColumnName("required_level");
            builder.Property(e => e.StandardPrice).HasColumnName("standard_price").HasColumnType("double(8,4)");
            builder.Property(e => e.StandardTime).HasColumnName("standard_time").HasColumnType("double(8,4)");

            builder.HasOne(e => e.MachineType).WithMany().HasForeignKey(e => e.MachineTypeId);
        }
    }

    public class OperationConfigure : BaseOperationConfigure<Operation>
    {
        protected override void InternalConfigure(EntityTypeBuilder<Operation> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("operation");
            ImmsDbContext.RegisterEntityTable<Operation>("operation");

            builder.HasMany(e => e.Medias).WithOne(e => e.Operation).HasForeignKey(e => e.OperationId);
        }
    }

    public class OpetaionMediaConfigure : TrackableEntityConfigure<OperationMedia>
    {
        protected override void InternalConfigure(EntityTypeBuilder<OperationMedia> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("operation_media");
            ImmsDbContext.RegisterEntityTable<OperationMedia>("operation_media");

            builder.Property(e => e.MediaId).HasColumnName("media_id");
            builder.Property(e => e.OperationId).HasColumnName("operation_id");
            builder.Property(e => e.MediaType).HasColumnName("media_type");

            builder.HasOne(e => e.Media).WithMany().HasForeignKey(e => e.MediaId);
        }
    }

    public class OperationRoutingConfigure : BaseOperationConfigure<OperationRouting>
    {
        protected override void InternalConfigure(EntityTypeBuilder<OperationRouting> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("operation_routing");
            ImmsDbContext.RegisterEntityTable<OperationRouting>("operation_routing");

            builder.Property(e => e.OperationId).HasColumnName("operation_id").HasColumnType("bigint(20)");
            builder.Property(e => e.OperationRoutingOrderId).HasColumnName("operation_routing_order_id").HasColumnType("bigint(20)");
            builder.Property(e => e.NextRoutingId).HasColumnName("next_routing_id").HasColumnType("int(11)");
            builder.Property(e => e.NextOperationId).HasColumnName("next_operation_id");
            builder.Property(e => e.NextOpertionNo).HasColumnName("next_operation_no").HasColumnType("varchar(20)");

            builder.HasOne(e => e.RoutingOrder).WithMany(e => e.Routings).HasForeignKey(e => e.OperationRoutingOrderId);
            builder.HasOne(e => e.NextRouting).WithMany(e => e.PrevOpreatons).HasForeignKey(e => e.NextRoutingId);
            builder.HasOne(e => e.Operation).WithMany().HasForeignKey(e => e.OperationId);
        }
    }

    public class OperationRoutingOrderConfigure : OrderEntityConfigure<OperationRoutingOrder>
    {
        protected override void InternalConfigure(EntityTypeBuilder<OperationRoutingOrder> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("operation_routing_order");
            ImmsDbContext.RegisterEntityTable<OperationRoutingOrder>("operation_routing_order");

            builder.Property(e => e.MaterialId).HasColumnName("material_id").HasColumnType("bigint(20)");
            builder.Property(e => e.OrderType).HasColumnName("order_type").HasColumnType("int(11)");

            builder.HasOne(e => e.Material).WithMany().HasForeignKey(e => e.MaterialId);
            builder.HasMany(e => e.Routings).WithOne(e => e.RoutingOrder).HasForeignKey(e => e.OperationRoutingOrderId);
        }
    }
}
