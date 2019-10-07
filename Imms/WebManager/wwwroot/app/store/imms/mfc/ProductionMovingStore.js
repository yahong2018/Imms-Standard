Ext.define("app.store.imms.mfc.ProductionMovingStore",{
    extend:"app.store.BaseStore",
    model:"app.model.imms.mfc.ProductionMovingModel",
    alias:"widget.imms_mfc_ProductionMovingStore",

    dao:{
        deleteUrl: 'imms/mfc/productionMoving/delete',
        insertUrl: 'imms/mfc/productionMoving/create',
        updateUrl: 'imms/mfc/productionMoving/update',
        selectUrl: 'imms/mfc/productionMoving/getAll',
    }

});