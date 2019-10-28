

using System;
using System.Linq;
using System.Net.Http;
using Imms.Data.Domain;

namespace Imms.WebManager
{
    public class Sync4WDBService : BaseService
    {
        private IHttpClientFactory _factory;
        public DateTime NextRunTime { get; set; } = DateTime.Now;
        public WDBSynchronizer Synchronizer { get; set; } = new WDBSynchronizer();

        public Sync4WDBService(IHttpClientFactory factory)
        {
            this._factory = factory;
        }

        protected override void DoInternalThreadProc()
        {
            DateTime currentTime = DateTime.Now;
            if (currentTime < this.NextRunTime)
            {
                return;
            }
            this.NextRunTime = currentTime.AddMinutes(120);  //暂定120分钟(2个小时)同步一次

            HttpClient httpClient = this.GetHttpClient4WDB();
            this.Synchronizer.HttpClient = httpClient;
            this.Synchronizer.SyncData();
        }

        public HttpClient GetHttpClient4WDB()
        {
            return this._factory.CreateClient("SYNC_DATA_WDB");
        }
    }

    public class WDBSynchronizer
    {
        public HttpClient HttpClient { get; set; }
        private WDBLoginParameter _loginParameter = new WDBLoginParameter();
        private WDBLoginResult _loginResult = new WDBLoginResult();

        public string ServerHost { get; set; };
        public string LoginUrl { get; set; }
        public string InstoreSyncUrl { get; set; }
        public string MoveSyncUrl { get; set; }
        public string QuanlityCheckSyncUrl { get; set; }
        public int AccountId { get; set; } = 63;

        public WDBSynchronizer()
        {
        }

        public BusinessException SyncData()
        {
            BusinessException result = null;
            try
            {
                this.GetLoginParameter(); //获取参数
                this.LoginToWDB();    //登录
                this.DoSyncInstoreData(); //入库报工
                this.DoSyncInstoreWWData(); //委外入库
                this.DoSyncMovingData();   //移库
                this.DoSyncQualityCheckdata();  //品质

                result = new BusinessException(GlobalConstants.EXCEPTION_CODE_NO_ERROR, "成功同步");
            }
            catch (Exception ex)
            {
                if (ex is BusinessException)
                {
                    result = ex as BusinessException;
                }
                else
                {
                    result = new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, ex.Message);
                }
            }
            return result;
        }

        private void GetLoginParameter()
        {
            Imms.Data.CommonRepository.UseDbContext(dbContext =>
            {
                var list = dbContext.Set<SystemParameterClass>().Where(x => x.ClassName == "B003").SelectMany(x => x.Parameters).ToList();
                this.ServerHost = list.Single(x => x.ParameterCode == "server_host").ParameterValue;

                this._loginParameter.grant_type = list.Single(x => x.ParameterCode == "grant_type").ParameterValue;
                this._loginParameter.client_id = list.Single(x => x.ParameterCode == "client_id").ParameterValue;
                this._loginParameter.client_secret = list.Single(x => x.ParameterCode == "client_secret").ParameterValue;
                this._loginParameter.username = list.Single(x => x.ParameterCode == "username").ParameterValue;
                this._loginParameter.password = list.Single(x => x.ParameterCode == "password").ParameterValue;

                this.LoginUrl = list.Single(x => x.ParameterCode == "login_url").ParameterValue;
                this.InstoreSyncUrl = list.Single(x => x.ParameterCode == "progress_report_url").ParameterValue;
                this.MoveSyncUrl = list.Single(x => x.ParameterCode == "moving_report_url").ParameterValue;
                this.QuanlityCheckSyncUrl = list.Single(x => x.ParameterCode == "qualitycheck_report_url").ParameterValue;
                string strAccountId = list.Single(x => x.ParameterCode == "account_id").ParameterValue;
                int tempAccountid = 0;
                if (int.TryParse(strAccountId, out tempAccountid))
                {
                    this.AccountId = tempAccountid;
                }
            });
        }

        private WDBLoginResult LoginToWDB()
        {
            string url = $"{this.ServerHost}/{this.LoginUrl}?grant_type={this._loginParameter.grant_type}&client_id={this._loginParameter.client_id}&client_secret={this._loginParameter.client_secret}&username={this._loginParameter.username}&password={this._loginParameter.password}";
            HttpResponseMessage responseMessage = this.HttpClient.GetAsync(url).GetAwaiter().GetResult();
            responseMessage.EnsureSuccessStatusCode();
            string respContent = responseMessage.Content.ReadAsStringAsync().GetAwaiter().GetResult();
            if (string.IsNullOrEmpty(respContent))
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "登录万达宝服务器无返回");
            }
            try
            {
                this._loginResult = respContent.ToObject<WDBLoginResult>();

                this.HttpClient.DefaultRequestHeaders.Add("authorization", "Bearer " + this._loginResult.access_token);
                this.HttpClient.DefaultRequestHeaders.Add("client_id", this._loginParameter.client_id);
                this.HttpClient.DefaultRequestHeaders.Add("cache-control", "no-cache");
            }
            catch (Exception ex)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "登录万达宝服务器失败，返回消息如下：\r\n" + respContent);
            }

            return this._loginResult;
        }

        private void DoSyncQualityCheckdata()
        {
            //throw new NotImplementedException();
        }

        private void DoSyncMovingData()
        {
            if (string.IsNullOrEmpty(this.MoveSyncUrl))
            {
                return;
            }

            MoveSyncData data = new MoveSyncData();
            data.beld = this.AccountId;
            data.movet = new MoveSyncItem[]{
                new MoveSyncItem(){proccode="iphone",unitcode="pcs",qty=23},
                new MoveSyncItem(){proccode="iphonex",unitcode="pcs",qty=23},
            };
            data.loccode = "YZ"; //移出仓库
            data.aloccode = "CJG";//移入仓库    

            string strData = data.ToJson();
            string reportUrl = this.ServerHost + "/" + this.MoveSyncUrl;
            HttpResponseMessage responseMessage = this.HttpClient.PostAsync(reportUrl, new StringContent(strData)).GetAwaiter().GetResult();
            responseMessage.EnsureSuccessStatusCode();
        }

        private void DoSyncInstoreData()
        {
            if (string.IsNullOrEmpty(this.InstoreSyncUrl))
            {
                return;
            }

            InstoreSyncData data = new InstoreSyncData();
            data.beld = this.AccountId;
            data.prodpwt = new InstoreSyncItem[]{
                new InstoreSyncItem(){proccode="iphone",unitcode="pcs",qty=23},
                new InstoreSyncItem(){proccode="iphonex",unitcode="pcs",qty=23},
            };

            string strData = data.ToJson();
            string reportUrl = this.ServerHost + "/" + this.InstoreSyncUrl;
            HttpResponseMessage responseMessage = this.HttpClient.PostAsync(reportUrl, new StringContent(strData)).GetAwaiter().GetResult();
            responseMessage.EnsureSuccessStatusCode();
        }

        private void DoSyncInstoreWWData()
        {
            if (string.IsNullOrEmpty(this.InstoreSyncUrl))
            {
                return;
            }

            InstoreSyncDataWW data = new InstoreSyncDataWW();
            data.beld = this.AccountId;
            data.pdcorespwt = new InstoreSyncItem[]{
                new InstoreSyncItem(){proccode="iphone",unitcode="pcs",qty=23},
                new InstoreSyncItem(){proccode="iphonex",unitcode="pcs",qty=23},
            };

            string strData = data.ToJson();
            string reportUrl = this.ServerHost + "/" + this.InstoreSyncUrl;
            HttpResponseMessage responseMessage = this.HttpClient.PostAsync(reportUrl, new StringContent(strData)).GetAwaiter().GetResult();
            responseMessage.EnsureSuccessStatusCode();
        }
    }

    public class InstoreSyncData
    {
        public int beld { get; set; }
        public InstoreSyncItem[] prodpwt { get; set; }
    }

    public class InstoreSyncDataWW
    {
        public int beld { get; set; }
        public InstoreSyncItem[] pdcorespwt { get; set; }
    }

    public class InstoreSyncItem
    {
        public string proccode { get; set; }
        public string unitcode { get; set; }
        public int qty { get; set; }
    }

    public class MoveSyncData
    {
        public int beld { get; set; }
        public string loccode { get; set; }
        public string aloccode { get; set; }
        public MoveSyncItem[] movet { get; set; }
    }

    public class MoveSyncItem
    {
        public string proccode { get; set; }
        public string unitcode { get; set; }
        public int qty { get; set; }
    }

    public class WDBLoginParameter
    {
        public string grant_type { get; set; }
        public string client_id { get; set; }
        public string client_secret { get; set; }
        public string username { get; set; }
        public string password { get; set; }
    }

    public class WDBLoginResult
    {
        public string access_token { get; set; }
        public string refresh_token { get; set; }
        public int uid { get; set; }
        public string token_type { get; set; }
    }
}