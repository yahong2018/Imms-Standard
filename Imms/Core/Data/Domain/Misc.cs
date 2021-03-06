﻿using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Imms.Data.Domain
{
    // public partial class SystemParameterClass : Entity<long>
    // {
    //     public string ClassName { get; set; }

    //     public virtual List<SystemParameter> Parameters { get; set; } = new List<SystemParameter>();
    // }

    public partial class SystemParameter : Entity<long>
    {
        public string ParameterClassCode { get; set; }
        public string parameterClassName { get; set; }
        public string ParameterCode { get; set; }
        public string ParameterName { get; set; }
        public string ParameterValue { get; set; }

        // public virtual SystemParameterClass ParameterClass { get; set; }
    }

    // public class SystemParameterClassConfigure : EntityConfigure<SystemParameterClass>
    // {
    //     protected override void InternalConfigure(EntityTypeBuilder<SystemParameterClass> builder)
    //     {
    //         base.InternalConfigure(builder);
    //         builder.ToTable("system_parameter_class");
    //         ImmsDbContext.RegisterEntityTable<SystemParameterClass>("system_parameter_class");

    //         builder.Property(e => e.ClassName).HasColumnName("class_name");
    //         builder.HasMany(e => e.Parameters).WithOne(e => e.ParameterClass).HasForeignKey(e => e.ParameterClassId).HasConstraintName("parameter_class_id");
    //     }
    // }

    public class SystemParameterConfigure : EntityConfigure<SystemParameter>
    {
        protected override void InternalConfigure(EntityTypeBuilder<SystemParameter> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("system_parameter");
            ImmsDbContext.RegisterEntityTable<SystemParameter>("system_parameter");

            builder.Property(e => e.ParameterClassCode).HasColumnName("parameter_class_code");
            builder.Property(e => e.parameterClassName).HasColumnName("parameter_class_name");
            builder.Property(e => e.ParameterCode).HasColumnName("parameter_code");
            builder.Property(e => e.ParameterName).HasColumnName("parameter_name");
            builder.Property(e => e.ParameterValue).HasColumnName("parameter_value");
        }
    }
}
