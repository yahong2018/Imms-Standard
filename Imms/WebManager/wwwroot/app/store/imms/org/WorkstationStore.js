Ext.define("app.store.imms.org.WorkstationStore",{
    extend: "app.store.BaseStore",
    model: 'app.model.imms.org.WorkstationModel',
    alias: 'widget.imms_org_WorkstationStore',

    dao: {
        deleteUrl: 'imms/org/workstation/delete',
        insertUrl: 'imms/org/workstation/create',
        updateUrl: 'imms/org/workstation/update',
        selectUrl: 'imms/org/workstation/getAll',
    }
});