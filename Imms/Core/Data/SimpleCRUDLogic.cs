using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.EntityFrameworkCore;

namespace Imms.Data
{
    public class SimpleCRUDLogic<T> where T : class, IEntity
    {
        public T create(T item)
        {
            CommonRepository.UseDbContext(dbContext =>
            {
                VerifierFactory.Verify(dbContext, item, GlobalConstants.DML_OPERATION_INSERT);
                this.beforeInsert(item, dbContext);

                dbContext.Set<T>().Add(item);
                dbContext.SaveChanges();

                this.afterInsert(item, dbContext);
            });
            return item;
        }


        public T update(T item)
        {
            CommonRepository.UseDbContext(dbContext =>
            {
                VerifierFactory.Verify(dbContext, item, GlobalConstants.DML_OPERATION_UPDATE);
                this.beforeUpdate(item, dbContext);

                GlobalConstants.ModifyEntityStatus(item, dbContext);
                dbContext.SaveChanges();

                this.afterUpdate(item, dbContext);
            });
            return item;
        }


        public int delete(long[] ids)
        {
            CommonRepository.UseDbContextWithTransaction(dbContext =>
            {
                var items = dbContext.Set<T>().Where(x => ids.Contains((long)x.RecordId)).ToList();
                this.beforeDelete(items, dbContext);

                foreach (var item in items)
                {
                    dbContext.Set<T>().Remove(item);
                }
                dbContext.SaveChanges();

                this.afterDelete(items, dbContext);
            });

            return ids.Length;
        }

        public ExtJsResult getAllWithWhole(string filterStr)
        {
            ExtJsResult result = new ExtJsResult();
            CommonRepository.UseDbContext(dbContext =>
            {
                StringBuilder sql = buildSelectSql(filterStr, -1, -1);
                var list = dbContext.Set<T>().FromSql(sql.ToString());
                result.total = list.Count();
                result.RootProperty = list;
            });
            return result;
        }

        private static StringBuilder buildSelectSql(string filterStr, int start, int limit)
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

        private static StringBuilder buildTotalCountSql(string filterStr)
        {
            StringBuilder sql = new StringBuilder("select count(*) from " + ImmsDbContext.GetEntityTableName<T>());
            if (!string.IsNullOrEmpty(filterStr))
            {
                sql.Append(" where ").Append(filterStr);
            }

            return sql;
        }

        public ExtJsResult getAllByPage(int page, int start, int limit, string filterStr)
        {
            ExtJsResult result = new ExtJsResult();
            CommonRepository.UseDbContext(dbContext =>
            {
                StringBuilder selectBuilder = buildSelectSql(filterStr, start, limit);
                var list = dbContext.Set<T>().FromSql(selectBuilder.ToString()).ToList();

                StringBuilder countBuilder = buildTotalCountSql(filterStr);
                long count = (long)dbContext.Database.ExecuteSqlScalar(countBuilder.ToString());
                result.total = (int)count;
                result.RootProperty = list;
            });
            return result;
        }

        protected virtual void beforeInsert(T item, DbContext dbContext) { }
        protected virtual void afterInsert(T item, DbContext dbContext) { }

        protected virtual void beforeUpdate(T item, DbContext dbContext) { }
        protected virtual void afterUpdate(T item, DbContext dbContext) { }

        protected virtual void beforeDelete(List<T> item, DbContext dbContext) { }
        protected virtual void afterDelete(List<T> item, DbContext dbContext) { }
    }
}