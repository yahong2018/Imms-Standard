using System.Collections.Generic;
using Imms.Data;
using Imms.Mes.Data.Domain;

namespace Imms.Mes.Data
{
    public class BomLogic : SimpleCRUDLogic<Bom>
    {
        public Bom[] GetBomByMaterialCode(string materialCode)
        {
            return CommonRepository.GetAllByFilter<Bom>(x => x.MaterialCode == materialCode);
        }

        protected override void BeforeInsert(Bom item, Microsoft.EntityFrameworkCore.DbContext dbContext)
        {
            if (string.IsNullOrEmpty(item.BomNo))
            {
                item.BomNo = "";
            }
        }

        protected override void BeforeUpdate(Bom item, Microsoft.EntityFrameworkCore.DbContext dbContext)
        {
            if (string.IsNullOrEmpty(item.BomNo))
            {
                item.BomNo = "";
            }
        }
    }
}