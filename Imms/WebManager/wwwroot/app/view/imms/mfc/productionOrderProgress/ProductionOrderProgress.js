Ext.define("app.view.imms.mfc.productionOrderProgress.ProductionOrderProgress",{
    extend:"app.ux.dbgrid.DbGrid",
    xtype:"app_view_imms_mfc_productionOrderProgress_ProductionOrderProgress",
    requires:["app.model.imms.mfc.ProductionOrderProgressModel","app.store.imms.mfc.ProductionOrderProgressStore"],
    uses:["app.view.imms.mfc.productionOrderProgress.ProductionOrderProgressDetailForm"],
    columns:[
        { dataIndex: "productionOrderNo", text:"计划订单" },

        { dataIndex: "workshopCode", text:"车间编码"},
        { dataIndex: "workshopName", text: "车间名称" },
        
        { dataIndex: "workstationCode", text: "工位编码" },
        { dataIndex: "workstationName", text: "工位名称" },

        { dataIndex: "productionCode", text: "产品编码" },
        { dataIndex: "productionName", text: "产品名称" },
        
        { dataIndex: "employeeId", text: "工号" },
        { dataIndex: "emploeyeeName", text: "姓名" },

        { dataIndex: "rfidTerminatorId", text: "工位机" },
        { dataIndex: "rfidControllerId", text: "控制器" },

        { dataIndex: "reportTime", text: '时间'},
        { dataIndex: "reportQty", text: "数量" },
        { dataIndex: "rfidCardNo", text: "卡号" },
        { dataIndex: "reportType", text: "汇报类型" },
    ],

    constructor:function(config){
        var configBase = {
            store: Ext.create({ xtype: 'imms_mfc_ProductionOrderProgressStore' }),
            detailFormClass: 'imms_mfc_productionOrderProgress_ProductionOrderProgressDetailForm',
            detailWindowTitle: '生产进度',
        };
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    }
});