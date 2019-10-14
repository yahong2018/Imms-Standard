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

        public long FirstWorkshopId{get;set;}
        public string FirstWorkshopCode{get;set;}
        public string FirstWorkshopName{get;set;}
    }
  

    public class MaterialConfigure : TrackableEntityConfigure<Material>
    {
        protected override void InternalConfigure(EntityTypeBuilder<Material> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("material");

            ImmsDbContext.RegisterEntityTable<Material>("material");
            
            builder.Property(e => e.Description).HasColumnName("description").HasMaxLength(250).IsUnicode(false);
            builder.Property(e => e.MaterialName).IsRequired().HasColumnName("material_name").HasMaxLength(50).IsUnicode(false);
            builder.Property(e => e.MaterialCode).IsRequired().HasColumnName("material_code").HasMaxLength(20).IsUnicode(false);      

            builder.Property(e=>e.FirstWorkshopId).IsRequired().HasColumnName("first_workshop_id");
            builder.Property(e=>e.FirstWorkshopCode).IsRequired().HasColumnName("first_workshop_code");
            builder.Property(e=>e.FirstWorkshopName).IsRequired().HasColumnName("first_workshop_name");      
        }
    }
}
