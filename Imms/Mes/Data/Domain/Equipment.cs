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

    public class RfidController : Entity<long>
    {
        public int GroupId { get; set; }
        public string ControllerName { get; set; }
        public string Position { get; set; }
        public string Ip { get; set; }
        public int Port { get; set; }
        public bool IsUse { get; set; }
    }

    public class RfidCard : TrackableEntity<long>
    {
        public string RfidNo{get;set;}
        public int CardType{get;set;}
        public int CardStatus{get;set;}
        public int ProductionId{get;set;}
        public int OperationId{get;set;}
        public int Qty{get;set;}
        public int OperatorId{get;set;}        

        public virtual Material Production{get;set;}
        public virtual Operator Operator{get;set;}
        public virtual Operation Operation {get;set;}
    }


    public class RfidCardConfigure : EntityConfigure<RfidCard>
    {
        protected override void InternalConfigure(EntityTypeBuilder<RfidCard> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("rfid_card");
            ImmsDbContext.RegisterEntityTable<RfidCard>("rfid_card");

            builder.Property(e => e.RfidNo).HasColumnName("rfid_no");
            builder.Property(e => e.CardType).HasColumnName("card_type");
            builder.Property(e => e.CardStatus).HasColumnName("card_status");
            builder.Property(e => e.ProductionId).HasColumnName("production_id");
            builder.Property(e => e.OperationId).HasColumnName("operation_id");
            builder.Property(e => e.Qty).HasColumnName("qty");
            builder.Property(e => e.OperatorId).HasColumnName("operator_id");

            builder.OwnsOne(e=>e.Production).HasConstraintName("production_id");
            builder.OwnsOne(e=>e.Operator).HasConstraintName("operator_id");
            builder.OwnsOne(e=>e.Operation).HasConstraintName("operation_id");
        }
    }


    public class EquipmentConfigure : EntityConfigure<Equipment>
    {
        protected override void InternalConfigure(EntityTypeBuilder<Equipment> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("equipment");
            ImmsDbContext.RegisterEntityTable<Equipment>("equipment");

            builder.Property(e => e.EquipmentNo).HasColumnName("equipment_no");
            builder.Property(e => e.EquipmentName).HasColumnName("equipment_name");
            builder.Property(e => e.Description).HasColumnName("description");
            builder.Property(e => e.Status).HasColumnName("status");
            builder.Property(e => e.EquipmentTypeId).HasColumnName("equipment_type_id");
            builder.HasOne(e => e.EquipmentType).WithMany().HasForeignKey(e => e.EquipmentTypeId).HasConstraintName("equipment_type_id");
        }
    }

    public class RfidControllerConfigure : EntityConfigure<RfidController>
    {
        protected override void InternalConfigure(EntityTypeBuilder<RfidController> builder)
        {
            base.InternalConfigure(builder);
            builder.ToTable("v_rfid_controller");
            ImmsDbContext.RegisterEntityTable<RfidController>("v_rfid_controller");

            builder.Property(e => e.GroupId).HasColumnName("group_id");
            builder.Property(e => e.ControllerName).HasColumnName("controller_name");
            builder.Property(e => e.Position).HasColumnName("position");
            builder.Property(e => e.Ip).HasColumnName("ip");
            builder.Property(e => e.Port).HasColumnName("port");
            builder.Property(e => e.IsUse).HasColumnName("is_use");
        }
    }


    

}
