using System.Drawing;
using System.IO;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
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

    public class ExcelHelper
    {
        public void ImportExcel(string fileName, string worksheetName,int[] columns, int firstRowNum,int lastRowNum)
        {
            IWorkbook workbook;
            string fileExt = Path.GetExtension(fileName).ToLower();
            using (FileStream fs = new FileStream(fileName, FileMode.Open, FileAccess.Read))
            {
                //XSSFWorkbook 适用XLSX格式，HSSFWorkbook 适用XLS格式
                if (fileExt == ".xlsx") { workbook = new XSSFWorkbook(fs); } else if (fileExt == ".xls") { workbook = new HSSFWorkbook(fs); } else { workbook = null; }
                if (workbook == null)
                {
                    return;
                }
                ISheet sheet = workbook.GetSheet(worksheetName);
                if (sheet == null)
                {
                    return;
                }
                if(firstRowNum==-1){
                    firstRowNum = sheet.FirstRowNum;
                }
                if(lastRowNum ==-1){
                    lastRowNum = sheet.LastRowNum;
                }
                
                IRow header = sheet.GetRow(firstRowNum);
            }

        }
    }
}