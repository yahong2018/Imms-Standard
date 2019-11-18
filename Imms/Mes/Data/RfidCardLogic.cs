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
    }
}