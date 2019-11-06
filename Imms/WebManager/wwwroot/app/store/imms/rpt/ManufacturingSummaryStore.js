Ext.define("app.store.imms.rpt.ManufacturingSummaryStore",{
    extend:"app.store.BaseStore",
    model:"app.model.imms.rpt.ManufacturingSummaryModel",
    alias:"widget.imms_rpt_ManufacturingSummaryStore",
    dao:{
        selectUrl:"imms/mfc/productionOrderProgress/getProductProgressSummary"
    } 
});