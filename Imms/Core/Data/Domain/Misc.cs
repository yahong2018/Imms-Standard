using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Imms.Data.Domain
{
    public partial class Media : TrackableEntity<long>
    {
        public string MediaFormat { get; set; }
        public string MediaUrl { get; set; }
        public string MediaName { get; set; }
        public int MediaSize { get; set; }
        public string Description { get; set; }
    }

    public partial class SystemParameterClass : Entity<long>
    {
        public string ClassName { get; set; }

        public virtual List<SystemParameter> Parameters { get; set; } = new List<SystemParameter>();
    }

    public partial class SystemParameter : Entity<long>
    {
        public long ParameterClassId { get; set; }
        public string ParameterCode { get; set; }
        public string ParameterName { get; set; }
        public string ParameterValue { get; set; }

        public virtual SystemParameterClass ParameterClass { get; set; }
    }

    public class MediaConfigure : TrackableEntityConfigure<Media>
    {
        protected override void InternalConfigure(EntityTypeBuilder<Media> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("media");
            ImmsDbContext.RegisterEntityTable<Media>("media");

            builder.Property(e => e.Description).HasColumnName("description").HasMaxLength(250).IsUnicode(false);
            builder.Property(e => e.MediaName).IsRequired().HasColumnName("media_name").HasMaxLength(100).IsUnicode(false);
            builder.Property(e => e.MediaSize).HasColumnName("media_size").HasColumnType("int(11)");
            builder.Property(e => e.MediaFormat).HasColumnName("media_format");
            builder.Property(e => e.MediaUrl).IsRequired().HasColumnName("media_url").HasMaxLength(255).IsUnicode(false);
        }
    }

    public class SystemParameterClassConfigure : EntityConfigure<SystemParameterClass>
    {
        protected override void InternalConfigure(EntityTypeBuilder<SystemParameterClass> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("system_parameter_class");
            ImmsDbContext.RegisterEntityTable<SystemParameterClass>("system_parameter_class");

            builder.Property(e => e.ClassName).HasColumnName("class_name");
            builder.HasMany(e => e.Parameters).WithOne(e => e.ParameterClass).HasForeignKey(e => e.ParameterClassId).HasConstraintName("parameter_class_id");
        }
    }

    public class SystemParameterConfigure : EntityConfigure<SystemParameter>
    {
        protected override void InternalConfigure(EntityTypeBuilder<SystemParameter> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("system_parameter");
            ImmsDbContext.RegisterEntityTable<SystemParameter>("system_parameter");

            builder.Property(e => e.ParameterClassId).HasColumnName("parameter_class_id");
            builder.Property(e=>e.ParameterCode).HasColumnName("parameter_code");
            builder.Property(e=>e.ParameterName).HasColumnName("parameter_name");
            builder.Property(e=>e.ParameterValue).HasColumnName("parameter_value");
        }
    }
}
