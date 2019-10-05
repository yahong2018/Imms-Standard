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
            this.AfterGetDataHandler = this.AfterGetData;
        }

        private void AfterGetData(List<RfidCard> list, DbContext dbContext)
        {
            List<Workshop> workshopList = dbContext.Set<Workshop>().ToList();
            List<Material> productionList = dbContext.Set<Material>().ToList();

            foreach (RfidCard rfid in list)
            {
                rfid.Workshop = workshopList.Single(x => x.RecordId == rfid.WorkshopId);
                rfid.Production = productionList.Single(x => x.RecordId == rfid.ProductionId);
            }
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
                       x.Workshop.WorkshopCode,
                       x.RfidNo,
                       x.Production.MaterialNo,
                       x.Qty
                   }
                 ).ToList();

                ViewBag.DataList = new List<System.Tuple<string, string, int,string>>();
                foreach (var item in dataList)
                {
                    string json = item.ToJson();
                    string base64String = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(json), Base64FormattingOptions.None);
                    imgDataList.Add(base64String);

                    System.Tuple<string, string, int, string> tuple = Tuple.Create<string, string, int, string>(item.WorkshopCode, item.MaterialNo, item.Qty, item.RfidNo);
                    ViewBag.DataList.Add(tuple);
                }
            });

            ViewBag.BarcodeDataList = imgDataList;

            return View("Imms/MFC/RfidCard/PrintBarCode");
        }
    }
}