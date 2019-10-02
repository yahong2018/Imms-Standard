using Imms.Data;
using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
namespace Imms.WebManager
{
    public class KanbanRealtimeHub : Hub
    {
        public static List<string> realTimeConnectedIdList = new List<string>();

        public KanbanRealtimeHub()
        {
        }

        public override Task OnDisconnectedAsync(Exception exception)
        {
            string id = Context.ConnectionId;
            lock (this)
            {
                if (KanbanRealtimeHub.realTimeConnectedIdList.Contains(id))
                {
                    KanbanRealtimeHub.realTimeConnectedIdList.Remove(id);
                }
            }
            return base.OnDisconnectedAsync(exception);
        }

        public void RegisterRealtimeClient()
        {
            string id = Context.ConnectionId;
            lock (this)
            {
                if (!KanbanRealtimeHub.realTimeConnectedIdList.Contains(id))
                {
                    KanbanRealtimeHub.realTimeConnectedIdList.Add(id);
                }
            }
        }
    }


    public class RealtimeDataPushTask
    {
        private readonly IHubContext<KanbanRealtimeHub> _hubContext;
        private System.Threading.Thread dataPushThread;
        private readonly Random random = new Random(100);

        public bool Terminated { get; set; }

        public RealtimeDataPushTask(IHubContext<KanbanRealtimeHub> hubContext)
        {
            this._hubContext = hubContext;

            this.Terminated = false;
        }

        public void Start()
        {
            lock (this)
            {
                if (dataPushThread == null)
                {
                    dataPushThread = new System.Threading.Thread(() =>
                               {
                                   while (!Terminated)
                                   {
                                       this.PushThreadHandler();
                                       Thread.Sleep(1000); // 1秒钟发布1次数据
                                   }
                               });
                    dataPushThread.Start();
                }
            }
        }

        private void PushThreadHandler()
        {
            this.PushRealtimeData();
        }

        public void PushRealtimeData()
        {
            lock (this)
            {
                if (KanbanRealtimeHub.realTimeConnectedIdList.Count == 0)
                {
                    return;
                }
            }

            RealtimeItem realtimeItem = new RealtimeItem();
            realtimeItem.line_code = "A301-2";

            realtimeItem.line_summary_data = new SummaryItem();
            realtimeItem.line_summary_data.production_code = "AL666-ACC-01M";
            realtimeItem.line_summary_data.production_name = "测试品名";
            realtimeItem.line_summary_data.production_order_no = "WO-20191002-001";
            realtimeItem.line_summary_data.uph = 30;
            realtimeItem.line_summary_data.person_qty = 6;

            realtimeItem.line_detail_data = new DetailItem[12];
            List<ProductionOrderProgress> dbList = this.GetOrderProgress();

            for (int i = 0; i < 12; i++)
            {
                DateTime date = DateTime.Now;

                DetailItem item = new DetailItem();
                realtimeItem.line_detail_data[i] = item;
                item.index = i;
                item.hour = date.Hour;
                item.qty_plan = 100;
                item.qty_good = random.Next(100);
                item.qty_bad = random.Next(item.qty_plan - item.qty_good);
            }
            lock (this)
            {
                foreach (string id in KanbanRealtimeHub.realTimeConnectedIdList)
                {
                    _hubContext.Clients.Client(id).SendAsync("PushRealtimeData", realtimeItem);
                }
            }
        }

        public List<ProductionOrderProgress> GetOrderProgress()
        {
            List<ProductionOrderProgress> result = null;
            CommonRepository.UseDbContext(dbContext =>
            {
                DateTime now = DateTime.Now;
                DateTime begin = new DateTime(now.Year, now.Month, now.Day);
                DateTime end = begin.AddDays(1);

                result = dbContext.Set<ProductionOrderProgress>().Where(x => x.CreateDate >= begin && x.CreateDate < end).ToList();
            });

            return result;
        }
    }

    public class RealtimeItem
    {
        public string line_code { get; set; }
        public SummaryItem line_summary_data { get; set; }
        public DetailItem[] line_detail_data { get; set; }
    }

    public class SummaryItem
    {
        public string production_code { get; set; }
        public string production_name { get; set; }
        public string production_order_no { get; set; }
        public int uph { get; set; }
        public int person_qty { get; set; }
    }

    public class DetailItem
    {
        public int hour { get; set; }
        public int index { get; set; }
        public int qty_plan { get; set; }
        public int qty_good { get; set; }
        public int qty_bad { get; set; }
    }
}