Ext.define("app.view.imms.rpt.rptWip.RptWip", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "app_view_imms_rpt_rptWip_RptWip",
    requires: ["app.model.imms.material.MaterialStockModel", "app.store.imms.material.MaterialStockStore"],
    columns: [
        { text: "品号", dataIndex:"materialCode", width: 100, menuDisabled: true },
        { text: "部门代码", dataIndex: "storeCode", width: 100, align: "center", menuDisabled: true  },
        { text: "部门名称", dataIndex: "storeName", width: 200, align:"center", menuDisabled: true },

        { text: "在库", dataIndex: "qtyStock", align: "center",  width: 100, menuDisabled: true, disableSearch: true,  },
        {
            text: "入",
            disableSearch: true,
            columns: [
                { text: "转入", dataIndex: "qtyMoveIn",  width: 80, menuDisabled: true },
                { text: "退回", dataIndex: "qtyBackIn", width: 80, menuDisabled: true },
            ]
        },
        {
            text: "出", disableSearch: true,
            columns: [
                { text: "转出", dataIndex: "qtyMoveOut",  width: 80, menuDisabled: true  },
                { text: "退回", dataIndex: "qtyBackOut", width: 80, menuDisabled: true },
            ]
        },
        {
            text: "消耗", disableSearch: true,
            columns: [
                { text: "良品", dataIndex: "qtyConsumeGood", width: 80, menuDisabled: true  },
                { text: "不良", dataIndex: "qtyConsumeDefect", width: 80, menuDisabled: true },
            ]
        },
        {
            text: "产出", disableSearch: true,
            columns: [
                { text: "良品", dataIndex: "qtyGood", width: 80, menuDisabled: true  },
                { text: "不良", dataIndex: "qtyDefect",  width: 80, menuDisabled: true },
            ]
        }
    ],
    constructor: function (config) {
        var configBase = { store: Ext.create({ xtype: 'app_store_imms_material_MaterialStockStore' }) };
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    },
});