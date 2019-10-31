

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using Imms.Data.Domain;
using Imms.Mes.Data.Domain;
using Microsoft.EntityFrameworkCore;

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
            try
            {
                this.Synchronizer.SyncData();
            }
            catch (Exception ex)
            {
                GlobalConstants.DefaultLogger.Error("数据同步出现错误：" + ex.Message);
            }
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
        private DbContext dbContext;
        private List<SystemParameter> ParameterList;

        public string ServerHost { get; set; }
        public string LoginUrl { get; set; }
        public string InstoreSyncUrl { get; set; }
        public string MoveSyncUrl { get; set; }
        public string QuanlityCheckSyncUrl { get; set; }
        public int AccountId { get; set; } = 63;

        public SystemParameter last_sync_progress_param { get; set; }   //内部入库数据的最后Id
        public SystemParameter last_sync_progress_ww_param { get; set; } //委外入库数据的最后id
        public SystemParameter last_sync_move_param { get; set; }  //移库数据的最后Id
        public SystemParameter last_sync_qualitycheck_param { get; set; } //品质数据的最后Id

        public WDBSynchronizer()
        {
        }

        public BusinessException SyncData()
        {
            BusinessException result = null;
            try
            {
                lock (typeof(Sync4WDBService))  //同一时间，只能有1个数据同步实例运行
                {
                    this.dbContext = Imms.GlobalConstants.DbContextFactory.GetContext();

                    this.GetLoginParameter(); //获取参数
                    this.LoginToWDB();    //登录
                    this.DoSyncInstoreData(); //入库报工
                    this.DoSyncInstoreWWData(); //委外入库
                    this.DoSyncMovingData();   //移库
                    this.DoSyncQualityCheckdata();  //品质
                }

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
            finally
            {
                this.dbContext.Dispose();
            }
            return result;
        }

        private void GetLoginParameter()
        {
            this.ParameterList = this.dbContext.Set<SystemParameterClass>().Where(x => x.ClassName == "B003").SelectMany(x => x.Parameters).ToList();
            this.ServerHost = this.ParameterList.Single(x => x.ParameterCode == "server_host").ParameterValue;

            this._loginParameter.grant_type = this.ParameterList.Single(x => x.ParameterCode == "grant_type").ParameterValue;
            this._loginParameter.client_id = this.ParameterList.Single(x => x.ParameterCode == "client_id").ParameterValue;
            this._loginParameter.client_secret = this.ParameterList.Single(x => x.ParameterCode == "client_secret").ParameterValue;
            this._loginParameter.username = this.ParameterList.Single(x => x.ParameterCode == "username").ParameterValue;
            this._loginParameter.password = this.ParameterList.Single(x => x.ParameterCode == "password").ParameterValue;

            this.LoginUrl = this.ParameterList.Single(x => x.ParameterCode == "login_url").ParameterValue;
            this.InstoreSyncUrl = this.ParameterList.Single(x => x.ParameterCode == "progress_report_url").ParameterValue;
            this.MoveSyncUrl = this.ParameterList.Single(x => x.ParameterCode == "moving_report_url").ParameterValue;
            this.QuanlityCheckSyncUrl = this.ParameterList.Single(x => x.ParameterCode == "qualitycheck_report_url").ParameterValue;
            string strAccountId = this.ParameterList.Single(x => x.ParameterCode == "account_id").ParameterValue;
            int tempAccountid = 0;
            if (int.TryParse(strAccountId, out tempAccountid))
            {
                this.AccountId = tempAccountid;
            }

            this.last_sync_progress_param = this.ParameterList.Single(x => x.ParameterCode == "last_sync_id_progress");
            this.last_sync_progress_ww_param = this.ParameterList.Single(x => x.ParameterCode == "last_sync_id_progress_ww");
            this.last_sync_move_param = this.ParameterList.Single(x => x.ParameterCode == "last_sync_id_move");
            this.last_sync_qualitycheck_param = this.ParameterList.Single(x => x.ParameterCode == "last_sync_id_qualitycheck");
        }

        private WDBLoginResult LoginToWDB()
        {
            string url = $"{this.ServerHost}/{this.LoginUrl}?grant_type={this._loginParameter.grant_type}&client_id={this._loginParameter.client_id}&client_secret={this._loginParameter.client_secret}&username={this._loginParameter.username}&password={this._loginParameter.password}";
            try
            {
                HttpResponseMessage responseMessage = this.HttpClient.GetAsync(url).GetAwaiter().GetResult();
                responseMessage.EnsureSuccessStatusCode();
                string respContent = responseMessage.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                if (string.IsNullOrEmpty(respContent))
                {
                    throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "登录万达宝服务器无返回");
                }
                GlobalConstants.DefaultLogger.Info("登录成功,返回内容如下:" + respContent);
                this._loginResult = respContent.ToObject<WDBLoginResult>();

                this.HttpClient.DefaultRequestHeaders.Add("authorization", "Bearer " + this._loginResult.access_token);
                this.HttpClient.DefaultRequestHeaders.Add("client_id", this._loginParameter.client_id);
                this.HttpClient.DefaultRequestHeaders.Add("cache-control", "no-cache");
            }
            catch (Exception ex)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "登录万达宝服务器失败：" + ex.Message);
            }

            return this._loginResult;
        }

        private void DoSyncQualityCheckdata()
        {
            if (string.IsNullOrEmpty(this.QuanlityCheckSyncUrl))
            {
                return;
            }
            long last_sync_id = long.Parse(this.last_sync_qualitycheck_param.ParameterValue);
            List<QualityCheck> dataList = this.dbContext.Set<QualityCheck>().Where(x => x.RecordId > last_sync_id).ToList();
            var itemList = dataList.Select(x => new QualitySyncItem
            {
                procode = x.ProductionCode,
                unitcode = "pcs",
                qty = x.Qty,
                wocgcode = x.WocgCode,
                udfbldm = x.DefectCode,
                udfblbm = x.WorkshopCode,
                loccode = x.WorkshopCode + "_BAD"
            }).ToArray();

            QualitySyncData data = new QualitySyncData();
            data.beId = this.AccountId;
            data.doctypeId = 4;
            data.prodpwt = itemList;
            try
            {

                string strData = data.ToJson();
                string reportUrl = this.ServerHost + "/" + this.QuanlityCheckSyncUrl;
                HttpResponseMessage responseMessage = this.HttpClient.PostAsync(reportUrl, new StringContent(strData)).GetAwaiter().GetResult();
                responseMessage.EnsureSuccessStatusCode();

                long lastRecordId = dataList.Max(x => x.RecordId);
                this.last_sync_qualitycheck_param.ParameterValue = lastRecordId.ToString();
                GlobalConstants.ModifyEntityStatus(this.last_sync_qualitycheck_param, dbContext);
                this.dbContext.SaveChanges();
            }
            catch (Exception ex)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "同步品质数据失败：" + ex.Message);
            }
        }

        private void DoSyncMovingData()
        {
            if (string.IsNullOrEmpty(this.MoveSyncUrl))
            {
                return;
            }
            long last_sync_id = long.Parse(this.last_sync_move_param.ParameterValue);
            List<ProductionMoving> dataList = this.dbContext.Set<ProductionMoving>().Where(x => x.RecordId > last_sync_id && x.WorkshopCode != "EV_1").ToList();
            var itemList = dataList.GroupBy(x => new { x.WorkshopCode, x.ProductionCode, x.WorkshopCodeFrom })
            .Select(group => new MoveSyncItem
            {
                loccode = group.Key.WorkshopCodeFrom,
                aloccode = group.Key.WorkshopCode,
                proccode = group.Key.ProductionCode,
                qty = group.Sum(x => x.Qty),
                unitcode = "pcs"
            }).ToArray();

            MoveSyncData data = new MoveSyncData();
            data.beId = this.AccountId;
            data.movet = itemList;
            try
            {
                string strData = data.ToJson();
                string reportUrl = this.ServerHost + "/" + this.MoveSyncUrl;
                HttpResponseMessage responseMessage = this.HttpClient.PostAsync(reportUrl, new StringContent(strData)).GetAwaiter().GetResult();
                responseMessage.EnsureSuccessStatusCode();

                long lastRecordId = dataList.Max(x => x.RecordId);
                this.last_sync_move_param.ParameterValue = lastRecordId.ToString();
                GlobalConstants.ModifyEntityStatus(this.last_sync_move_param, dbContext);
                this.dbContext.SaveChanges();
            }
            catch (Exception ex)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "同步移库数据失败：" + ex.Message);
            }
        }

        private void DoSyncInstoreData()
        {
            if (string.IsNullOrEmpty(this.InstoreSyncUrl))
            {
                return;
            }
            long last_sync_id = long.Parse(this.last_sync_progress_param.ParameterValue);
            List<ProductionOrderProgress> dataList = this.dbContext.Set<ProductionOrderProgress>().Where(x => x.RecordId > last_sync_id && x.WorkshopCode != "EV_2").ToList();
            var itemList = dataList.GroupBy(x => new { x.WorkshopCode, x.ProductionCode, x.WocgCode })
            .Select(group => new InstoreSyncItem
            {
                loccode = group.Key.WorkshopCode,
                proccode = group.Key.ProductionCode,
                wocgcode = group.Key.WocgCode,
                qty = group.Sum(x => x.Qty),
                unitcode = "pcs"
            }).ToArray();

            InstoreSyncData data = new InstoreSyncData();
            data.beId = this.AccountId;
            data.prodpwt = itemList;

            try
            {
                string strData = data.ToJson();
                string reportUrl = this.ServerHost + "/" + this.InstoreSyncUrl;
                HttpResponseMessage responseMessage = this.HttpClient.PostAsync(reportUrl, new StringContent(strData)).GetAwaiter().GetResult();
                responseMessage.EnsureSuccessStatusCode();

                long lastRecordId = dataList.Max(x => x.RecordId);
                this.last_sync_progress_param.ParameterValue = lastRecordId.ToString();
                GlobalConstants.ModifyEntityStatus(this.last_sync_progress_param, dbContext);
                this.dbContext.SaveChanges();
            }
            catch (Exception ex)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "同步入库数据失败：" + ex.Message);
            }
        }

        private void DoSyncInstoreWWData()
        {
            if (string.IsNullOrEmpty(this.InstoreSyncUrl))
            {
                return;
            }
            long last_sync_id = long.Parse(this.last_sync_progress_ww_param.ParameterValue);
            List<ProductionOrderProgress> dataList = this.dbContext.Set<ProductionOrderProgress>().Where(x => x.RecordId > last_sync_id && x.WorkshopCode == "EV_2").ToList();
            var itemList = dataList.GroupBy(x => new { x.WorkshopCode, x.ProductionCode })
            .Select(group => new InstoreSyncItemWW
            {
                loccode = group.Key.WorkshopCode,
                proccode = group.Key.ProductionCode,
                qty = group.Sum(x => x.Qty),
                unitcode = "pcs"
            }).ToArray();

            InstoreSyncDataWW data = new InstoreSyncDataWW();
            data.beId = this.AccountId;
            data.pdcorespwt = itemList;
            try
            {
                string strData = data.ToJson();
                string reportUrl = this.ServerHost + "/" + this.InstoreSyncUrl;
                HttpResponseMessage responseMessage = this.HttpClient.PostAsync(reportUrl, new StringContent(strData)).GetAwaiter().GetResult();
                responseMessage.EnsureSuccessStatusCode();

                long lastRecordId = dataList.Max(x => x.RecordId);
                this.last_sync_progress_ww_param.ParameterValue = lastRecordId.ToString();
                GlobalConstants.ModifyEntityStatus(this.last_sync_progress_ww_param, dbContext);
                this.dbContext.SaveChanges();
            }
            catch (Exception ex)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "同步委外入库数据失败：" + ex.Message);
            }
        }
    }

    public class InstoreSyncData
    {
        public int beId { get; set; }
        public InstoreSyncItem[] prodpwt { get; set; }
    }

    public class InstoreSyncItem
    {
        public string proccode { get; set; }
        public string unitcode { get; set; }
        public int qty { get; set; }
        public string loccode { get; set; }
        public string wocgcode { get; set; }
    }

    public class InstoreSyncDataWW
    {
        public int beId { get; set; }
        public InstoreSyncItemWW[] pdcorespwt { get; set; }
    }

    public class InstoreSyncItemWW
    {
        public string proccode { get; set; }
        public string unitcode { get; set; }
        public int qty { get; set; }
        public string loccode { get; set; }
    }

    public class MoveSyncData
    {
        public int beId { get; set; }

        public MoveSyncItem[] movet { get; set; }
    }

    public class MoveSyncItem
    {
        public string loccode { get; set; } //出
        public string aloccode { get; set; }//入

        public string proccode { get; set; }
        public string unitcode { get; set; }
        public int qty { get; set; }
    }

    public class QualitySyncData
    {
        public int beId { get; set; }
        public int doctypeId { get; set; }
        public QualitySyncItem[] prodpwt { get; set; }
    }
    public class QualitySyncItem
    {
        public string procode { get; set; }
        public string unitcode { get; set; }
        public int qty { get; set; }
        public string wocgcode { get; set; }
        public string udfbldm { get; set; }
        public string udfblbm { get; set; }
        public string loccode { get; set; }
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