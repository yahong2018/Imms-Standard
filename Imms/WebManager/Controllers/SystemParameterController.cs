
using System.Net.Http;
using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager.Controllers{

    [Route("api/system/parameter")]
    public class SystemParameterController:Controller
    {
        private Sync4WDBService _syncService;
        public SystemParameterController(Sync4WDBService syncService){
            this._syncService = syncService;
        }    

        [Route("sync_wdb")]
        public string Sync2WDB(){
            WDBSynchronizer synchronizer = new WDBSynchronizer();
            synchronizer.HttpClient = this._syncService.GetHttpClient4WDB();
            return synchronizer.SyncData().ToString();
        }  
    }
}