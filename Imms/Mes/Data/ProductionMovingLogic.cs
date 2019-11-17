using System;
using System.Linq;
using Imms.Data;
using Imms.Mes.Data.Domain;
using Microsoft.EntityFrameworkCore;

namespace Imms.Mes.Data{
    public class ProductMovingLogic:SimpleCRUDLogic<ProductionMoving>{
        // protected override void AfterInsert(ProductionMoving item, DbContext dbContext){
        //     //移库以后，要调整库存：移入部门库存增加，移出部门库存减少
        //     MaterialStock stock = AssureStock(item,dbContext);
        // }

        // private MaterialStock AssureStock(ProductionMoving item, DbContext dbContext)
        // {
        //     MaterialStock stock = dbContext.Set<MaterialStock>().Where(x => x.StoreId == item.WorkshopId && x.MaterialId == item.ProductionId).FirstOrDefault();
        //     if (stock == null)
        //     {
        //         stock = new MaterialStock();
        //         stock.MaterialId = item.ProductionId;
        //         stock.MaterialCode = item.ProductionCode;
        //         stock.MaterialName = item.ProductionName;

        //         stock.StoreId = item.WorkshopId;
        //         stock.StoreCode = item.WorkshopCode;
        //         stock.StoreName = item.WorkshopName;

        //         dbContext.Set<MaterialStock>().Add(stock);
        //         dbContext.SaveChanges();
        //     }
        //     return stock;
        // }
    }
}