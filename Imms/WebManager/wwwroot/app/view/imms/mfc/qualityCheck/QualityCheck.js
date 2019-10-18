Ext.define("app.view.imms.mfc.qualityCheck.QualityCheck", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "app_view_imms_mfc_qualityCheck_QualityCheck",
    requires: [
        "app.model.imms.mfc.QualityCheckModel", "app.store.imms.mfc.QualityCheckStore",
        "app.model.imms.mfc.RfidCardModel", "app.store.imms.mfc.RfidCardStore",
        "app.model.imms.org.WorkstationModel", "app.store.imms.org.WorkstationStore",
        "app.model.imms.org.WorkshopModel", "app.store.imms.org.WorkshopStore",
        "app.model.imms.material.MaterialModel", "app.store.imms.material.MaterialStore",
        "app.model.imms.org.OperatorModel", "app.store.imms.org.OperatorStore",
        "app.model.imms.mfc.ProductionOrderModel", "app.store.imms.mfc.ProductionOrderStore"
    ],
    uses: ["app.view.imms.mfc.qualityCheck.QualityCheckDetailForm"],
    columns: [
        // { dataIndex: "productionOrderNo", text: "计划单号", width: 100 },
        { dataIndex: "recordId", text: "业务流水" },
        { dataIndex: "productionCode", text: "产品代码", width: 100 },
        { dataIndex: "productionName", text: "产品名称", width: 200 },
        { dataIndex: "qty", text: "缺陷数量", width: 100 },

        { dataIndex: "defectTypeCode", text: "品质代码", width: 100 },
        { dataIndex: "defectDescription", text: "品质描述", width: 200 },

        { dataIndex: "discoverCode", text: "发现人工号", width: 100 },
        { dataIndex: "discoverName", text: "发现人姓名", width: 150 },
        { dataIndex: "discoverTime", text: "发现时间", width: 150 },

        { dataIndex: "producerCode", text: "生产人工号", width: 100 },
        { dataIndex: "producerName", text: "生产人姓名", width: 150 },
        { dataIndex: "produceTime", text: "产生时间", width: 150 },

        { dataIndex: "responseCode", text: "责任人工号", width: 100 },
        { dataIndex: "reponseName", text: "责任人姓名", width: 150 },
    ],
    constructor: function (config) {
        var configBase = {
            detailFormClass: 'imms_mfc_qualityCheck_QualityCheckDetailForm',
            detailWindowTitle: '品质记录',
            store: Ext.create({ xtype: 'imms_mfc_QualityCheckStore' })
        }
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    }
});