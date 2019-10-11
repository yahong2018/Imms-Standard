Ext.define("app.view.imms.mfc.productionMoving.ProductionMovingDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "imms_mfc_productionMoving_ProductionMovingDetailForm",
    padding: 5,
    width: 600,
    layout: "anchor",
    defaults: {
        layout: "anchor",
        anchor: "100%",
    },
    items: [
        { name: "productionOrderId", xtype: "hidden" },
        { name: "productionId", xtype: "hidden" },
        { name: "rfidCardId", xtype: "hidden" },
        { name: "operatorId", xtype: "hidden" },
        { name: "workstationId", xtype: "hidden" },
        { name: "workshopId", xtype: "hidden" },
        { name: "prevProgressRecordId", xtype: "hidden" },

        { name: "productionOrderNo", xtype: "textfield", fieldLabel: "计划单号", margin: '0 20 5 0',allowBlank:false },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "productionCode", xtype: "textfield", fieldLabel: "交接产品", allowBlank: false},
                { name: "productionName", xtype: "textfield", margin: '0 20 0 5',flex:0.8,readOnly:true },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "rfidTerminatorId", xtype: "textfield", fieldLabel: "工位机号" },
                { name: "rfidControllerGroupId", xtype: "textfield", fieldLabel: "控制器号", margin: '0 0 0 20' },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "rfidNo", xtype: "textfield", fieldLabel: "RFID号",},
                { name: "qty", xtype: "textfield", fieldLabel: "接收数量", margin: '0 0 0 20', allowBlank: false},                
            ]
        },
        { name: "movingTime", xtype: "textfield", fieldLabel: "接收时间", margin: '0 20 5 0', allowBlank: false },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "employeeId", xtype: "textfield", fieldLabel: "接收人", allowBlank: false },
                { name: "employeeName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8,readOnly:true},
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "workshopCode", xtype: "textfield", fieldLabel: "接收车间", allowBlank: false },
                { name: "workshopName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true},
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "workstationCode", xtype: "textfield", fieldLabel: "接收工位", allowBlank: false },
                { name: "workstationName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        }
    ]
});