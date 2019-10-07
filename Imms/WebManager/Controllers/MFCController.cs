using System;
using System.Collections.Generic;
using System.Linq;
using Imms.Data;
using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Imms.WebManager.Controllers
{
    [Route("imms/mfc/rfidCard")]
    public class RfidCardController : SimpleCRUDController<RfidCard>
    {
        public RfidCardController()
        {
            this.Logic = new Data.SimpleCRUDLogic<RfidCard>();
        }

        protected override void Verify(RfidCard item, int operation)
        {
            //
            // 检查productionId和workshopId 
            //
        }

        [Route("printBarCode")]
        public IActionResult PrintBarCode(string idList)
        {
            string commaString = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(idList));
            string[] strDecodedIdList = commaString.Split(",", StringSplitOptions.RemoveEmptyEntries);
            long[] decodedIdList = new long[strDecodedIdList.Length];
            for (int i = 0; i < strDecodedIdList.Length; i++)
            {
                decodedIdList[i] = long.Parse(strDecodedIdList[i]);
            }

            List<string> imgDataList = new List<string>();
            CommonRepository.UseDbContext(dbContext =>
            {
                var dataList = dbContext.Set<RfidCard>().Where(x => decodedIdList.Contains(x.RecordId)).Select
                 (x =>
                   new
                   {
                       x.WorkshopCode,
                       x.WorkshopName,
                       x.ProductionCode,
                       x.ProductionName,
                       x.RfidNo,
                       x.Qty
                   }
                 ).ToList();

                ViewBag.DataList = new List<Tuple<string, string, int, string>>();
                foreach (var item in dataList)
                {
                    string json = item.ToJson();
                    string base64String = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(json), Base64FormattingOptions.None);
                    imgDataList.Add(base64String);

                    System.Tuple<string, string, int, string> tuple = Tuple.Create<string, string, int, string>
                            (item.WorkshopName + "(" + item.WorkshopCode + ")", item.ProductionName + "(" + item.ProductionCode + ")", item.Qty, item.RfidNo);
                    base.ViewBag.DataList.Add(tuple);
                }
            });

            ViewBag.BarcodeDataList = imgDataList;

            return View("Imms/MFC/RfidCard/PrintBarCode");
        }
    }

    [Route("imms/mfc/productionOrder")]
    public class ProductionOrderController : SimpleCRUDController<ProductionOrder>
    {
        public ProductionOrderController() => this.Logic = new SimpleCRUDLogic<ProductionOrder>();
    }
}