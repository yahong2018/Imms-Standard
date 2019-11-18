using Imms.Data;
using Imms.Data.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Text;

namespace Imms.Mes.Data.Domain
{
    public partial class Material : TrackableEntity<long>
    {
        public string MaterialCode { get; set; }
        public string MaterialName { get; set; }
        public string Description { get; set; }

        public int  AutoFinishedProgress {get;set;}
    }

    public class MaterialStock : TrackableEntity<long>
    {
        public long MaterialId { get; set; }
        public string MaterialCode { get; set; }
        public string MaterialName { get; set; }

        public long StoreId { get; set; }
        public string StoreCode { get; set; }
        public string StoreName { get; set; }

        public int QtyStock { get; set; }
        public int QtyMoveIn { get; set; }
        public int QtyBackIn { get; set; }
        public int QtyBackOut { get; set; }
        public int QtyConsumeGood { get; set; }
        public int QtyConsumeDefect { get; set; }
        public int QtyGood { get; set; }
        public int QtyDefect { get; set; }
        public int QtyMoveOut { get; set; }
    }

    public class Bom : TrackableEntity<long>
    {
        public string BomNo { get; set; }
        public int BomType { get; set; }
        public int BomStatus { get; set; }

        public long MaterialId { get; set; }
        public string MaterialCode { get; set; }
        public string MaterialName { get; set; }

        public long ComponentId { get; set; }
        public string ComponentCode { get; set; }
        public string ComponentName { get; set; }

        public int MaterialQty { get; set; }
        public int ComponentQty { get; set; }       

        public DateTime EffectDate{get;set;}
    }


    public class MaterialConfigure : TrackableEntityConfigure<Material>
    {
        protected override void InternalConfigure(EntityTypeBuilder<Material> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("material");

            ImmsDbContext.RegisterEntityTable<Material>("material");

            builder.Property(e => e.Description).HasColumnName("description").HasMaxLength(250);
            builder.Property(e => e.MaterialName).IsRequired().HasColumnName("material_name").HasMaxLength(50);
            builder.Property(e => e.MaterialCode).IsRequired().HasColumnName("material_code").HasMaxLength(20);
            builder.Property(e => e.AutoFinishedProgress).HasColumnName("auto_finished_progress");            
        }
    }

    public class MaterialStockConfigure : TrackableEntityConfigure<MaterialStock>
    {
        protected override void InternalConfigure(EntityTypeBuilder<MaterialStock> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("material_stock");

            ImmsDbContext.RegisterEntityTable<Material>("material_stock");

            builder.Property(e => e.MaterialId).IsRequired().HasColumnName("material_id");
            builder.Property(e => e.MaterialName).IsRequired().HasColumnName("material_name").HasMaxLength(50);
            builder.Property(e => e.MaterialCode).IsRequired().HasColumnName("material_code").HasMaxLength(20);
            builder.Property(e => e.StoreId).HasColumnName("store_id");
            builder.Property(e => e.StoreCode).HasColumnName("store_code");
            builder.Property(e => e.StoreName).HasColumnName("store_name");

            builder.Property(e => e.QtyStock).HasColumnName("qty_stock");
            builder.Property(e => e.QtyMoveIn).HasColumnName("qty_move_in");
            builder.Property(e => e.QtyBackIn).HasColumnName("qty_back_in");
            builder.Property(e => e.QtyBackOut).HasColumnName("qty_back_out");
            builder.Property(e => e.QtyConsumeGood).HasColumnName("qty_consume_good");
            builder.Property(e => e.QtyConsumeDefect).HasColumnName("qty_consume_defect");
            builder.Property(e => e.QtyGood).HasColumnName("qty_good");
            builder.Property(e => e.QtyDefect).HasColumnName("qty_defect");
            builder.Property(e => e.QtyMoveOut).HasColumnName("qty_move_out");
        }
    }


    public class BomConfigure : TrackableEntityConfigure<Bom>
    {
        protected override void InternalConfigure(EntityTypeBuilder<Bom> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("bom");

            ImmsDbContext.RegisterEntityTable<Material>("bom");

            builder.Property(e => e.BomNo).IsRequired().HasColumnName("bom_no");
            builder.Property(e => e.BomType).IsRequired().HasColumnName("bom_type");
            builder.Property(e => e.BomStatus).IsRequired().HasColumnName("bom_status");

            builder.Property(e => e.MaterialId).IsRequired().HasColumnName("material_id");
            builder.Property(e => e.MaterialName).IsRequired().HasColumnName("material_name").HasMaxLength(50);
            builder.Property(e => e.MaterialCode).IsRequired().HasColumnName("material_code").HasMaxLength(20);

            builder.Property(e => e.ComponentId).HasColumnName("component_id");
            builder.Property(e => e.ComponentCode).HasColumnName("component_code");
            builder.Property(e => e.ComponentName).HasColumnName("component_name");

            builder.Property(e => e.MaterialQty).HasColumnName("material_qty");
            builder.Property(e => e.ComponentQty).HasColumnName("component_qty");

            builder.Property(e=>e.EffectDate).HasColumnName("effect_date");
        }
    }
}
