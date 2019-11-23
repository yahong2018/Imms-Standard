using Imms.Data;
using Imms.Mes.Data.Domain;

namespace Imms.Mes.Data
{
    public class RfidCardLogic : SimpleCRUDLogic<RfidCard>
    {
        public RfidCard GetByKanbanAndMaterialCode(string kanbanNo, string materialCode)
        {
            return CommonRepository.GetOneByFilter<RfidCard>(x => x.KanbanNo == kanbanNo && x.ProductionCode == materialCode);
        }

        protected override void BeforeInsert(RfidCard item, Microsoft.EntityFrameworkCore.DbContext dbContext){
            if(string.IsNullOrEmpty(item.TowerNo)){
                item.TowerNo = "";
            }
        }

        protected override void BeforeUpdate(RfidCard item, Microsoft.EntityFrameworkCore.DbContext dbContext){
            if (string.IsNullOrEmpty(item.TowerNo))
            {
                item.TowerNo = "";
            }
        }
    }
}