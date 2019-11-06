Ext.define("app.view.imms.rpt.rptProductionOrderProgress.RptProductionOrderProgress", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "app_view_imms_rpt_rptProductionOrderProgress_RptProductionOrderProgress",
    requires: ["app.model.imms.rpt.ManufacturingSummaryModel", "app.store.imms.rpt.ManufacturingSummaryStore"],
    columns: [
        { text: "品号", dataIndex: "productionCode", width: 120, align: "center", menuDisabled: true },
        { text: "品名", dataIndex: "productionName", width: 220, align: "center", menuDisabled: true },
        { text: "车间", dataIndex: "workshopCode", width: 120, align: "center", menuDisabled: true },
        { text: "日期", dataIndex: "timeOfOriginWork", width: 150, align: "center", menuDisabled: true },
        {
            text: "投入", menuDisabled: true, disableSearch: true,
            columns: [
                { text: "总数", width: 80, menuDisabled: true },
                { text: "白班", width: 80, menuDisabled: true },
                { text: "晚班", width: 80, menuDisabled: true },
            ]
        }, {
            text: "产出", menuDisabled: true, disableSearch: true,
            columns: [
                { text: "总数", width: 80, menuDisabled: true },
                { text: "不良", width: 80, menuDisabled: true },
                { text: "白班", width: 80, menuDisabled: true },
                { text: "晚班", width: 80, menuDisabled: true },
            ]
        }
    ],
    constructor: function (config) {
        var configBase = {
            store: Ext.create({ xtype: 'imms_rpt_ManufacturingSummaryStore' })
        }
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    }
})