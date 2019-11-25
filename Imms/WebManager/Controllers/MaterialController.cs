using System.Collections.Generic;
using Imms.Data;
using Imms.Mes.Data;
using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.Http;
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
            if (syncItem.DataType != 0 && syncItem.DataType != 1 && syncItem.DataType != 2)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_PARAMETER_INVALID, "记录类型DataType错误，必须是'0(新增)'、'1(修改)'、'2(删除)'三者之一");
            }

            Material material = new Material()
            {
                MaterialCode = syncItem.MaterialCode,
                MaterialName = syncItem.MaterialName,
                Description = "",
            };

            if (syncItem.DataType == 0)
            {
                this.Logic.Create(material);
            }
            else
            {
                FilterExpression[] filterExpressions = new FilterExpression[]{
                    new FilterExpression(){L="materialCode",O="=",R=material.MaterialCode}
                };

                Material old = this.Logic.GetByOne(filterExpressions);
                if (old == null)
                {
                    throw new BusinessException(GlobalConstants.EXCEPTION_CODE_DATA_NOT_FOUND, $"系统不存在materialCode=\"{material.MaterialCode}\"的产品或物料!");
                }
                old.MaterialCode = material.MaterialCode;
                old.MaterialName = material.MaterialName;

                if (syncItem.DataType == 1)
                {
                    this.Logic.Update(old);
                }
                else if (syncItem.DataType == 2)
                {
                    this.Logic.Delete(new long[] { old.RecordId });
                }
            }

            return GlobalConstants.EXCEPTION_CODE_NO_ERROR;
        }
    }


    [Route("api/imms/material/materialStock")]
    public class MaterialStockController : SimpleCRUDController<MaterialStock>
    {
        public MaterialStockController() => this.Logic = new SimpleCRUDLogic<MaterialStock>();
    }


    [Route("api/imms/material/bom")]
    public class BomController : SimpleCRUDController<Bom>
    {
        private BomLogic bomLogic { get; set; }
        public BomController()
        {            
            this.bomLogic = new BomLogic();
            this.Logic = this.bomLogic;
        }

        [Route("getBomByMaterialCode"), HttpGet]
        public ExtJsResult GetBomByMaterialCode(string materialCode)
        {
            IQueryCollection query = this.HttpContext.Request.Query;

            int page = int.Parse(query["page"][0]);
            int start = int.Parse(query["start"][0]);
            int limit = int.Parse(query["limit"][0]);
            FilterExpression expression = new FilterExpression()
            {
                L = "MaterialCode",
                O = "=",
                R = materialCode
            };

            ExtJsResult result = Logic.GetAllWithExtResult(page, start, limit, new FilterExpression[] { expression });
            return result;
        }

    }

    public class MaterialSyncItem
    {
        public string MaterialCode { get; set; }
        public string MaterialName { get; set; }
        public string Description { get; set; }
        public int DataType { get; set; }
    }
}