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

        [Route("create"), HttpPost]
        public T create(T item)
        {
            return Logic.create(item);
        }

        [Route("update"), HttpPost]
        public T update(T item)
        {
            return Logic.update(item);
        }

        [Route("delete"), HttpPost]
        public int delete([FromBody]long[] ids)
        {
            return Logic.delete(ids);
        }

        [Route("getAll"), HttpGet]
        public ExtJsResult getAll()
        {
            IQueryCollection query = this.HttpContext.Request.Query;
            string filterStr = "";
            if (query.ContainsKey("filterExpr"))
            {
                filterStr = query["filterExpr"][0];
                byte[] bytes = Convert.FromBase64String(filterStr);
                filterStr = Encoding.UTF8.GetString(bytes);
            }

            if (query.ContainsKey("page") && query.ContainsKey("start") && query.ContainsKey("limit"))
            {
                int page = int.Parse(query["page"][0]);
                int start = int.Parse(query["start"][0]);
                int limit = int.Parse(query["limit"][0]);

                return Logic.getAllByPage(page, start, limit, filterStr);
            }
            return Logic.getAllWithWhole(filterStr);
        }
    }
}