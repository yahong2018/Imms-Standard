using System;
using System.Linq;
using System.Text;
using Imms.Data;
using Imms.Mes.Data.Domain;
using Imms.Security.Data.Domain;
using Microsoft.EntityFrameworkCore;

namespace Imms.Mes.Controllers
{
    public class OrgFilterController<T> : SimpleCRUDController<T> where T : class, IEntity
    {
        public const string ROLE_FILTER_BY_WORKSHOP = "FILTER_BY_WORKSHOP";

        protected OrgFilterController()
        {
        }

        protected override string GetFilterString()
        {
            string oldFilterString = base.GetFilterString();
            long workshopId = this.GetFilterByWorkshopId();
            if (workshopId <= 0)
            {
                return oldFilterString;
            }
            FilterExpression[] expressions;
            FilterExpression filterOrg = this.GetOrgFilterExpression(workshopId);

            if (!string.IsNullOrEmpty(oldFilterString))
            {
                FilterExpression[] oldFilter = oldFilterString.ToObject<FilterExpression[]>();
                filterOrg.J = "&&";
                expressions = new FilterExpression[oldFilter.Length + 1] ;
                int i=0;
                for(;i<oldFilter.Length;i++){
                    expressions[i] = oldFilter[i];
                }
                expressions[i] = filterOrg;
            }
            else
            {
                expressions = new FilterExpression[] { filterOrg };
            }
            return expressions.ToJson();
        }

        protected virtual FilterExpression GetOrgFilterExpression(long workshopId)
        {
            FilterExpression filterOrg = new FilterExpression();
            filterOrg.L = "workshopId";
            filterOrg.O = "=";
            filterOrg.R = workshopId.ToString();
            return filterOrg;
        }

        private long GetFilterByWorkshopId()
        {
            SystemUser currentUser = GlobalConstants.GetCurrentUser();
            using (DbContext dbContext = GlobalConstants.DbContextFactory.GetContext())
            {
                if (dbContext.Set<RoleUser>().Where(x => x.UserId == currentUser.RecordId && x.Role.RoleCode == ROLE_FILTER_BY_WORKSHOP).Count() > 0)
                {
                    return dbContext.Set<Operator>().Where(x => x.EmployeeId == currentUser.UserCode).Select(x => x.orgId).FirstOrDefault();
                }
            }
            return -1;
        }
    }

    public class StoreFilterController : OrgFilterController<MaterialStock>
    {
        protected override FilterExpression GetOrgFilterExpression(long workshopId)
        {
            FilterExpression filterOrg = new FilterExpression();
            filterOrg.L = "storeId";
            filterOrg.O = "=";
            filterOrg.R = workshopId.ToString();
            return filterOrg;
        }
    }
}