using System;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using Imms.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Linq.Dynamic.Core;

namespace Imms
{
    public abstract class SimpleCRUDController<T> : Controller where T : class, IEntity
    {
        [Route("create"), HttpPost]
        public T create(T item)
        {
            return this.doCreate(item);
        }

        [Route("update"), HttpPost]
        public T update(T item)
        {
            return this.doUpdate(item);
        }

        [Route("delete"), HttpPost]
        public int delete(long[] ids)
        {
            this.doDelete(ids);

            return ids.Length;
        }

        [Route("getAll"), HttpGet]
        public ExtJsResult getAll()
        {
            IQueryCollection query = this.HttpContext.Request.Query;
            string filterStr = "(record_id > 0)";
            if(query.ContainsKey("filterExpr")){
                filterStr = query["filterExpr"][0];
                byte[] bytes = Convert.FromBase64String(filterStr);
                filterStr = Encoding.UTF8.GetString(bytes) ;
            }

            if(query.ContainsKey("page") && query.ContainsKey("start") && query.ContainsKey("limit")){
                 int page = int.Parse(query["page"][0]);
                 int start = int.Parse(query["start"][0]);
                 int limit = int.Parse(query["limit"][0]);
                 
                 return this.getAllByPage(page,start,limit,filterStr);
            }
            return getAllWithWhole(filterStr);            
        }

        public ExtJsResult getAllWithWhole(string filterStr){
            ExtJsResult result = new ExtJsResult();
            CommonRepository.UseDbContext(dbContext =>
            {
                var list = dbContext.Set<T>().Where(filterStr);
                result.total = list.Count();
                result.RootProperty = list;
            });
            return result;
        }

        public ExtJsResult getAllByPage(int page,int start,int limit,string filterStr){
            ExtJsResult result = new ExtJsResult();
            CommonRepository.UseDbContext(dbContext =>
            {
                var list = dbContext.Set<T>().Where(filterStr).Skip(start).Take(limit).ToList();
                result.total = dbContext.Set<T>().Where(filterStr).Count();
                result.RootProperty = list;
            });
            return result;
        }

        protected virtual T doCreate(T item)
        {
            CommonRepository.UseDbContext(dbContext =>
            {
                VerifierFactory.Verify(dbContext, item, GlobalConstants.DML_OPERATION_INSERT);
                dbContext.Set<T>().Add(item);

                dbContext.SaveChanges();
            });

            return item;
        }

        protected virtual T doUpdate(T item)
        {
            CommonRepository.UseDbContext(dbContext =>
            {
                VerifierFactory.Verify(dbContext, item, GlobalConstants.DML_OPERATION_INSERT);
                GlobalConstants.ModifyEntityStatus(item, dbContext);
                dbContext.SaveChanges();
            });

            return item;
        }

        protected virtual void doDelete(long[] ids)
        {
            CommonRepository.UseDbContextWithTransaction(dbContext =>
            {
                var items = dbContext.Set<T>().Where(x => ids.Contains((long)x.RecordId));
                foreach (var item in items)
                {
                    dbContext.Set<T>().Remove(item);
                }

                dbContext.SaveChanges();
            });
        }
    }
}