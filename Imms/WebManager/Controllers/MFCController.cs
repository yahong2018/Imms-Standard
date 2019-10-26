using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using Imms.Core;
using Imms.Data;
using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using NPOI.SS.UserModel;

namespace Imms.WebManager.Controllers
{
    [Route("api/imms/mfc/rfidCard")]
    public class RfidCardController : SimpleCRUDController<RfidCard>
    {
        private readonly IHostingEnvironment host = null;
        public RfidCardController(IHostingEnvironment host)
        {
            this.host = host;
            this.Logic = new Data.SimpleCRUDLogic<RfidCard>();
        }

        protected override void Verify(RfidCard item, int operation)
        {
            //
            // 验证Production、Workshop
            //
        }

        [Route("importExcel")]
        public int ImportExcel()
        {
            var file = this.Request.Form.Files[0];
            string ContentType = file.ContentType;
            string webRootPath = this.host.WebRootPath;
            string ext = System.IO.Path.GetExtension(file.FileName).ToLower();
            string name = System.IO.Path.GetFileNameWithoutExtension(file.FileName);
            string filePath = System.IO.Path.Combine(webRootPath, "upload/excel/kanban/") + Guid.NewGuid().ToString() + "(" + name + ")" + ext;
            List<RfidCard> cardList = new List<RfidCard>();
            using (var stream = System.IO.File.Create(filePath))
            {
                file.CopyTo(stream);
                stream.Seek(0, System.IO.SeekOrigin.Begin);
               
                CommonRepository.UseDbContext(dbContext =>
                {
                    ExcelHelper.ImportExcel(stream, ext, "Sheet1", 2, -1, (IRow row) =>
                    {
                        // string productionCode = row.GetCell(0).StringCellValue;
                        // string productionName = row.GetCell(1).StringCellValue;
                        // int qty = 0;
                        // int kanbanNo = (int)row.GetCell(3).NumericCellValue;
                        // string workshopCode = row.GetCell(4).StringCellValue;
                        // int rfidNo = (int)row.GetCell(5).NumericCellValue;

                        // try
                        // {
                        //     qty = (int)row.GetCell(2).NumericCellValue;
                        // }
                        // catch
                        // {
                        //     string strQty = row.GetCell(2).StringCellValue;
                        //     if (!int.TryParse(strQty, out qty))
                        //     {
                        //         throw new BusinessException(GlobalConstants.EXCEPTION_CODE_PARAMETER_INVALID, $"第{row.RowNum}行的\"收容数量\":\"{strQty}\"无法被识别为数字！");
                        //     }
                        // }

                        string productionCode = ExcelHelper.GetCellValue(row,0).ToString();
                        string productionName = ExcelHelper.GetCellValue(row,1).ToString();
                        int qty = (int)((double)ExcelHelper.GetCellValue(row,2));
                        string kanbanNo = ExcelHelper.GetCellValue(row,3).ToString();
                        string workshopCode = ExcelHelper.GetCellValue(row,4).ToString();
                        string rfidNo = ExcelHelper.GetCellValue(row,5).ToString();
                        DateTime dateTime =(DateTime) ExcelHelper.GetCellValue(row,6,true);

                        RfidCard card = new RfidCard();
                        card.KanbanNo = kanbanNo.ToString();
                        card.RfidNo = rfidNo.ToString().PadLeft(10, '0');
                        card.CardStatus = 0;
                        card.CardType = 0;
                        card.ProductionId = -1;
                        card.Qty = qty;
                        card.ProductionCode = productionCode;
                        card.ProductionName = productionName;

                        Workshop workshop = dbContext.Set<Workshop>().FirstOrDefault(x=>x.OrgCode == workshopCode);
                        if(workshop==null){
                            throw new BusinessException(GlobalConstants.EXCEPTION_CODE_PARAMETER_INVALID, $"第{row.RowNum}行的'车间':'{workshopCode}'错误！");
                        }
                        card.WorkshopId = workshop.RecordId;
                        card.WorkshopCode = workshopCode;
                        card.WorkshopName = workshop.WorkshopName;

                        cardList.Add(card);
                    });
                });
            }
            foreach (RfidCard card in cardList)
            {
                this.Logic.Create(card);
            }

            return cardList.Count;
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
                    string base64String = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(json), Base64FormattingOptions.None)
                       .Replace("+", "$_$_$_$_$");
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

    public class InstoreItem
    {
        public string KanbanNo { get; set; }
        public string ProductionCode { get; set; }
        public string ProductionName { get; set; }
        public string StoreNo { get; set; }
        public string StoreName { get; set; }
        public string operatorCode { get; set; }
        public string operatorName { get; set; }
        public int Qty { get; set; }
        public string MovingTime { get; set; }
    }


    [Route("api/imms/mfc/productionOrderProgress")]
    public class ProductionOrderProgressController : SimpleCRUDController<ProductionOrderProgress>
    {
        public ProductionOrderProgressController() => this.Logic = new SimpleCRUDLogic<ProductionOrderProgress>();

        [Route("reportInstroeByErp"), HttpPost]
        public int ReportInstoreByERP([FromBody] InstoreItem instoreItem)
        {
            SimpleCRUDLogic<ProductionMoving> movingLogic = new SimpleCRUDLogic<ProductionMoving>();
            SimpleCRUDLogic<RfidCard> cardLogic = new SimpleCRUDLogic<RfidCard>();
            FilterExpression[] filterExpressions = new FilterExpression[]{
                    new FilterExpression(){L="kanbanNo",O="=",R=instoreItem.KanbanNo}
                };
            RfidCard card = cardLogic.GetByOne(filterExpressions);
            if (card == null)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_DATA_NOT_FOUND, $"看板编号(KanbanNo)='{instoreItem.KanbanNo}'的看板还没有发卡！");
            }
            if (card.CardStatus != 1)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_PARAMETER_INVALID, $"看板编号(KanbanNo)='{instoreItem.KanbanNo}'的看板还没有报工，不可以执行移库动作！");
            }
            ProductionMoving movingItem = new ProductionMoving();
            movingItem.RfidCardId = card.RecordId;
            movingItem.RfidNo = card.RfidNo;
            movingItem.WorkshopId = card.WorkshopId;
            movingItem.WorkshopCode = card.WorkshopCode;
            movingItem.WorkshopName = card.WorkshopName;
            movingItem.Qty = instoreItem.Qty;
            movingItem.ProductionId = card.ProductionId;
            movingItem.ProductionCode = card.ProductionCode;
            movingItem.ProductionName = card.ProductionName;

            movingItem.ProductionOrderId = -1;
            movingItem.ProductionOrderNo = "";
            movingItem.PrevProgressRecordId = -1;

            movingItem.WorkstationId = -1;
            movingItem.WorkstationCode = "";
            movingItem.WorkstationName = "";

            movingItem.OperatorId = -1;
            movingItem.EmployeeId = instoreItem.operatorCode;
            movingItem.EmployeeName = instoreItem.operatorName;

            movingLogic.Create(movingItem);

            card.CardStatus = 0;
            cardLogic.Update(card);

            return GlobalConstants.EXCEPTION_CODE_NO_ERROR;
        }

        [Route("reportProgress")]
        public string ReportProgress([FromBody]ProgressReportItem item)
        {
            StringBuilder resultBuilder = new StringBuilder();

            CommonRepository.UseDbContext(dbContext =>
            {
                using (DbConnection connection = dbContext.Database.GetDbConnection())
                {
                    connection.Open();
                    using (DbCommand cmd = connection.CreateCommand())
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.CommandText = "MES_ProcessDeviceData";

                        DbParameter parameter = cmd.CreateParameter();
                        parameter.ParameterName = "IsNewData";
                        parameter.DbType = System.Data.DbType.Int32;
                        parameter.Direction = System.Data.ParameterDirection.Input;
                        parameter.Value = item.IsNewData;
                        cmd.Parameters.Add(parameter);

                        parameter = cmd.CreateParameter();
                        parameter.ParameterName = "GID";
                        parameter.DbType = System.Data.DbType.Int32;
                        parameter.Direction = System.Data.ParameterDirection.Input;
                        parameter.Value = item.GID;
                        cmd.Parameters.Add(parameter);

                        parameter = cmd.CreateParameter();
                        parameter.ParameterName = "DID";
                        parameter.DbType = System.Data.DbType.Int32;
                        parameter.Direction = System.Data.ParameterDirection.Input;
                        parameter.Value = item.DID;
                        cmd.Parameters.Add(parameter);

                        parameter = cmd.CreateParameter();
                        parameter.ParameterName = "IsOffLineData";
                        parameter.DbType = System.Data.DbType.Int32;
                        parameter.Direction = System.Data.ParameterDirection.Input;
                        parameter.Value = item.IsOffLineData;
                        cmd.Parameters.Add(parameter);

                        parameter = cmd.CreateParameter();
                        parameter.ParameterName = "DataType";
                        parameter.DbType = System.Data.DbType.Int32;
                        parameter.Direction = System.Data.ParameterDirection.Input;
                        parameter.Value = item.DataType;
                        cmd.Parameters.Add(parameter);

                        parameter = cmd.CreateParameter();
                        parameter.ParameterName = "DataGatherTime";
                        parameter.DbType = System.Data.DbType.DateTime;
                        parameter.Direction = System.Data.ParameterDirection.Input;
                        parameter.Value = item.DataGatherTime;
                        cmd.Parameters.Add(parameter);

                        parameter = cmd.CreateParameter();
                        parameter.ParameterName = "DataMakeTime";
                        parameter.DbType = System.Data.DbType.DateTime;
                        parameter.Direction = System.Data.ParameterDirection.Input;
                        parameter.Value = item.DataMakeTime;
                        cmd.Parameters.Add(parameter);

                        parameter = cmd.CreateParameter();
                        parameter.ParameterName = "StrPara1";
                        parameter.DbType = System.Data.DbType.AnsiString;
                        parameter.Direction = System.Data.ParameterDirection.Input;
                        parameter.Value = item.StrPara1;
                        parameter.Size = 200;
                        cmd.Parameters.Add(parameter);

                        parameter = cmd.CreateParameter();
                        parameter.ParameterName = "Resp";
                        parameter.DbType = System.Data.DbType.AnsiString;
                        parameter.Direction = System.Data.ParameterDirection.Output;
                        parameter.Size = 4000;
                        cmd.Parameters.Add(parameter);

                        cmd.ExecuteNonQuery();

                        // using (DbDataReader dataReader = cmd.ExecuteReader())
                        // {
                        //     resultBuilder.Append("\"Contents\":[");
                        //     while (dataReader.Read())
                        //     {                              
                        //         resultBuilder.Append("\"");
                        //         resultBuilder.Append(dataReader["Content"].ToString());                                
                        //         resultBuilder.Append("\",");
                        //     }
                        //     resultBuilder.Append("]");
                        // }

                        resultBuilder.Append("\"Resp\":\"");
                        resultBuilder.Append(parameter.Value.ToString());
                        resultBuilder.Append("\"");
                    }
                }
            });

            return resultBuilder.ToString();
        }


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
        public QualityCheckController() => this.Logic = new SimpleCRUDLogic<QualityCheck>();
    }


    public class ProgressReportItem
    {
        public int IsNewData { get; set; }
        public int GID { get; set; }
        public int DID { get; set; }
        public int IsOffLineData { get; set; }
        public int DataType { get; set; }
        public DateTime DataGatherTime { get; set; }
        public DateTime DataMakeTime { get; set; }
        public string StrPara1 { get; set; }
    }
}