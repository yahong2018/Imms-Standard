using System.Linq;
using Imms.Data;
using Imms.Mes.Data.Domain;
using Microsoft.EntityFrameworkCore;

namespace Imms.Mes.Data
{
    public class ProductOrderProgressLogic : SimpleCRUDLogic<ProductionOrderProgress>
    {
        protected override void BeforeInsert(ProductionOrderProgress item, DbContext dbContext)
        {
            int count = dbContext.Set<Workstation>().Where(x => x.WocgCode == item.WocgCode).Count();
            if (count <= 0)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_DATA_NOT_FOUND, "不存在工作中心组为" + item.WocgCode + "的数据！");
            }

            item.TimeOfOriginWork = item.TimeOfOrigin.Date;
            if (item.TimeOfOrigin.Hour < 8 || item.TimeOfOrigin.Hour > 20)
            {
                item.ShiftId = 1;

                if (item.TimeOfOrigin.Hour < 8 || (item.TimeOfOrigin.Hour == 8 && item.TimeOfOrigin.Minute < 30))
                {
                    item.TimeOfOriginWork = item.TimeOfOrigin.AddDays(-1).Date;
                }
            }
        }

        protected override void AfterInsert(ProductionOrderProgress item, DbContext dbContext)
        {
            lock (this)
            {
                AjustStock(item, dbContext);
                AjustProductSummary(item, dbContext);
            }
            dbContext.SaveChanges();
        }

        private static void AjustProductSummary(ProductionOrderProgress item, DbContext dbContext)
        {
            ProductSummary productSummary = dbContext.Set<ProductSummary>().Where(x =>
                x.ProductionId == item.ProductionId && x.ProductDate == item.TimeOfOriginWork
            ).FirstOrDefault();
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
                productSummary.QtyGood_0 = productSummary.QtyGood_0 + item.Qty;
            }
            else
            {
                productSummary.QtyGood_1 = productSummary.QtyGood_1 + item.Qty;
            }
        }

        private static void UpdateItemStock(ProductionOrderProgress item, DbContext dbContext)
        {
            MaterialStock stock = AssureStock(item, dbContext);
            stock.QtyStock = stock.QtyStock + item.Qty;
            stock.QtyGood = stock.QtyGood + item.Qty;
            GlobalConstants.ModifyEntityStatus(stock, dbContext);
        }

        private static void AjustStock(ProductionOrderProgress parentItem, DbContext dbContext)
        {
            UpdateItemStock(parentItem, dbContext);

            // List<BomStock> SubBomStockList = GetBomStockItems(parentItem, dbContext);
            // AddSubQualityCheckItems(parentItem, dbContext, SubBomStockList);
        }

        private static MaterialStock AssureStock(ProductionOrderProgress item, DbContext dbContext)
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
            return stock;
        }
    }
}