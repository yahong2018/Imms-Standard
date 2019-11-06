
using System.Net.Http;
using Imms.Data.Domain;
using Imms.Mes.Services;
using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager.Controllers
{

    [Route("api/admin/systemParameter")]
    public class SystemParameterController : SimpleCRUDController<SystemParameter>
    {     
        private Sync4WDBService _syncService;
        public SystemParameterController(Sync4WDBService syncService)
        {
            this._syncService = syncService;
            this.Logic = new Data.SimpleCRUDLogic<SystemParameter>();
        }

        [Route("sync_wdb")]
        public string Sync2WDB()
        {
            return this._syncService.SyncData().ToString();             
        }
    }
}