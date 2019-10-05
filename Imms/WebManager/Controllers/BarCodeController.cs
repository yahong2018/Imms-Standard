using System;
using System.Drawing.Imaging;
using System.IO;
using Microsoft.AspNetCore.Mvc;

namespace Imms.WebManager.Controllers
{   
    public class BarCodeController : Controller
    {
        [Route("qrcode/create")]
        public void GetQRCode(string base64Content, int pixel)
        {
            Response.ContentType = "image/jpeg";

            var bitmap = Imms.Core.QRCoder.GetQRCode(base64Content, pixel);
            MemoryStream ms = new MemoryStream();
            bitmap.Save(ms, ImageFormat.Jpeg);

            Response.Body.WriteAsync(ms.GetBuffer(), 0, Convert.ToInt32(ms.Length));
            Response.Body.Close();                        
        }
    }
}