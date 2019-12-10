using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;
using Imms.Data;
using Imms.Data.Domain;
using Imms.Mes.Data.Domain;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace Imms.Mes.Services
{
    public class Sync4WDBService : BaseService
    {
        private IHttpClientFactory _factory;
        public DateTime NextRunTime { get; set; } = DateTime.Now;
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

            try
            {
                DbContext dbContext = GlobalConstants.DbContextFactory.GetContext();
                string strCycle = dbContext.Set<SystemParameter>()
                .Where(x => x.ParameterClassCode == "B003" && x.ParameterCode == "sync_cycle_minutes")
                .Select(x => x.ParameterValue)
                .FirstOrDefault();
                int cylce = 120;
                int.TryParse(strCycle, out cylce);
                if (cylce <= 0)
                {
                    this.NextRunTime = currentTime.AddMinutes(5);
                    return;
                }
                this.NextRunTime = currentTime.AddMinutes(cylce);

                this.SyncData();
            }
            catch (Exception ex)
            {
                GlobalConstants.DefaultLogger.Error("数据同步出现错误：" + ex.Message);
            }
        }

        public BusinessException SyncData()
        {
            WDBSynchronizer synchronizer = new WDBSynchronizer(this._factory);
            return synchronizer.SyncData();
        }
    }

    public class WDBSynchronizer
    {
        private IHttpClientFactory _factory;
        private WDBLoginParameter _loginParameter = new WDBLoginParameter();
        private WDBLoginResult _loginResult = new WDBLoginResult();
        private DbContext dbContext { get; set; }
        private List<SystemParameter> ParameterList;

        public string ServerHost { get; set; }
        public string LoginUrl { get; set; }
        public string InstoreSyncUrl { get; set; }
        public string MoveSyncUrl { get; set; }
        public string QualityCheckSyncUrl { get; set; }
        public string BomSyncUrl { get; set; }
        public int AccountId { get; set; } = 63;

        public WDBSynchronizer(IHttpClientFactory factory)
        {
            this._factory = factory;
        }

        public BusinessException SyncData()
        {
            BusinessException result = null;
            try
            {
                lock (typeof(Sync4WDBService))  //同一时间，只能有1个数据同步实例运行
                {
                    this.dbContext = Imms.GlobalConstants.DbContextFactory.GetContext();

                    this.Initarameters(); //获取参数
                    this.LoginToWDB();    //登录
                    List<Workshop> firstWorkshopList = this.dbContext.Set<Workshop>().Where(x => x.PrevOperationIndex == -1).ToList();
                    foreach (Workshop workshop in firstWorkshopList)
                    {
                        this.SyncWorkshopData(workshop);
                    }

                    this.GetBom(); //同步BOM的数据
                }

                result = new BusinessException(GlobalConstants.EXCEPTION_CODE_NO_ERROR, "同步完成");
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
                // this.dbContext.Dispose();
            }
            return result;
        }

        private void SyncWorkshopData(Workshop workshop)
        {
            if (workshop.WorkshopType != 3)
            {
                this.PushInstoreData(workshop); //入库报工
            }
            if (workshop.WorkshopType == 4)
            {
                this.PushInstoreWWData(workshop); //委外入库
            }

            this.PushMovingData(workshop);   //移库
            this.PushQualityCheckData(workshop);  //品质

            List<Workshop> nextList = this.dbContext.Set<Workshop>().Where(x => x.PrevOperationIndex == workshop.OperationIndex).ToList();
            foreach (Workshop next in nextList)
            {
                this.SyncWorkshopData(next);
            }
        }

        private void Initarameters()
        {
            this.ParameterList = this.dbContext.Set<SystemParameter>().Where(x => x.ParameterClassCode == "B003").ToList();
            this.ServerHost = this.ParameterList.Single(x => x.ParameterCode == "server_host").ParameterValue;

            this._loginParameter.grant_type = this.ParameterList.Single(x => x.ParameterCode == "grant_type").ParameterValue;
            this._loginParameter.client_id = this.ParameterList.Single(x => x.ParameterCode == "client_id").ParameterValue;
            this._loginParameter.client_secret = this.ParameterList.Single(x => x.ParameterCode == "client_secret").ParameterValue;
            this._loginParameter.username = this.ParameterList.Single(x => x.ParameterCode == "username").ParameterValue;
            this._loginParameter.password = this.ParameterList.Single(x => x.ParameterCode == "password").ParameterValue;

            this.LoginUrl = this.ParameterList.Single(x => x.ParameterCode == "login_url").ParameterValue;
            this.InstoreSyncUrl = this.ParameterList.Single(x => x.ParameterCode == "progress_report_url").ParameterValue;
            this.MoveSyncUrl = this.ParameterList.Single(x => x.ParameterCode == "moving_report_url").ParameterValue;
            this.QualityCheckSyncUrl = this.ParameterList.Single(x => x.ParameterCode == "qualitycheck_report_url").ParameterValue;
            this.BomSyncUrl = this.ParameterList.Single(x => x.ParameterCode == "bom_get_url").ParameterValue;
            string strAccountId = this.ParameterList.Single(x => x.ParameterCode == "account_id").ParameterValue;
            int tempAccountid = 0;
            if (int.TryParse(strAccountId, out tempAccountid))
            {
                this.AccountId = tempAccountid;
            }
        }

        private WDBLoginResult LoginToWDB()
        {
            string url = $"{this.ServerHost}/{this.LoginUrl}?grant_type={this._loginParameter.grant_type}&client_id={this._loginParameter.client_id}&client_secret={this._loginParameter.client_secret}&username={this._loginParameter.username}&password={this._loginParameter.password}";
            try
            {
                using (HttpClient client = this._factory.CreateClient())
                {
                    HttpResponseMessage responseMessage = client.GetAsync(url).GetAwaiter().GetResult();
                    responseMessage.EnsureSuccessStatusCode();
                    string respContent = responseMessage.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                    if (string.IsNullOrEmpty(respContent))
                    {
                        throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "登录万达宝服务器无返回");
                    }
                    GlobalConstants.DefaultLogger.Info("登录成功,返回内容如下:" + respContent);
                    this._loginResult = respContent.ToObject<WDBLoginResult>();
                }
            }
            catch (Exception ex)
            {
                throw new BusinessException(GlobalConstants.EXCEPTION_CODE_CUSTOM, "登录万达宝服务器失败：" + ex.Message);
            }

            return this._loginResult;
        }

        private void GetBom()
        {
            if (string.IsNullOrEmpty(this.BomSyncUrl))
            {
                return;
            }
            var materialList = this.dbContext.Set<Material>().Where(x =>
                !this.dbContext.Set<Bom>().Select(b => b.MaterialId == x.RecordId).Any()
            ).ToList();
            if (materialList.Count == 0)
            {
                return;
            }

            var materialCodeList = materialList.Select(x => x.MaterialCode).ToArray();

            //  materialList = new string[] { "5502-04060" };

            string getBaseUrl = this.ServerHost + "/" + this.BomSyncUrl;
            using (HttpClient client = this._factory.CreateClient())
            {
                this.FillAuthorizationHeader(client);
                int i = 0;
                foreach (string materialCode in materialCodeList)
                {
                    string getUrl = getBaseUrl + "/" + materialCode;
                    HttpResponseMessage result = client.GetAsync(getUrl).GetAwaiter().GetResult();
                    try
                    {
                        result.EnsureSuccessStatusCode();

                        string respContent = result.Content.ReadAsStringAsync().GetAwaiter().GetResult();
                        if (!string.IsNullOrEmpty(respContent))
                        {
                            BomSyncData bomSyncData = respContent.ToObject<BomSyncData>();

                            foreach (BomSyncItem bomItem in bomSyncData.Values)
                            {
                                Material material = materialList.Where(x => x.MaterialCode == bomItem.ProCode).FirstOrDefault();
                                if (material == null)
                                {
                                    GlobalConstants.DefaultLogger.Error("导入物料" + materialCode + "的BOM数据错误,ERP的BOM数据错误，物料" + bomItem.ProCode + "不存在!");
                                    continue;
                                }

                                Material component = materialList.Where(x => x.MaterialCode == bomItem.MatCode).FirstOrDefault();
                                if (material == null)
                                {
                                    GlobalConstants.DefaultLogger.Error("导入物料" + materialCode + "的BOM数据错误,ERP的BOM数据错误，组件" + bomItem.MatCode + "不存在!");
                                    continue;
                                }

                                Bom bom = new Bom();
                                bom.BomNo = bomItem.BomCode;
                                bom.BomStatus = 1;
                                bom.BomType = 1;
                                bom.EffectDate = bomItem.TDate;

                                bom.MaterialId = material.RecordId;
                                bom.MaterialCode = bomItem.ProCode;
                                bom.MaterialName = bomItem.ProDesc;

                                bom.ComponentId = component.RecordId;
                                bom.ComponentCode = bomItem.MatCode;
                                bom.ComponentName = bomItem.MatDesc;

                                bom.MaterialQty = 1;
                                bom.ComponentQty = (int)bomItem.AQty;

                                dbContext.Set<Bom>().Add(bom);
                            }
                        }
                        i = i + 1;
                        Thread.Sleep(100);
                    }
                    catch (Exception ex)
                    {
                        GlobalConstants.DefaultLogger.Error("跟ERP同步BOM错误:" + ex.Message);
                        GlobalConstants.DefaultLogger.Error(ex.StackTrace);
                    }
                }
                GlobalConstants.DefaultLogger.Info("已导入 " + i.ToString() + "个物料的BOM");
                dbContext.SaveChanges();
            }
        }

        private void PushQualityCheckData(Workshop workshop)
        {
            if (string.IsNullOrEmpty(this.QualityCheckSyncUrl))
            {
                return;
            }

            List<QualityCheck> reportLit = this.dbContext.Set<QualityCheck>().Where(x => x.WorkshopId == workshop.RecordId && x.OptFlag == 0).OrderBy(x => x.CreateTime).ToList();
            foreach (QualityCheck item in reportLit)
            {
                QualitySyncData data = new QualitySyncData()
                {
                    beId = this.AccountId,
                    prodpwt = new QualitySyncItem[]{
                        new QualitySyncItem(){
                            procode = item.ProductionCode,
                            unitcode = "pcs",
                            qty = item.Qty,
                            wcgcode = item.WocgCode,
                            loccode = item.WorkshopCode+"_BAD",
                            udfbldm = item.DefectCode,
                            udfblbm = item.WorkshopCode
                        }
                    }
                };

                GlobalConstants.DefaultLogger.Debug("开始不良报工数据:\n" + data.ToJson());
                this.ReportToErp(this.QualityCheckSyncUrl, data, item);

                Thread.Sleep(100); // 休息100毫秒    
            }
        }

        private void PushMovingData(Workshop workshop)
        {
            if (string.IsNullOrEmpty(this.MoveSyncUrl))
            {
                return;
            }

            List<ProductionMoving> reportLit = this.dbContext.Set<ProductionMoving>()
                  .Where(x => x.WorkshopId == workshop.RecordId && x.OptFlag == 0)
                  .OrderBy(x => x.CreateTime)
                  .ToList()
                  ;
            foreach (ProductionMoving item in reportLit)
            {
                MoveSyncData data = new MoveSyncData()
                {
                    beId = this.AccountId,
                    movet = new MoveSyncItem[]{
                        new MoveSyncItem(){
                            procode = item.ProductionCode,
                            unitcode = "pcs",
                            qty = item.Qty,
                            loccode = item.WorkshopCodeFrom,
                            aloccode = item.WorkshopCode
                        }
                    }
                };

                GlobalConstants.DefaultLogger.Debug("开始内部转移数据:\n" + data.ToJson());
                this.ReportToErp(this.MoveSyncUrl, data, item);

                Thread.Sleep(100); // 休息100毫秒       
            }
        }


        private void PushInstoreData(Workshop workshop)
        {
            if (string.IsNullOrEmpty(this.InstoreSyncUrl))
            {
                return;
            }

            List<ProductionOrderProgress> reportLit = this.dbContext.Set<ProductionOrderProgress>().Where(x => x.WorkshopId == workshop.RecordId && x.OptFlag == 0).OrderBy(x => x.CreateTime).ToList();
            foreach (ProductionOrderProgress progress in reportLit)
            {
                InstoreSyncData data = new InstoreSyncData()
                {
                    beId = this.AccountId,
                    prodpwt = new InstoreSyncItem[]{
                        new InstoreSyncItem(){
                            procode = progress.ProductionCode,
                            unitcode = "pcs",
                            qty = progress.Qty,
                            loccode = progress.WorkshopCode,
                            wcgcode = progress.WocgCode
                        }
                    }
                };

                GlobalConstants.DefaultLogger.Info("开始同步内部报工数据：\n" + data.ToJson());
                this.ReportToErp<long>(this.InstoreSyncUrl, data, progress);

                Thread.Sleep(100); // 休息100毫秒  
            }
        }


        private void PushInstoreWWData(Workshop workshop)
        {
            if (string.IsNullOrEmpty(this.InstoreSyncUrl))
            {
                return;
            }

            List<ProductionOrderProgress> reportLit = this.dbContext.Set<ProductionOrderProgress>().Where(x => x.WorkshopId == workshop.RecordId && x.OptFlag == 0).OrderBy(x => x.CreateTime).ToList();
            foreach (ProductionOrderProgress progress in reportLit)
            {
                InstoreSyncDataWW data = new InstoreSyncDataWW()
                {
                    beId = this.AccountId,
                    pdcorespwt = new InstoreSyncItemWW[]{
                        new InstoreSyncItemWW(){
                            procode = progress.ProductionCode,
                            unitcode = "pcs",
                            qty = progress.Qty,
                            loccode = progress.WorkshopCode
                        }
                    }
                };

                GlobalConstants.DefaultLogger.Debug("开始同步委外加工数据:\n" + data.ToJson());
                this.ReportToErp<long>(this.InstoreSyncUrl, data, progress);

                Thread.Sleep(100); // 休息100毫秒      
            }
        }

        private void ReportToErp<T>(string url, object data, TrackableEntity<T> item) where T : IComparable
        {
            try
            {
                string reportUrl = this.ServerHost + "/" + url;
                using (HttpClient client = this._factory.CreateClient())
                {
                    FillAuthorizationHeader(client);
                    string respContent = this.SendData(client, reportUrl, data);
                    GlobalConstants.DefaultLogger.Info("收到同步的结果：\n" + respContent);

                    WDBSyncResponse syncResponese = respContent.ToObject<WDBSyncResponse>();
                    if (syncResponese.Status)
                    {
                        GlobalConstants.DefaultLogger.Info("同步成功");

                        item.OptFlag = 255;
                        GlobalConstants.ModifyEntityStatus(item, this.dbContext);
                        this.dbContext.SaveChanges();
                    }
                    else
                    {
                        GlobalConstants.DefaultLogger.Error("同步失败!");
                        GlobalConstants.DefaultLogger.Debug(syncResponese.Message);
                    }
                }
            }
            catch (Exception ex)
            {
                GlobalConstants.DefaultLogger.Error("同步失败：" + ex.Message);
                GlobalConstants.DefaultLogger.Error(ex.StackTrace);
            }
        }

        private string SendData(HttpClient client, string url, object data)
        {
            HttpResponseMessage responseMessage = client.PostAsync(url, new JsonContent(data)).GetAwaiter().GetResult();
            responseMessage.EnsureSuccessStatusCode();
            return responseMessage.Content.ReadAsStringAsync().GetAwaiter().GetResult();
        }

        private void FillAuthorizationHeader(HttpClient client)
        {
            client.DefaultRequestHeaders.Add("authorization", "Bearer " + this._loginResult.access_token);
            client.DefaultRequestHeaders.Add("client_id", this._loginParameter.client_id);
            client.DefaultRequestHeaders.Add("cache-control", "no-cache");
        }
    }

    public class WDBSyncResponse
    {
        public long TranId { get; set; }
        public string TranCode { get; set; }
        public bool Status { get; set; }
        public string Message { get; set; }

    }

    public class BomSyncData
    {
        public int Size { get; set; }
        public string name { get; set; }
        public BomSyncItem[] Values { get; set; }
        public BomSyncField[] Fields { get; set; }
    }

    public class BomSyncItem
    {
        public string BomCode { get; set; }
        public string ProCode { get; set; }
        public string ProDesc { get; set; }
        public string MatCode { get; set; }
        public string MatDesc { get; set; }
        public float AQty { get; set; }
        public DateTime TDate { get; set; }
    }

    public class BomSyncField
    {
        public string Name { get; set; }
        public int ClassType { get; set; }
        public string FieldClassName { get; set; }
        public string FieldClass { get; set; }
    }


    public class JsonContent : StringContent
    {
        public JsonContent(object obj) :
           base(JsonConvert.SerializeObject(obj), Encoding.UTF8, "application/json")
        { }
    }

    public class InstoreSyncData
    {
        public int beId { get; set; }
        public InstoreSyncItem[] prodpwt { get; set; }
    }

    public class InstoreSyncItem
    {
        public string procode { get; set; }
        public string unitcode { get; set; }
        public int qty { get; set; }
        public string loccode { get; set; }
        public string wcgcode { get; set; }
    }

    public class InstoreSyncDataWW
    {
        public int beId { get; set; }
        public InstoreSyncItemWW[] pdcorespwt { get; set; }
    }

    public class InstoreSyncItemWW
    {
        public string procode { get; set; }
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

        public string procode { get; set; }
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
        public string wcgcode { get; set; }
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