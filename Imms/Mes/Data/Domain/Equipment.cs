using Imms.Data;
using Imms.Data.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Text;

namespace Imms.Mes.Data.Domain
{
    public class Equipment : TrackableEntity<long>
    {
        public string EquipmentNo { get; set; }
        public string EquipmentName { get; set; }
        public string Description { get; set; }
        public int Status { get; set; }
        public long EquipmentTypeId { get; set; }

        public virtual EquipmentType EquipmentType { get; set; }
    }

    public class EquipmentConfigure : EntityConfigure<Equipment>
    {
        protected override void InternalConfigure(EntityTypeBuilder<Equipment> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("equipment");

            builder.Property(e => e.EquipmentNo).HasColumnName("equipment_no");
            builder.Property(e => e.EquipmentName).HasColumnName("equipment_name");
            builder.Property(e => e.Description).HasColumnName("description");
            builder.Property(e => e.Status).HasColumnName("status");
            builder.Property(e => e.EquipmentTypeId).HasColumnName("equipment_type_id");
            builder.HasOne(e => e.EquipmentType).WithMany().HasForeignKey(e => e.EquipmentTypeId).HasConstraintName("equipment_type_id");
        }
    }

   
}
