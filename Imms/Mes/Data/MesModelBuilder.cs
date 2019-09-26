using Imms.Data;
using Imms.Mes.Data.Domain;
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
            
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.MaterialTypeConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.MaterialConfigure());

            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.OperationConfigure());
            
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.OperationRoutingConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.OperationRoutingOrderConfigure());

            modelBuilder.ApplyConfiguration(new RfidCardConfigure());
            modelBuilder.ApplyConfiguration(new RfidControllerConfigure());
            modelBuilder.ApplyConfiguration(new ProductionOrderConfigure());
            modelBuilder.ApplyConfiguration(new ProductionOrderProgressConfigure());
            modelBuilder.ApplyConfiguration(new QualityCheckConfigure());
            modelBuilder.ApplyConfiguration(new WorkShopConfigure());
            modelBuilder.ApplyConfiguration(new WorkStationConfigure());
        }
    }
}
