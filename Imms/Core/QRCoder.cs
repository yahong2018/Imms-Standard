using System.Drawing;
using QRCoder;

namespace Imms.Core
{
    public class QRCoder
    {
        public static Bitmap GetQRCode(string content, int pixel)
        {
            QRCodeGenerator generator = new QRCodeGenerator();
            QRCodeData codeData = generator.CreateQrCode(content, QRCodeGenerator.ECCLevel.M, true);
            global::QRCoder.QRCode qrcode = new global::QRCoder.QRCode(codeData);

            Bitmap qrImage = qrcode.GetGraphic(pixel, Color.Black, Color.White, true);

            return qrImage;
        }
    }
}