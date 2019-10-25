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
        public void ImportExcel(string fileName, string worksheetName, int firstRowNum, int lastRowNum, ExcelRowProcessHandler rowHandler)
        {
            if (rowHandler == null)
            {
                return;
            }

            using (FileStream fs = new FileStream(fileName, FileMode.Open, FileAccess.Read))
            {
                string fileType = Path.GetExtension(fileName).ToLower();
                this.ImportExcel(fs, fileType, worksheetName, firstRowNum, lastRowNum, rowHandler);
                fs.Close();
            }
        }

        public void ImportExcel(FileStream fs, string fileType, string worksheetName, int firstRowNum, int lastRowNum, ExcelRowProcessHandler rowHandler)
        {
            IWorkbook workbook;
            if (fileType == ".xlsx") { workbook = new XSSFWorkbook(fs); } else if (fileType == ".xls") { workbook = new HSSFWorkbook(fs); } else { workbook = null; }
            if (workbook == null)
            {
                return;
            }

            this.ImportExcel(workbook, worksheetName, firstRowNum, lastRowNum, rowHandler);
        }

        public void ImportExcel(IWorkbook workbook, string worksheetName, int firstRowNum, int lastRowNum, ExcelRowProcessHandler rowHandler)
        {
            ISheet sheet = workbook.GetSheet(worksheetName);
            if (sheet == null)
            {
                return;
            }
            this.ImportExcel(sheet,firstRowNum,lastRowNum,rowHandler);
        }

        public void ImportExcel(ISheet sheet, int firstRowNum, int lastRowNum, ExcelRowProcessHandler rowHandler)
        {
            if (firstRowNum == -1)
            {
                firstRowNum = sheet.FirstRowNum;
            }
            if (lastRowNum == -1)
            {
                lastRowNum = sheet.LastRowNum;
            }

            for (int i = firstRowNum; i < lastRowNum; i++)
            {
                IRow row = sheet.GetRow(i);
                rowHandler(row);
            }
        }
    }

    public delegate void ExcelRowProcessHandler(IRow row);
}