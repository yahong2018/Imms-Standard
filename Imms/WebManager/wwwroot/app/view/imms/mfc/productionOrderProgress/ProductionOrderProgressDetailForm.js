Ext.define("app.view.imms.mfc.productionOrderProgress.ProductionOrderProgressDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "imms_mfc_productionOrderProgress_ProductionOrderProgressDetailForm",
    padding: 5,
    width: 850,
    layout: "anchor",
    defaults: {
        layout: "anchor",
        anchor: "100%",
    },
    items: [
        { name: "productionOrderId", xtype: "hidden" },
        { name: "workshopId", xtype: "hidden" },
        { name: "workstationId", xtype: "hidden" },
        { name: "productionId", xtype: "hidden" },
        { name: "operatorId", xtype: "hidden" },

        { name: "productionOrderNo", fieldLabel: "计划单号", xtype: "textfield", width: 250 },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "workshopCode", fieldLabel: "车间编码", xtype: "textfield", width: 250 },
                { name: "workshopName", fieldLabel: "车间名称", margin: '0 0 0 20', xtype: "textfield", flex: 0.8, readOnly: true },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "workstationCode", fieldLabel: "工位编码", xtype: "textfield", width: 250 },
                { name: "workstationName", fieldLabel: "工位名称", margin: '0 0 0 20', xtype: "textfield", flex: 0.8, readOnly: true },
            ]
        },

        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "productionCode", fieldLabel: "产品编码", xtype: "textfield", width: 250 },
                { name: "productionName", fieldLabel: "产品名称", margin: '0 0 0 20', xtype: "textfield", flex: 0.8, readOnly: true },
            ]
        },

        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "employeeId", fieldLabel: "操作员工号", xtype: "textfield", width: 250 },
                { name: "emploeyeeName", fieldLabel: "操作员姓名", margin: '0 0 0 20', xtype: "textfield", flex: 0.8, readOnly: true },
            ]
        },

        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "rfidTerminatorId", fieldLabel: "工位机", xtype: "textfield", width: 250 },
                { name: "rfidControllerId", fieldLabel: "控制器", margin: '0 0 0 20', xtype: "textfield", flex: 0.5 },
            ]
        },

        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "reportTime", fieldLabel: "报工时间", xtype: 'textfield', width: 250 },
                { name: "reportQty", fieldLabel: "报工数量", margin: '0 0 0 20', xtype: "textfield", width: 250 },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "goodQty", fieldLabel: "良品数", xtype: "textfield", width: 250 },
                { name: "badQty", fieldLabel: "不良数", margin: '0 0 0 20', xtype: "textfield", width: 250 },
            ]
        },

        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "rfidCardNo", fieldLabel: "RFID卡号", xtype: "textfield", width: 250 },
                { name: "reportType", fieldLabel: "汇报类型", margin: '0 0 0 20', xtype: "textfield", width: 250 },
            ]
        },

        { name: "remark", xtype: "textarea", fieldLabel: "备注", flex: 1 },
    ]
});