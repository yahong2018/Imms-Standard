using Imms.Data;
using Imms.Data.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Text;

namespace Imms.Mes.Data.Domain
{
    public class EquipmentType : SimpleCode
    {
        public string EquipmentTypeNo { get { return base.CodeNo; } set { base.CodeNo = value; } }
        public string EquipmentTypeName { get { return base.CodeName; } set { base.CodeName = value; } }
    }

    public class MaterialType : SimpleCode
    {
        public string MaterialTypeCode { get { return base.CodeNo; } set { base.CodeNo = value; } }
        public string MaterialTypeName { get { return base.CodeName; } set { base.CodeName = value; } }
    }

    public class EquipmentTypeCofigure : IEntityTypeConfiguration<EquipmentType>
    {
        public void Configure(EntityTypeBuilder<EquipmentType> builder)
        {
            ImmsDbContext.RegisterEntityTable<EquipmentType>("simple_code");

            builder.Ignore(e => e.EquipmentTypeNo);
            builder.Ignore(e => e.EquipmentTypeName);
        }
    }

    public class MaterialTypeConfigure : IEntityTypeConfiguration<MaterialType>
    {
        public void Configure(EntityTypeBuilder<MaterialType> builder)
        {
            ImmsDbContext.RegisterEntityTable<MaterialType>("simple_code");

            builder.Ignore(e => e.MaterialTypeCode);
            builder.Ignore(e => e.MaterialTypeName);

            builder.HasDiscriminator("code_type", typeof(string))
                .HasValue<EquipmentType>(GlobalConstants.TYPE_CODE_TYPE_EQUIPMENT_TYPE)
                .HasValue<MaterialType>(GlobalConstants.TYPE_CODE_TYPE_MATERIAL_TYPE)
                ;
        }
    }

    // public class MaterialTypeCofigure : IEntityTypeConfiguration<MaterialType>
    // {
    //     public void Configure(EntityTypeBuilder<MaterialType> builder)
    //     {
    //         ImmsDbContext.RegisterEntityTable<MaterialType>("simple_code");

    //         builder.Ignore(e => e.MaterialTypeCode);
    //         builder.Ignore(e => e.MaterialTypeName);
    //     }
    // }
}
