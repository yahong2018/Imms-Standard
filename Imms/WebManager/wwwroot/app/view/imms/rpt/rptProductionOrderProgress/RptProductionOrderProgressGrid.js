Ext.define("app.view.imms.rpt.rptProductionOrderProgress.RptProductionOrderProgressGrid", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "app_view_imms_rpt_rptProductionOrderProgress_RptProductionOrderProgressGrid",
    requires: ["app.model.imms.rpt.ManufacturingSummaryModel", "app.store.imms.rpt.ManufacturingSummaryStore"],
    columns: [
        { text: "品号", dataIndex: "productionCode", width: 120, align: "center", menuDisabled: true },
        // { text: "品名", dataIndex: "productionName", width: 220, align: "center", menuDisabled: true },
        { text: "车间", dataIndex: "workshopCode", width: 120, align: "center", menuDisabled: true },
        { text: "日期", dataIndex: "productDate", width: 150, align: "center", menuDisabled: true },
        {
            text: "白班", menuDisabled: true, disableSearch: true,
            columns: [
                { text: "总数", dataIndex: "qtyTotal_0", width: 80, menuDisabled: true },
                { text: "良品数", dataIndex: "qtyGood_0", width: 80, menuDisabled: true },
                {
                    text: "良品率", dataIndex: "rateGood_0", width: 80, menuDisabled: true, renderer: function (v, item) {
                        if (v == 0) {
                            return "";
                        }
                        return Ext.util.Format.percent(v, "0.00");
                    }
                },
                { text: "不良数", dataIndex: "qtyDefect_0", width: 80, menuDisabled: true },
                {
                    text: "不良率", dataIndex: "rateDefect_0", width: 80, menuDisabled: true, renderer: function (v) {
                        if (v == 0) {
                            return "";
                        }
                        return Ext.util.Format.percent(v, "0.00");
                    }
                },
            ]
        }, {
            text: "晚班", menuDisabled: true, disableSearch: true,
            columns: [
                { text: "总数", dataIndex: "qtyTotal_1", width: 80, menuDisabled: true },
                { text: "良品数", dataIndex: "qtyGood_1", width: 80, menuDisabled: true },
                {
                    text: "良品率", dataIndex: "rateGood_1", width: 80, menuDisabled: true, renderer: function (v) {
                        if (v == 0) {
                            return "";
                        }
                        return Ext.util.Format.percent(v, "0.00");
                    }
                },
                { text: "不良数", dataIndex: "qtyDefect_1", width: 80, menuDisabled: true },
                {
                    text: "不良率", dataIndex: "rateDefect_1", width: 80, menuDisabled: true, renderer: function (v) {
                        if (v == 0) {
                            return "";
                        }
                        return Ext.util.Format.percent(v, "0.00");
                    }
                },
            ]
        },
        {
            text: "小计", menuDisabled: true, disableSearch: true,
            columns: [
                { text: "总数", dataIndex: "qtyTotal", width: 80, menuDisabled: true },
                { text: "良品数", dataIndex: "qtyGood", width: 80, menuDisabled: true },
                {
                    text: "良品率", dataIndex: "rateGood", width: 80, menuDisabled: true, renderer: function (v) {
                        if (v == 0) {
                            return "";
                        }
                        return Ext.util.Format.percent(v, "0.00");
                    }
                },
                { text: "不良数", dataIndex: "qtyDefect", width: 80, menuDisabled: true },
                {
                    text: "不良率", dataIndex: "rateDefect", width: 80, menuDisabled: true, renderer: function (v) {
                        if (v == 0) {
                            return "";
                        }
                        return Ext.util.Format.percent(v, "0.00");
                    }
                },
            ]
        }
    ],
    constructor: function (config) {
        var theStore;
        if (config.filter) {
            theStore = Ext.create({ xtype: 'imms_rpt_ManufacturingSummaryStore', autoLoad: false, pageSize: 0 });            
        } else {
            theStore = Ext.create({ xtype: 'imms_rpt_ManufacturingSummaryStore' });
        }
        var configBase = { store: theStore };
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    },
    listeners:{
        afterrender:function(){
            debugger;

            if(this.filter){
                this.store.clearCustomFilter();
                this.store.addCustomFilter(this.filter());
                this.store.buildFilterUrl();
                this.store.load();
            }
        }
    }
})