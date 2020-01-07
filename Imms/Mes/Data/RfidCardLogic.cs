using Imms.Data;
using Imms.Mes.Data.Domain;
using Imms.Security.Data.Domain;

namespace Imms.Mes.Data
{
    public class RfidCardLogic : SimpleCRUDLogic<RfidCard>
    {
        public RfidCard GetByKanbanAndMaterialCode(string kanbanNo, string materialCode)
        {
            return CommonRepository.GetOneByFilter<RfidCard>(x => x.KanbanNo == kanbanNo && x.ProductionCode == materialCode);
        }

        protected override void BeforeInsert(RfidCard item, Microsoft.EntityFrameworkCore.DbContext dbContext)
        {
            if (string.IsNullOrEmpty(item.TowerNo))
            {
                item.TowerNo = "";
            }
        }
        
        protected override void AfterInsert(RfidCard item, Microsoft.EntityFrameworkCore.DbContext dbContext)
        {
            CardIssue issue = new CardIssue();
            issue.CardNo = item.RfidNo;
            issue.CardId = item.RecordId;

            issue.WorkstationId = -1;
            issue.WorkstationCode = "";
            issue.WorkstationName = "";

            SystemUser currentUser = GlobalConstants.GetCurrentUser();
            issue.IssueUserId = currentUser.RecordId;
            issue.IssueUserCode = currentUser.UserCode;
            issue.IssueUserName = currentUser.UserName;

            issue.IssueQty = item.IssueQty;

            dbContext.Add(issue);
            dbContext.SaveChanges();
        }

        protected override void BeforeUpdate(RfidCard item, Microsoft.EntityFrameworkCore.DbContext dbContext)
        {
            if (string.IsNullOrEmpty(item.TowerNo))
            {
                item.TowerNo = "";
            }
        }
    }
}