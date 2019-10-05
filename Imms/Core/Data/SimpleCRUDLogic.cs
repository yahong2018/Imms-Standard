using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.EntityFrameworkCore;

namespace Imms.Data
{
    public class SimpleCRUDLogic<T> where T : class, IEntity
    {
        public T Create(T item)
        {
            CommonRepository.UseDbContextWithTransaction(dbContext =>
            {
                this.Create(item, dbContext);
            });
            return item;
        }

        public T Update(T item)
        {
            CommonRepository.UseDbContextWithTransaction(dbContext =>
            {
                this.Update(item, dbContext);
            });
            return item;
        }

        public int Delete(long[] ids)
        {
            CommonRepository.UseDbContextWithTransaction(dbContext =>
            {
                Delete(ids, dbContext);
            });

            return ids.Length;
        }

        public void Create(T item, DbContext dbContext)
        {
            VerifierFactory.Verify(dbContext, item, GlobalConstants.DML_OPERATION_INSERT);
            this.BeforeInsert(item, dbContext);

            dbContext.Set<T>().Add(item);
            dbContext.SaveChanges();

            this.AfterInsert(item, dbContext);
        }

        public void Update(T item, DbContext dbContext)
        {
            VerifierFactory.Verify(dbContext, item, GlobalConstants.DML_OPERATION_UPDATE);
            this.BeforeUpdate(item, dbContext);

            GlobalConstants.ModifyEntityStatus(item, dbContext);
            dbContext.SaveChanges();

            this.AfterUpdate(item, dbContext);
        }        

        public void Delete(long[] ids, DbContext dbContext)
        {
            var items = dbContext.Set<T>().Where(x => ids.Contains((long)x.RecordId)).ToList();
            this.BeforeDelete(items, dbContext);

            foreach (var item in items)
            {
                dbContext.Set<T>().Remove(item);
            }
            dbContext.SaveChanges();

            this.AfterDelete(items, dbContext);
        }

        public ExtJsResult GetAllWithWhole(string filterStr)
        {
            ExtJsResult result = new ExtJsResult();
            CommonRepository.UseDbContext(dbContext =>
            {
                StringBuilder sql = BuildSelectSql(filterStr, -1, -1);
                var list = dbContext.Set<T>().FromSql(sql.ToString());
                result.total = list.Count();
                result.RootProperty = list;
            });
            return result;
        }

        private static StringBuilder BuildSelectSql(string filterStr, int start, int limit)
        {
            StringBuilder sql = new StringBuilder("select * from " + ImmsDbContext.GetEntityTableName<T>());
            if (!string.IsNullOrEmpty(filterStr) || start != -1)
            {
                if (!string.IsNullOrEmpty(filterStr))
                {
                    sql.Append(" where ").Append(filterStr);
                }

                if (start != -1)
                {
                    sql.Append(" limit ").Append(start);
                }
                if (limit != -1)
                {
                    sql.Append(",").Append(limit);
                }
            }

            return sql;
        }

        private static StringBuilder BuildTotalCountSql(string filterStr)
        {
            StringBuilder sql = new StringBuilder("select count(*) from " + ImmsDbContext.GetEntityTableName<T>());
            if (!string.IsNullOrEmpty(filterStr))
            {
                sql.Append(" where ").Append(filterStr);
            }

            return sql;
        }

        public ExtJsResult GetAllByPage(int page, int start, int limit, string filterStr)
        {
            ExtJsResult result = new ExtJsResult();
            CommonRepository.UseDbContext(dbContext =>
            {
                StringBuilder selectBuilder = BuildSelectSql(filterStr, start, limit);
                var list = this.DoGetData(selectBuilder.ToString(), dbContext).ToList();

                StringBuilder countBuilder = BuildTotalCountSql(filterStr);
                long count = (long)dbContext.Database.ExecuteSqlScalar(countBuilder.ToString());
                result.total = (int)count;
                result.RootProperty = list;
            });
            return result;
        }

        protected virtual void BeforeInsert(T item, DbContext dbContext) { }
        protected virtual void AfterInsert(T item, DbContext dbContext) { }

        protected virtual void BeforeUpdate(T item, DbContext dbContext) { }
        protected virtual void AfterUpdate(T item, DbContext dbContext) { }

        protected virtual void BeforeDelete(List<T> item, DbContext dbContext) { }
        protected virtual void AfterDelete(List<T> item, DbContext dbContext) { }

        protected virtual List<T> DoGetData(string sql, DbContext dbContext)
        {
            return dbContext.Set<T>().FromSql(sql).ToList();
        }
    }
}