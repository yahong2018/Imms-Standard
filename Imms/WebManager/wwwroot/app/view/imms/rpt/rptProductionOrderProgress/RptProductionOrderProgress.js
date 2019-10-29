Ext.define("app.view.imms.rpt.rptProductionOrderProgress.RptProductionOrderProgress", {
    extend: "Ext.container.Container",
    xtype: "app_view_imms_rpt_rptProductionOrderProgress_RptProductionOrderProgress",
    requires:["app.ux.dbgrid.DbGrid"],
    layout: "fit",
    items: [
        {
            xtype: "dbgrid",
            columns: [
                { text: "品号", width: 120, align: "center", menuDisabled: true },                
                { text: "品名", width: 220, align: "center", menuDisabled: true },                  
                { text: "车间", width: 120, align: "center", menuDisabled: true },
                { text: "日期", width: 150, align: "center", menuDisabled: true },
                {
                    text: "投入", menuDisabled: true, disableSearch:true,
                    columns: [
                        { text: "总数", width: 80, menuDisabled: true },                        
                        { text: "白班", width: 80,  menuDisabled: true },
                        { text: "晚班", width:80,  menuDisabled: true },                        
                    ]
                }, {
                    text: "产出", menuDisabled: true, disableSearch: true,
                    columns: [
                        { text: "总数", width: 80, menuDisabled: true },
                        { text: "不良", width: 80, menuDisabled: true },
                        { text: "白班", width: 80,  menuDisabled: true },
                        { text: "晚班", width: 80,   menuDisabled: true },
                    ]
                }
            ]
        }
    ]
})