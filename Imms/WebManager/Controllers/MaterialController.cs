using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager.Controllers
{
    [Route("api/imms/material/material")]
    public class MaterialController : SimpleCRUDController<Material>
    {
        public MaterialController() => this.Logic = new Data.SimpleCRUDLogic<Material>();


        [Route("syncByErp"), HttpPost]
        public int SyncByErp([FromBody] MaterialSyncItem syncItem)
        {
            if(syncItem.DataType!="INSERT" || syncItem.DataType!="UPDATE" || syncItem.DataType!="DELETE"){
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_PARAMETER_INVALID,"记录类型DataType错误，必须是'INSERT'、'UPDATE'、'DELETE'三者之一");
            }

            Material material = new Material()
            {
                MaterialCode = syncItem.MaterialCode,
                MaterialName = syncItem.MaterialName,
                Description = "",
                WorkshopCode = "",
                WorkshopId = -1,
                WorkshopName = ""
            };

            if (syncItem.DataType == "INSERT")
            {
                this.Logic.Create(material);
            }
            else
            {
                string filter = "{materialCode ==\"" + material.MaterialCode + "\"}";
                Material old = this.Logic.GetByOne(filter);                
                if (old == null)
                {
                    throw new BusinessException(GlobalConstants.EXCEPTION_CODE_DATA_NOT_FOUND, $"系统不存在materialCode=\"{material.MaterialCode}\"的产品或物料!");
                }
                old.MaterialCode = material.MaterialCode;
                old.MaterialName =material.MaterialName;

                if (syncItem.DataType == "UPDATE")
                {
                    this.Logic.Update(old);
                }
                else if (syncItem.DataType == "DELETE")
                {
                    this.Logic.Delete(new long[]{old.RecordId});                   
                }
            }

            return GlobalConstants.EXCEPTION_CODE_NO_ERROR;
        }
    }

    public class MaterialSyncItem
    {
        public string MaterialCode { get; set; }
        public string MaterialName { get; set; }
        public string Description { get; set; }
        public string DataType { get; set; }
    }
}