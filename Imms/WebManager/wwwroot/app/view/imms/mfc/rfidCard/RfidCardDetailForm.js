Ext.define("app.view.imms.mfc.rfidCard.RfidCardDetailForm", {
    extend: "Ext.form.Panel",
    xtype: "imms_mfc_rfidCard_RfidCardDetailForm",
    padding: 10,
    defaults: {
        labelWidth: 70
    },
    items: [
        {
            name: "recordId",
            xtype: "hidden"
        },
        {
            name: "workshopId",
            xtype: "combobox",
            fieldLabel: "车间",
            allowBlank: false,
            width: 380,
            valueField: "recordId",
            displayField: "organizationName",
            store: Ext.create("app.store.imms.org.WorkshopStore", { autoLoad: false })
        },
        {
            name: "productionId",
            xtype: "combobox",
            fieldLabel: "产品",
            allowBlank: false,
            width: 380,
            valueField: "recordId",
            displayField: "materialName",
            store: Ext.create("app.store.imms.material.MaterialStore", { autoLoad: false })
        },
        {
            name: "qty",
            xtype: "textfield",
            fieldLabel: "数量",
            allowBlank: false,
            width: 380,
        },
        {
            name: "rfidNo",
            xtype: "textfield",
            fieldLabel: "卡号",
            allowBlank: false,
            width: 380,
        }
    ],
    onRecordLoad: function (config) {
        this.down("[name='productionId']").store.load();
        this.down("[name='workshopId']").store.load();
    }
});