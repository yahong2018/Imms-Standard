using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Imms.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Imms
{
    public abstract class SimpleCRUDController<T> : Controller where T : class, IEntity
    {
        protected SimpleCRUDLogic<T> Logic { get; set; }
        protected GetDataDelegate<T> AfterGetDataHandler { get; set; }

        [Route("create"), HttpPost]
        public T Create(T item)
        {
            this.Verify(item, GlobalConstants.DML_OPERATION_INSERT);
            return Logic.Create(item);
        }

        [Route("update"), HttpPost]
        public T Update(T item)
        {
            this.Verify(item, GlobalConstants.DML_OPERATION_UPDATE);
            return Logic.Update(item);
        }

        [Route("delete"), HttpPost]
        public int Delete([FromBody]long[] ids)
        {
            return Logic.Delete(ids);
        }

        [Route("getAll"), HttpGet]
        public ExtJsResult GetAll()
        {
            return this.DoGetAll();
        }

        protected virtual void Verify(T item, int operation) { }

        protected virtual ExtJsResult DoGetAll()
        {
            string filterStr = this.GetFilterString();
            ExtJsResult result = null;
            if (IsGetByPage())
            {
                IQueryCollection query = this.HttpContext.Request.Query;

                int page = int.Parse(query["page"][0]);
                int start = int.Parse(query["start"][0]);
                int limit = int.Parse(query["limit"][0]);

                result = Logic.GetAllByPage(page, start, limit, filterStr,this.AfterGetDataHandler);
            }
            else
            {
                result = Logic.GetAllWithWhole(filterStr,this.AfterGetDataHandler);
            }
            return result;
        }

        protected virtual bool IsGetByPage()
        {
            IQueryCollection query = this.HttpContext.Request.Query;
            return query.ContainsKey("page") && query.ContainsKey("start") && query.ContainsKey("limit");
        }

        protected virtual string GetFilterString()
        {
            IQueryCollection query = this.HttpContext.Request.Query;
            string filterStr = "";
            if (query.ContainsKey("filterExpr"))
            {
                filterStr = query["filterExpr"][0];
                byte[] bytes = Convert.FromBase64String(filterStr);
                filterStr = Encoding.UTF8.GetString(bytes);
            }
            return filterStr;
        }
    }
}