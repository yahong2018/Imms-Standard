using System.Collections.Generic;
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

        private class BomStock
        {
            public long MaterialId { get; set; }
            public string MaterialCode { get; set; }
            public string MaterialName { get; set; }
            public int Qty { get; set; }
            public int Level { get; set; }
        }       

        protected override void BeforeInsert(QualityCheck item, DbContext dbContext)
        {
            int count = dbContext.Set<Workstation>().Where(x => x.WocgCode == item.WocgCode).Count();
            if (count <= 0)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_DATA_NOT_FOUND, "不存在工作中心组为" + item.WocgCode + "的数据！");
            }
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
            ProductSummary productSummary = dbContext.Set<ProductSummary>()
            .Where(x => x.ProductionId == item.ProductionId && x.ProductDate == item.TimeOfOriginWork)
            .FirstOrDefault();
            if (productSummary == null)
            {
                productSummary = new ProductSummary();
                productSummary.ProductDate = item.TimeOfOriginWork.Date;
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
                productSummary.QtyDefect_0 = productSummary.QtyDefect_0 + item.Qty;
            }
            else
            {
                productSummary.QtyDefect_1 = productSummary.QtyDefect_1 + item.Qty;
            }
        }

        private static void UpdateItemStock(QualityCheck item, DbContext dbContext)
        {
            MaterialStock stock = AssureStock(item, dbContext);
            stock.QtyStock = stock.QtyStock + item.Qty;
            stock.QtyDefect = stock.QtyDefect + item.Qty;
            GlobalConstants.ModifyEntityStatus(stock, dbContext);
        }

        private static void AjustStock(QualityCheck parentItem, DbContext dbContext)
        {
            UpdateItemStock(parentItem, dbContext);

            // List<BomStock> SubBomStockList = GetBomStockItems(parentItem, dbContext);
            // AddSubQualityCheckItems(parentItem, dbContext, SubBomStockList);
        }

        private static MaterialStock AssureStock(QualityCheck item, DbContext dbContext)
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

        // private static void AddSubQualityCheckItems(QualityCheck parentItem, DbContext dbContext, List<BomStock> SubBomStockList)
        // {
        //     foreach (var stockItem in SubBomStockList)
        //     {
        //         QualityCheck subQualityItem = new QualityCheck();
        //         subQualityItem.Clone(parentItem);
        //         subQualityItem.ProductionId = stockItem.MaterialId;
        //         subQualityItem.ProductionCode = stockItem.MaterialCode;
        //         subQualityItem.ProductionName = stockItem.MaterialName;
        //         subQualityItem.Qty = stockItem.Qty;

        //         dbContext.Set<QualityCheck>().Add(subQualityItem);

        //         UpdateItemStock(subQualityItem, dbContext);
        //     }
        //     dbContext.SaveChanges();
        // }

        // private static System.Collections.Generic.List<BomStock> GetBomStockItems(QualityCheck item, DbContext dbContext)
        // {
        //     int level = 1;
        //     var bom_stock = (from b in dbContext.Set<Bom>()
        //                      where b.MaterialId == item.ProductionId
        //                         && b.BomStatus == 1
        //                        && (from b1 in dbContext.Set<Bom>() where b1.MaterialId == b.ComponentId select b1).Any()
        //                      select new BomStock()
        //                      {
        //                          MaterialId = b.ComponentId,
        //                          MaterialCode = b.ComponentCode,
        //                          MaterialName = b.ComponentName,
        //                          Qty = b.ComponentQty * item.Qty,
        //                          Level = level
        //                      }).ToList();

        //     while (true)
        //     {
        //         level = level + 1;
        //         var tmp = (from b in dbContext.Set<Bom>()
        //                    join bs in bom_stock on b.MaterialId equals bs.MaterialId
        //                    join m in dbContext.Set<Material>() on b.MaterialId equals m.RecordId
        //                    where bs.Level == level - 1
        //                       && b.BomStatus == 1
        //                       && m.AutoFinishedProgress == 1
        //                       && (from b1 in dbContext.Set<Bom>() where b1.MaterialId == b.ComponentId select b1).Any()
        //                    select new BomStock()
        //                    {
        //                        MaterialId = b.ComponentId,
        //                        MaterialCode = b.ComponentCode,
        //                        MaterialName = b.ComponentName,
        //                        Qty = b.ComponentQty * bs.Qty,
        //                        Level = level
        //                    }).ToList();
        //         bom_stock.AddRange(tmp);

        //         if (tmp.Count == 0 || level > 99)
        //         {
        //             break;
        //         }
        //     }

        //     return bom_stock;
        // }
    }
}