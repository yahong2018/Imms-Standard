using System;
using System.Linq;
using Imms.Data;
using Imms.Mes.Data.Domain;
using Microsoft.EntityFrameworkCore;

namespace Imms.Mes.Data
{
    public class ProductMovingLogic : SimpleCRUDLogic<ProductionMoving>
    {
        protected override void AfterInsert(ProductionMoving item, DbContext dbContext)
        {
            //移库以后，要调整库存：移入部门库存增加，移出部门库存减少
            lock (typeof(ProductMovingLogic))
            {
                WorkshopLogic WorkshopLogic  = new WorkshopLogic(dbContext);
                Workshop fromWorkshop = dbContext.Set<Workshop>().Where(x=>x.RecordId == item.WorkshopIdFrom).First();
                bool isFinishedProductionWorkshop = WorkshopLogic.IsFinishedProductionWorkshop(fromWorkshop);
                MaterialStock stockIn = AssureInStock(item, isFinishedProductionWorkshop,dbContext);
                MaterialStock stockOut = AssureOutStock(item, isFinishedProductionWorkshop,dbContext);

                if (stockIn != null)
                {
                    stockIn.QtyMoveIn = stockIn.QtyMoveIn + item.Qty;  // 移入
                    stockIn.QtyStock = stockIn.QtyStock + item.Qty;     // 库存增加
                    GlobalConstants.ModifyEntityStatus(stockIn, dbContext);
                }

                if (stockOut != null)
                {
                    stockOut.QtyMoveOut = stockOut.QtyMoveOut + item.Qty;  // 移出
                    stockOut.QtyStock = stockOut.QtyStock - item.Qty;      // 库存减少
                    GlobalConstants.ModifyEntityStatus(stockOut, dbContext);
                }

                dbContext.SaveChanges();
            }
        }

        private MaterialStock AssureInStock(ProductionMoving item, bool isFinishedProductionWorkshop,DbContext dbContext)
        {
            MaterialStock stock = dbContext.Set<MaterialStock>().Where(x => x.StoreId == item.WorkshopId && x.MaterialId == item.ProductionId).FirstOrDefault();
            if (stock == null && !isFinishedProductionWorkshop)
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

        private MaterialStock AssureOutStock(ProductionMoving item, bool isFinishedProductionWorkshop, DbContext dbContext)
        {
            MaterialStock stock = dbContext.Set<MaterialStock>().Where(x => x.StoreId == item.WorkshopIdFrom && x.MaterialId == item.ProductionId).FirstOrDefault();
            if (stock == null && !isFinishedProductionWorkshop)
            {
                stock = new MaterialStock();
                stock.MaterialId = item.ProductionId;
                stock.MaterialCode = item.ProductionCode;
                stock.MaterialName = item.ProductionName;

                stock.StoreId = item.WorkshopIdFrom;
                stock.StoreCode = item.WorkshopCodeFrom;
                stock.StoreName = item.WorkshopNameFrom;

                dbContext.Set<MaterialStock>().Add(stock);
                dbContext.SaveChanges();
            }
            return stock;
        }
    }
}