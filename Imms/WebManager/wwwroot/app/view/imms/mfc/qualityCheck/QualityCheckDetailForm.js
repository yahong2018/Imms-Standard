Ext.define("app.view.imms.mfc.qualityCheck.QualityCheckDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "imms_mfc_qualityCheck_QualityCheckDetailForm",
    width: 750,
    padding:5,
    layout: "anchor",
    defaults: {
        layout: "anchor",
        anchor: "100%",
    },
    items: [
        { name: "productionOrderId", xtype: "hidden" },
        { name: "productionId", xtype: "hidden" },
        { name: "discoverId", xtype: "hidden" },
        { name: "producerId", xtype: "hidden" },
        { name: "responseId", xtype: "hidden" },

        { name: "productionOrderNo", xtype: "textfield", fieldLabel: "计划单号", margin: '0 20 5 0', allowBlank: false },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "productionCode", xtype: "textfield", fieldLabel: "产品", allowBlank: false },
                { name: "productionName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8 },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "discoverCode", xtype: "textfield", fieldLabel: "发现人", allowBlank: false },
                { name: "discoverName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        },
        { name: "discoverName", xtype: "textfield", fieldLabel: "发现时间", margin: '0 20 5 0', allowBlank: false },

        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "producerCode", xtype: "textfield", fieldLabel: "产生人", allowBlank: false },
                { name: "producerName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        },
        { name: "producerName", xtype: "textfield", fieldLabel: "产生时间", margin: '0 20 5 0', allowBlank: false },

        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "responseCode", xtype: "textfield", fieldLabel: "责任人", allowBlank: false },
                { name: "responseName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        },

        { name: "defectyTypeCode", xtype: "textfield", fieldLabel: "缺陷代码", margin: '0 20 5 0', allowBlank: false },
        { name: "qty", xtype: "textfield", fieldLabel: "缺陷数量", margin: '0 20 5 0', allowBlank: false },
        { name: "defectDescription", xtype: "textarea", fieldLabel: "缺陷描述", margin: '0 20 5 0', allowBlank: false },
    ]
});