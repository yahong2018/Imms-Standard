using System.Collections.Generic;
using System.Linq;
using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Imms.WebManager.Controllers
{
    [Route("imms/mfc/rfidCard")]
    public class RfidCardController : SimpleCRUDController<RfidCard>
    {
        public RfidCardController()
        {
            this.Logic = new Data.SimpleCRUDLogic<RfidCard>();
            this.AfterGetDataHandler = this.AfterGetData;
        }

        private void AfterGetData(List<RfidCard> list, DbContext dbContext)
        {
            List<Workshop> workshopList = dbContext.Set<Workshop>().ToList();
            List<Material> productionList = dbContext.Set<Material>().ToList();

            foreach (RfidCard rfid in list)
            {
                rfid.Workshop = workshopList.Single(x => x.RecordId == rfid.WorkshopId);
                rfid.Production = productionList.Single(x => x.RecordId == rfid.ProductionId);
            }
        }

        protected override void Verify(RfidCard item, int operation)
        {
            //
            // 检查productionId和workshopId 
            //
        }

        [Route("printBarCode")]
        public IActionResult PrintBarCode()
        {
            return View("Imms/MFC/RfidCard/PrintBarCode");
        }
    }
}