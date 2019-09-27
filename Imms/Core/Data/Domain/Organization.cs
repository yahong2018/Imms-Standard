using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using Imms.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Imms.Data.Domain
{
    public partial class WorkOrganizationUnit : TrackableEntity<long>
    {
        public string OrganizationType { get; set; }        
        public string OrganizationCode { get; set; }
        public string OrganizationName { get; set; }        
        public string Description { get; set; }
        public long ParentOrganizationId { get; set; }

        public virtual List<WorkOrganizationUnit> Children { get; set; } = new List<WorkOrganizationUnit>();
        public virtual WorkOrganizationUnit Parent { get; set; }
    }

    public class WorkOrganizationUnitConfigure : TrackableEntityConfigure<WorkOrganizationUnit>
    {
        protected override void InternalConfigure(EntityTypeBuilder<WorkOrganizationUnit> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("work_organization_unit");
            ImmsDbContext.RegisterEntityTable<WorkOrganizationUnit>("work_organization_unit");

            builder.Property(e => e.OrganizationCode).IsRequired().HasColumnName("organization_code").HasMaxLength(10).IsUnicode(false);
            builder.Property(e => e.OrganizationName).IsRequired().HasColumnName("organization_name").HasMaxLength(50).IsUnicode(false);
            builder.Property(e => e.Description).HasColumnName("description").HasMaxLength(250).IsUnicode(false);
            builder.Property(e => e.ParentOrganizationId).HasColumnName("parent_organization_id").HasColumnType("bigint(20)");
            builder.Property(e=>e.OrganizationType).HasColumnName("organization_type");

            builder.HasMany(e => e.Children).WithOne(e => e.Parent).HasForeignKey(e => e.ParentOrganizationId).HasConstraintName("parent_organization_id");
        }
    }
}
