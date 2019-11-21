using Imms.Data;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Text;

namespace Imms.Mes.Data
{
    public class MesModelBuilder : ICustomModelBuilder
    {
        public void BuildModel(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("ProductVersion", "2.2.3-servicing-35854");

            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.SimpleCodeConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.EquipmentTypeCofigure());

            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.EquipmentConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.OperatorConfigure());

            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.MaterialTypeConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.MaterialConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.BomConfigure());

            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.RfidControllerConfigure());

            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.WorkOrganizationUnitConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.WorkshopConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.WorkstationConfigure());

            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.RfidCardConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.CardIssueConfigure());

            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.ProductionOrderConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.ProductionOrderProgressConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.QualityCheckConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.DefectConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.ProductionMovingConfigure());

            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.ProductSummaryConfigure());
            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.MaterialStockConfigure());

            modelBuilder.ApplyConfiguration(new Imms.Mes.Data.Domain.WorkstationLoginConfigure());
        }
    }
}
