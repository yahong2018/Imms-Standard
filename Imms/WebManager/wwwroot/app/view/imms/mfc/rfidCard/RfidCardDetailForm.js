Ext.define("app.view.imms.mfc.rfidCard.RfidCardDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "imms_mfc_rfidCard_RfidCardDetailForm",
    padding: 10,
    defaults: {
        labelWidth: 70
    },
    items: [
        {
            name:"workshopCode",
            xtype:"hidden"
        },
        {
            name: "workshopName",
            xtype: "hidden"
        }, {
            name: "productionCode",
            xtype: "hidden"
        },
        {
            name: "productionName",
            xtype: "hidden"
        }, {
            name: "kanbanNo",
            xtype: "textfield",
            fieldLabel: "看板编号",
            allowBlank: false,
            width: 380,
        }, 
        {
            name: "rfidNo",
            xtype: "textfield",
            fieldLabel: "RFID卡号",
            allowBlank: false,
            width: 380,
        }, 
        {
            name: "cardStatus",
            xtype: "textfield",
            fieldLabel: "状态",
            allowBlank: false,
            width: 380,
        },
        {
            name: "workshopId",
            xtype: "combobox",
            fieldLabel: "工艺",
            allowBlank: false,
            width: 380,
            valueField: "recordId",
            displayField: "orgName",
            store: Ext.create("app.store.imms.org.WorkshopStore", { autoLoad: false }),
            listeners: {
                change: function (self, newValue, oldValue, eOpts) {
                    var record = self.getSelectedRecord();
                    var form = self.up("imms_mfc_rfidCard_RfidCardDetailForm");
                    var orgCode = form.down("[name='workshopCode']");
                    var orgName = form.down("[name='workshopName']");
                    orgCode.setValue(record.get("orgCode"));
                    orgName.setValue(record.get("orgName"));
                }
            }
        },
     
        {
            name: "productionId",
            xtype: "combobox",
            fieldLabel: "产品",
            allowBlank: false,
            width: 380,
            valueField: "recordId",
            displayField: "materialName",
            store: Ext.create("app.store.imms.material.MaterialStore", { autoLoad: false }),
            listeners: {
                change: function (self, newValue, oldValue, eOpts) {

                    var record = self.getSelectedRecord();
                    var form = self.up("imms_mfc_rfidCard_RfidCardDetailForm");
                    var productionCode = form.down("[name='productionCode']");
                    var productionName = form.down("[name='productionName']");
                    productionCode.setValue(record.get("materialCode"));
                    productionName.setValue(record.get("materialName"));
                }
            }
        },
        {
            name: "qty",
            xtype: "textfield",
            fieldLabel: "数量",
            allowBlank: false,
            width: 380,
        }
    ],
    onRecordLoad: function (config) {
        this.down("[name='productionId']").store.load();
        this.down("[name='workshopId']").store.load();
    }
});