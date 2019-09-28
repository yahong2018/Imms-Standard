Ext.define("app.view.imms.org.workstation.Workstation", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "org_workstation_Workstation",
    requires: ["app.model.imms.org.WorkstationModel", "app.store.imms.org.WorkstationStore", "app.model.imms.org.WorkshopModel"],
    uses: ["app.view.imms.org.workstation.WorkstationDetailForm"],

    hideDefeaultPagebar: true,
    hideSearchBar: true,
    
    columns: [
        { dataIndex: "organizationCode", text: "工位代码", width: 100 },
        { dataIndex: "organizationName", text: "工位名称", width: 100 },
        { dataIndex: "rfidControllerId", text: "Rfid控制器编号", width: 150 },
        { dataIndex: "rfidTerminatorId", text: "Rfid工位机编号", width: 150 },
        { dataIndex: "description", text: "备注", flex: 1 }
    ],
    constructor: function (config) {
        var configBase = {
            store: Ext.create({ xtype: 'imms_org_WorkstationStore' }),
            detailFormClass: 'imms_org_workstation_WorkstationDetailForm',
            detailWindowTitle: '工位管理'
        }
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    },
});