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
       // public string OrganizationType { get; set; }
        public string OrgCode { get; set; }
        public string OrgName { get; set; }
        public string Description { get; set; }
        public long ParentId { get; set; }
        public string ParentCode{get;set;}
        public string ParentName{get;set;}

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

            builder.Property(e => e.OrgCode).IsRequired().HasColumnName("org_code").HasMaxLength(10).IsUnicode(false);
            builder.Property(e => e.OrgName).IsRequired().HasColumnName("org_name").HasMaxLength(50).IsUnicode(false);
            builder.Property(e => e.Description).HasColumnName("description").HasMaxLength(250).IsUnicode(false);
            builder.Property(e => e.ParentId).HasColumnName("parent_id").HasColumnType("bigint(20)");
            builder.Property(e=>e.ParentCode).HasColumnName("parent_code");
            builder.Property(e=>e.ParentName).HasColumnName("parent_name");
           
            builder.HasMany(e => e.Children).WithOne(e => e.Parent).HasForeignKey(e => e.ParentId).HasConstraintName("parent_id");
        }
    }
}
