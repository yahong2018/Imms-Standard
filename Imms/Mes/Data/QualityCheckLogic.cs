using System.Linq;
using Imms.Data;
using Imms.Mes.Data.Domain;
using Microsoft.EntityFrameworkCore;

namespace Imms.Mes.Data
{

    public class QualityCheckLogic : SimpleCRUDLogic<QualityCheck>
    {
        public QualityCheckLogic()
        {
        }

        protected override void AfterInsert(QualityCheck item, DbContext dbContext)
        {
            lock (this)
            {
                AjustStock(item, dbContext);
                AjustProductSummary(item, dbContext);
            }

            dbContext.SaveChanges();
        }

        private static void AjustProductSummary(QualityCheck item, DbContext dbContext)
        {
            ProductSummary productSummary = dbContext.Set<ProductSummary>().Where(x => x.ProductionId == item.ProductionId).FirstOrDefault();
            if (productSummary == null)
            {
                productSummary = new ProductSummary();
                productSummary.ProductDate = item.TimeOfOriginWork;
                productSummary.ProductionId = item.ProductionId;
                productSummary.ProductionCode = item.ProductionCode;
                productSummary.ProductionName = item.ProductionName;
                productSummary.WorkshopId = item.WorkshopId;
                productSummary.WorkshopCode = item.WorkshopCode;
                productSummary.WorkshopName = item.WorkshopName;

                dbContext.Set<ProductSummary>().Add(productSummary);
                dbContext.SaveChanges();
            }
            if (item.ShiftId == 0)
            {
                productSummary.QtyDefect_0 = item.Qty;
            }
            else
            {
                productSummary.QtyDefect_1 = item.Qty;
            }
        }

        private static void AjustStock(QualityCheck item, DbContext dbContext)
        {
            MaterialStock stock = dbContext.Set<MaterialStock>().Where(x => x.StoreId == item.WorkshopId && x.MaterialId == item.ProductionId).FirstOrDefault();
            if (stock == null)
            {
                stock = new MaterialStock();
                stock.MaterialId = item.ProductionId;
                stock.MaterialCode = item.ProductionCode;
                stock.MaterialName = item.ProductionName;

                stock.StoreId = item.WorkshopId;
                stock.StoreCode = item.WorkshopCode;
                stock.StoreName = item.WorkshopName;

                dbContext.Set<MaterialStock>().Add(stock);
                dbContext.SaveChanges();
            }

            stock.QtyStock = stock.QtyStock + item.Qty;
            stock.QtyDefect = stock.QtyDefect + item.Qty;

            GlobalConstants.ModifyEntityStatus(stock, dbContext);

            Material material = dbContext.Set<Material>().Where(x => x.RecordId == item.ProductionId).First();
            MaterialStock prevStock = dbContext.Set<MaterialStock>()
                .Where(x => x.MaterialId == material.PrevMaterialId && x.StoreId == item.WorkshopId
               ).FirstOrDefault();
            if (prevStock != null)
            {
                prevStock.QtyStock = prevStock.QtyStock - item.Qty;
                prevStock.QtyConsumeDefect = prevStock.QtyConsumeDefect + item.Qty;
                GlobalConstants.ModifyEntityStatus(prevStock, dbContext);
            }
        }
    }
}