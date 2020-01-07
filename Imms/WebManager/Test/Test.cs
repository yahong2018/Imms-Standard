using System;
using System.Text;
using Imms.Mes.Services;

namespace Imms.WebManager.Test
{
    public class TestClass
    {

        public static void ParseTest()
        {
            // try
            // {
            //     string respone_1 = "{\"tranId\":0,\"tranCode\":\"\",\"message\":\"[{\\\"exception\\\":\\\"\\\",\\\"htmlMessage\\\":false,\\\"id\\\":10300,\\\"info\\\":\\\"table is empty(prodpwt)\\\",\\\"info_desc\\\":\\\"\\\\\\\"生产入库单 (生产详细)\\\\\\\"表格的数据为空，不能保存。\\\",\\\"jsonStr\\\":\\\"\\\",\\\"key\\\":\\\"ce01_core_10300\\\",\\\"locators\\\":[{\\\"colMess\\\":\\\"\\\",\\\"colName\\\":\\\"\\\",\\\"id\\\":0,\\\"locatorKey\\\":\\\"prodpwt\\\",\\\"row\\\":0,\\\"tableMess\\\":\\\"\\\",\\\"tableName\\\":\\\"prodpwt\\\",\\\"type\\\":\\\"Table\\\"}],\\\"pass\\\":false,\\\"trace\\\":\\\"[MacCheckerUtil.checkEmptyTable_197]-[TradeModuleChecker.checkTradingEmptyTable_1060]-[CheckerLib.runChecker_224]-[CawEntityCurdAction.updateEntity_107]-[CawEntityInterceptor.logCall_44]\\\",\\\"type\\\":\\\"Error\\\"}]\",\"status\":false}";
            //     WDBSyncResponse s2 = GlobalConstants.ToObject<WDBSyncResponse>(respone_1);
            // }
            // catch (Exception e)
            // {
            //     Console.WriteLine(e.Message);
            // }
            try
            {
               // string str_1 = "{\"tranId\":332,\"tranCode\":\"TPW20010018\",\"message\":\"\",\"status\":true}";
               string str_1 = "\"{\\\"tranId\\\":333,\\\"tranCode\\\":\\\"TPW20010019\\\",\\\"message\\\":\\\"\\\",\\\"status\\\":true}\"";
              //  string str_1 = "\"{\\\"tranId\\\":0,\\\"tranCode\\\":\\\"\\\",\\\"message\\\":\\\"[{\\\\\\\"exception\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"htmlMessage\\\\\\\":false,\\\\\\\"id\\\\\\\":142005,\\\\\\\"info\\\\\\\":\\\\\\\"exceed serial no(exceed max serial no)\\\\\\\",\\\\\\\"info_desc\\\\\\\":\\\\\\\"编号生成失败，流水号超过最大值。\\\\\\\",\\\\\\\"jsonStr\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"key\\\\\\\":\\\\\\\"core_142005\\\\\\\",\\\\\\\"locators\\\\\\\":[],\\\\\\\"pass\\\\\\\":false,\\\\\\\"trace\\\\\\\":\\\\\\\"[GenCodeLib.genCode_723]-[ModuleChecker.checkCodeFormatSetup_1732]-[ModuleChecker.autoGenCode_436]-[CheckerLib.runChecker_224]-[CawEntityCurdAction.updateEntity_107]\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"Error\\\\\\\"},{\\\\\\\"exception\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"htmlMessage\\\\\\\":false,\\\\\\\"id\\\\\\\":101905,\\\\\\\"info\\\\\\\":\\\\\\\"required. field(module.required)\\\\\\\",\\\\\\\"info_desc\\\\\\\":\\\\\\\"必填项为空\\\\\\\",\\\\\\\"jsonStr\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"key\\\\\\\":\\\\\\\"core_101905\\\\\\\",\\\\\\\"locators\\\\\\\":[{\\\\\\\"colMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"colName\\\\\\\":\\\\\\\"mproId\\\\\\\",\\\\\\\"id\\\\\\\":0,\\\\\\\"locatorKey\\\\\\\":\\\\\\\"prodpwt.mproId.1\\\\\\\",\\\\\\\"row\\\\\\\":1,\\\\\\\"tableMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"tableName\\\\\\\":\\\\\\\"prodpwt\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"Field\\\\\\\"},{\\\\\\\"colMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"colName\\\\\\\":\\\\\\\"psfId\\\\\\\",\\\\\\\"id\\\\\\\":0,\\\\\\\"locatorKey\\\\\\\":\\\\\\\"prodpwt.psfId.1\\\\\\\",\\\\\\\"row\\\\\\\":1,\\\\\\\"tableMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"tableName\\\\\\\":\\\\\\\"prodpwt\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"Field\\\\\\\"},{\\\\\\\"colMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"colName\\\\\\\":\\\\\\\"wcgId\\\\\\\",\\\\\\\"id\\\\\\\":0,\\\\\\\"locatorKey\\\\\\\":\\\\\\\"prodpwt.wcgId.1\\\\\\\",\\\\\\\"row\\\\\\\":1,\\\\\\\"tableMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"tableName\\\\\\\":\\\\\\\"prodpwt\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"Field\\\\\\\"}],\\\\\\\"pass\\\\\\\":false,\\\\\\\"trace\\\\\\\":\\\\\\\"[ModuleChecker.checkFieldDataDictSetting_1004]-[CheckerLib.runChecker_224]-[CawEntityCurdAction.updateEntity_107]-[CawEntityInterceptor.logCall_44]-[view241.updateEntity_-1]\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"Error\\\\\\\"}]\\\",\\\"status\\\":false}\"";
               // string str = "{\"tranId\":0,\"tranCode\":\"\",\"message\":\"[{\\\\\\\"exception\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"htmlMessage\\\\\\\":false,\\\\\\\"id\\\\\\\":142005,\\\\\\\"info\\\\\\\":\\\\\\\"exceed serial no(exceed max serial no)\\\\\\\",\\\\\\\"info_desc\\\\\\\":\\\\\\\"编号生成失败，流水号超过最大值。\\\\\\\",\\\\\\\"jsonStr\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"key\\\\\\\":\\\\\\\"core_142005\\\\\\\",\\\\\\\"locators\\\\\\\":[],\\\\\\\"pass\\\\\\\":false,\\\\\\\"trace\\\\\\\":\\\\\\\"[GenCodeLib.genCode_723]-[ModuleChecker.checkCodeFormatSetup_1732]-[ModuleChecker.autoGenCode_436]-[CheckerLib.runChecker_224]-[CawEntityCurdAction.updateEntity_107]\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"Error\\\\\\\"},{\\\\\\\"exception\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"htmlMessage\\\\\\\":false,\\\\\\\"id\\\\\\\":101905,\\\\\\\"info\\\\\\\":\\\\\\\"required. field(module.required)\\\\\\\",\\\\\\\"info_desc\\\\\\\":\\\\\\\"必填项为空\\\\\\\",\\\\\\\"jsonStr\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"key\\\\\\\":\\\\\\\"core_101905\\\\\\\",\\\\\\\"locators\\\\\\\":[{\\\\\\\"colMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"colName\\\\\\\":\\\\\\\"mproId\\\\\\\",\\\\\\\"id\\\\\\\":0,\\\\\\\"locatorKey\\\\\\\":\\\\\\\"prodpwt.mproId.1\\\\\\\",\\\\\\\"row\\\\\\\":1,\\\\\\\"tableMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"tableName\\\\\\\":\\\\\\\"prodpwt\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"Field\\\\\\\"},{\\\\\\\"colMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"colName\\\\\\\":\\\\\\\"psfId\\\\\\\",\\\\\\\"id\\\\\\\":0,\\\\\\\"locatorKey\\\\\\\":\\\\\\\"prodpwt.psfId.1\\\\\\\",\\\\\\\"row\\\\\\\":1,\\\\\\\"tableMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"tableName\\\\\\\":\\\\\\\"prodpwt\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"Field\\\\\\\"},{\\\\\\\"colMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"colName\\\\\\\":\\\\\\\"wcgId\\\\\\\",\\\\\\\"id\\\\\\\":0,\\\\\\\"locatorKey\\\\\\\":\\\\\\\"prodpwt.wcgId.1\\\\\\\",\\\\\\\"row\\\\\\\":1,\\\\\\\"tableMess\\\\\\\":\\\\\\\"\\\\\\\",\\\\\\\"tableName\\\\\\\":\\\\\\\"prodpwt\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"Field\\\\\\\"}],\\\\\\\"pass\\\\\\\":false,\\\\\\\"trace\\\\\\\":\\\\\\\"[ModuleChecker.checkFieldDataDictSetting_1004]-[CheckerLib.runChecker_224]-[CawEntityCurdAction.updateEntity_107]-[CawEntityInterceptor.logCall_44]-[view241.updateEntity_-1]\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"Error\\\\\\\"}]\",\"status\":false}";
                StringBuilder respone_2 = new StringBuilder(str_1);
                if (str_1.StartsWith("\""))
                {
                    respone_2.Remove(0, 1);
                }
                if (str_1.EndsWith("\""))
                {
                    respone_2.Remove(respone_2.Length - 1, 1);
                }
                respone_2.Replace("\\\"tranId\\\"","\"tranId\"");
                respone_2.Replace("\\\"tranCode\\\":\\\"\\\"","\"tranCode\":\"\"");
                respone_2.Replace("\\\"message\\\":\\\"[","\"message\":\"[");
                respone_2.Replace("]\\\",\\\"status\\\"","]\",\"status\"");

                respone_2.Replace("\\\"tranCode\\\":\\\"","\"tranCode\":\"");
                respone_2.Replace("\\\",\\\"message\\\":\\\"","\",\"message\":\"");
                respone_2.Replace("\\\",\\\"status\\\"","\",\"status\"");
                WDBSyncResponse s1 = GlobalConstants.ToObject<WDBSyncResponse>(respone_2.ToString());
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }
    }
}