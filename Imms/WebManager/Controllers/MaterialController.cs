using Imms.Mes.Data.Domain;
using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager.Controllers
{
    [Route("api/imms/material/material")]
    public class MaterialController : SimpleCRUDController<Material>
    {
        public MaterialController() => this.Logic = new Data.SimpleCRUDLogic<Material>();

    }
}