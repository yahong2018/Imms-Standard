Ext.define("app.model.imms.mfc.ProductionOrderModel",{
    extend:"app.model.TrackableModel",
    fields:[
        { name: "rfidNo", dbFieldName: 'rfid_no', type: "string" },
    ]
});