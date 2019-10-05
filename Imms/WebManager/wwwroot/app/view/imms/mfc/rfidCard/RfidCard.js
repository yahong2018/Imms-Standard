Ext.define("app.view.imms.mfc.rfidCard.RfidCard", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "app_view_imms_mfc_rfidCard_RfidCard",
    requires: ["app.model.imms.mfc.RfidCardModel", "app.store.imms.mfc.RfidCardStore"],
    uses: ["app.view.imms.mfc.rfidCard.RfidCardDetailForm",
        "app.model.imms.material.MaterialModel", "app.store.imms.material.MaterialStore",
        "app.model.imms.org.WorkshopModel", "app.store.imms.org.WorkshopStore"
    ],
    columns: [
        { dataIndex: "rfidNo", text: '卡号', width: 100 },
        // { dataIndex: "cardStatus", text: '状态', width: 100 },
        { dataIndex: "workshopCode", text: '车间编号', width: 100, disableSearch: true },
        { dataIndex: "workshopName", text: '车间名称', width: 100, disableSearch: true },
        { dataIndex: "productionCode", text: '产品编号', width: 100, disableSearch: true },
        { dataIndex: "productionName", text: '产品名称', width: 100, disableSearch: true },
        { dataIndex: "qty", text: '数量', width: 100 },
    ],
    additionToolbarItems: [
        '-',
        {
            text: '打印条码', privilege: "PRINT", handler: function () {
                var grid = this.up("app_view_imms_mfc_rfidCard_RfidCard");
                var records = grid.getSelectionModel().getSelection();
                if (records.length == 0) {
                    Ext.Msg.alert("系统提示", "请先选定需要打印的Rfid卡！");
                    return;
                };
                var idList = [];
                for (var i = 0; i < records.length; i++) {
                    idList.push(records[i].get("recordId"));
                }
                var strIdList = idList.join(",");
                var encodedStr = Ext.util.Base64.encode(strIdList);
                window.open("imms/mfc/rfidCard/printBarCode?idList=" + encodedStr, "_blank");
            }
        },
    ],
    constructor: function (config) {
        var configBase = {
            store: Ext.create({ xtype: 'imms_mfc_RfidCardStore' }),
            detailFormClass: 'imms_mfc_rfidCard_RfidCardDetailForm',
            detailWindowTitle: 'RFID卡',
        };
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    }
});