Ext.define("app.view.imms.mfc.rfidCard.RfidCard", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "app_view_imms_mfc_rfidCard_RfidCard",
    requires: ["app.model.imms.mfc.RfidCardModel", "app.store.imms.mfc.RfidCardStore",
        "app.model.imms.material.MaterialModel", "app.store.imms.material.MaterialStore",
        "app.model.imms.org.WorkshopModel", "app.store.imms.org.WorkshopStore",],
    uses: ["app.view.imms.mfc.rfidCard.RfidCardDetailForm", "app.view.imms.mfc.rfidCard.ExcelImportWindow"
    ],
    columns: [
        { dataIndex: "kanbanNo", text: '看板编号', width: 100 },
        { dataIndex: "rfidNo", text: '卡号', width: 100 },
        { dataIndex: "cardType", text: '类型', width: 100 },
        { dataIndex: "cardStatus", text: '状态', width: 100 },
        { dataIndex: "workshopCode", text: '车间编号', width: 100 },
        { dataIndex: "workshopName", text: '车间名称', width: 100 },
        { dataIndex: "productionCode", text: '产品编号', width: 150 },
        { dataIndex: "productionName", text: '产品名称', width: 150 },
        { dataIndex: "issueQty", text: '派发数量', width: 100 },
        { dataIndex: "stockQty", text: '库存数量', width: 100 },
    ],
    additionToolbarItems: [
        '-',
        // {
        //     text: '打印条码', privilege: "PRINT", handler: function () {
        //         var grid = this.up("app_view_imms_mfc_rfidCard_RfidCard");
        //         var records = grid.getSelectionModel().getSelection();
        //         if (records.length == 0) {
        //             Ext.Msg.alert("系统提示", "请先选定需要打印的Rfid卡！");
        //             return;
        //         };
        //         var idList = [];
        //         for (var i = 0; i < records.length; i++) {
        //             idList.push(records[i].get("recordId"));
        //         }
        //         var strIdList = idList.join(",");
        //         var encodedStr = Ext.util.Base64.encode(strIdList);
        //         window.open("api/imms/mfc/rfidCard/printBarCode?idList=" + encodedStr, "_blank");
        //     }
        // },
        {
            text: "看板导入", privilege: "ExcelImport", handler: function () {
                var win = Ext.create({ xtype: "imms_mfc_rfidCard_ExcelImportWindow" });
                win.store = this.up("app_view_imms_mfc_rfidCard_RfidCard").store;
                win.show();
            }
        }
    ],
    constructor: function (config) {
        var configBase = {
            store: Ext.create({ xtype: 'imms_mfc_RfidCardStore' }),
            detailFormClass: 'imms_mfc_rfidCard_RfidCardDetailForm',
            detailWindowTitle: '看板RFID卡',
        };
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    }
});