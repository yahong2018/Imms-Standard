Ext.define("app.store.imms.operator.OperatorStore", {
    extend: "app.store.BaseStore",
    model: 'app.model.imms.operator.OperatorModel',
    alias: 'widget.imms_operator_OperatorStore',

    dao: {
        deleteUrl: 'imms/operator/delete',
        insertUrl: 'imms/operator/create',
        updateUrl: 'imms/operator/update',
        selectUrl: 'imms/operator/getAll',
    }
});