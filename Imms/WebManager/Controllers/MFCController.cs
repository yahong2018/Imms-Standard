using System;
using System.Collections.Generic;
using System.Linq;
using Imms.Data;
using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Imms.WebManager.Controllers
{
    [Route("api/imms/mfc/rfidCard")]
    public class RfidCardController : SimpleCRUDController<RfidCard>
    {
        public RfidCardController()
        {
            this.Logic = new Data.SimpleCRUDLogic<RfidCard>();
        }

        protected override void Verify(RfidCard item, int operation)
        {
            //
            // 验证Production、Workshop
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

    [Route("api/imms/mfc/productionOrder")]
    public class ProductionOrderController : SimpleCRUDController<ProductionOrder>
    {
        public ProductionOrderController() => this.Logic = new SimpleCRUDLogic<ProductionOrder>();
    }

    [Route("api/imms/mfc/productionOrderProgress")]
    public class ProductionOrderProgressController : SimpleCRUDController<ProductionOrderProgress>
    {
        public ProductionOrderProgressController() => this.Logic = new SimpleCRUDLogic<ProductionOrderProgress>();

        protected override void Verify(ProductionOrderProgress item, int operation)
        {
            ProductionOrder order = CommonRepository.GetOneByFilter<ProductionOrder>(x => x.OrderNo == item.ProductionOrderNo);
            if (order == null)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_DATA_NOT_FOUND, $"计划单号为{item.ProductionOrderNo}的生产计划不存在！");
            }
            item.ProductionOrderId = order.RecordId;
            item.ProductionId = order.ProductionId;
            item.ProductionCode = order.ProductionCode;
            item.ProductionName = order.ProductionName;

            Workshop workshop = CommonRepository.GetOneByFilter<Workshop>(x => x.OrgCode == item.WorkshopCode);
            if (workshop == null)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_DATA_NOT_FOUND, $"车间代码为{item.WorkshopCode}的车间资料不存在！");
            }
            item.WorkshopId = workshop.RecordId;
            item.WorkshopName = workshop.OrgName;

            Workstation workstation = CommonRepository.GetOneByFilter<Workstation>(x => x.OrgCode == item.WorkstationCode);
            if (workstation == null)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_DATA_NOT_FOUND, $"工位代码为{item.WorkstationCode}的工位资料不存在！");
            }
            item.WorkstationId = workstation.RecordId;
            item.WorkstationName = workstation.OrgName;
        }
    }

    [Route("api/imms/mfc/productionOrderMoving")]
    public class ProductionMovingController : SimpleCRUDController<ProductionMoving>
    {
        public ProductionMovingController() => this.Logic = new SimpleCRUDLogic<ProductionMoving>();


    }

    [Route("api/imms/mfc/qualityCheck")]
    public class QualityCheckController : SimpleCRUDController<QualityCheck>
    {
        public QualityCheckController() => this.Logic=new SimpleCRUDLogic<QualityCheck>();
    }
}