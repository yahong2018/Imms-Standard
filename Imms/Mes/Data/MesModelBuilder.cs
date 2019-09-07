using Imms.Data;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Text;

namespace Imms.Mes.Data
{
    public  class MesModelBuilder:ICustomModelBuilder
    {
        public void BuildModel(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("ProductVersion", "2.2.3-servicing-35854");
            
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.EquipmentTypeCofigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.EquipmentConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.OperatorConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.OperatorCapabilityConfigure());
            
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.MaterialTypeCofigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.MaterialConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.BomConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.BomOrderConfigure());

            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.OperationConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.OpetaionMediaConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.OperationRoutingConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.OperationRoutingOrderConfigure());
        }
    }
}
