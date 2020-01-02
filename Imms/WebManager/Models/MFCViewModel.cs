using System;
using System.Collections.Generic;
using Imms.Mes.Data.Domain;

namespace Imms.WebManager.Models
{
    public class QualityCheckBatchAddForm
    {
        public long DefectId { get; set; }
        public string DefectCode { get; set; }
        public string DefectName { get; set; }

        public string ProductionId { get; set; }
        public string ProductionCode { get; set; }
        public string ProductionName { get; set; }

        public long WorkshopId { get; set; }
        public string WorkshopCode { get; set; }
        public string WorkshopName { get; set; }
        public string WocgCode { get; set; }
        public String LocCode { get; set; }

        public DateTime TimeOfOriginWork { get; set; }
        public int Qty { get; set; }

        public int ShiftId { get; set; }

        public List<QualityCheck> ToQualityRecord()
        {
            QualityCheckBatchAddForm batchAddForm = this;
            
            string[] productionIdList = batchAddForm.ProductionId.Split(";", StringSplitOptions.RemoveEmptyEntries);
            string[] productionCodeList = batchAddForm.ProductionCode.Split(";", StringSplitOptions.RemoveEmptyEntries);
            string[] productionNameList = batchAddForm.ProductionName.Split(";", StringSplitOptions.RemoveEmptyEntries);

            List<QualityCheck> checkList = new List<QualityCheck>();
            for (int i = 0; i < productionIdList.Length; i++)
            {
                QualityCheck quality = new QualityCheck();
                quality.DefectId = batchAddForm.DefectId;
                quality.DefectCode = batchAddForm.DefectCode;
                quality.DefectName = batchAddForm.DefectName;
                quality.ProductionId = long.Parse(productionIdList[i]);
                quality.ProductionCode = productionCodeList[i];
                quality.ProductionName = productionNameList[i];
                quality.ShiftId = batchAddForm.ShiftId;
                quality.TimeOfOriginWork = batchAddForm.TimeOfOriginWork;
                quality.TimeOfOrigin = batchAddForm.TimeOfOriginWork;
                quality.Qty = batchAddForm.Qty;
                quality.WorkshopId = batchAddForm.WorkshopId;
                quality.WorkshopCode = batchAddForm.WorkshopCode;
                quality.WorkshopName = batchAddForm.WorkshopName;
                quality.WocgCode = batchAddForm.WocgCode;
                quality.LocCode = batchAddForm.LocCode;

                checkList.Add(quality);
            }

            return checkList;
        }
    }
}