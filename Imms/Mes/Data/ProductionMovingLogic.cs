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
                MaterialStock stockIn = AssureInStock(item, dbContext);
                MaterialStock stockOut = AssureOutStock(item, dbContext);

                stockIn.QtyMoveIn =  stockIn.QtyMoveIn + item.Qty;  // 移入
                stockIn.QtyStock = stockIn.QtyStock + item.Qty;     // 库存增加

                stockOut.QtyMoveOut = stockOut.QtyMoveOut + item.Qty;  // 移出
                stockOut.QtyStock = stockOut.QtyStock - item.Qty;      // 库存减少

                GlobalConstants.ModifyEntityStatus(stockIn,dbContext);
                GlobalConstants.ModifyEntityStatus(stockOut,dbContext);

                dbContext.SaveChanges();                
            }
        }

        private MaterialStock AssureInStock(ProductionMoving item, DbContext dbContext)
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

        private MaterialStock AssureOutStock(ProductionMoving item, DbContext dbContext)
        {
            MaterialStock stock = dbContext.Set<MaterialStock>().Where(x => x.StoreId == item.WorkshopIdFrom && x.MaterialId == item.ProductionId).FirstOrDefault();
            if (stock == null)
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