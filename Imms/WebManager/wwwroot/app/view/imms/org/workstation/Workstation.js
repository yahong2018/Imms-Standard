Ext.define("app.view.imms.org.workstation.Workstation", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "org_workstation_Workstation",
    requires: ["app.model.imms.org.WorkshopModel", "app.store.imms.org.WorkshopStore"],
    uses: ["app.view.imms.org.workshop.WorkshopDetailForm"],
    columns: [
        { dataIndex: "organizationCode", text: "车间代码", width: 100 },
        { dataIndex: "organizationName", text: "车间名称", width: 100 },
        { dataIndex: "nextWorkShopCode", text: "下一车间代码", width: 100 },
        { dataIndex: "nextWorkShopName", text: "下一车间名称", width: 100 },
        { dataIndex: "description", text: "备注", flex: 1 }
    ],
    constructor: function (config) {
        var configBase = {
            store: Ext.create({ xtype: 'imms_org_WorkshopStore' }),
            detailFormClass: 'imms_org_workshop_WorkshopDetailForm',
            detailWindowTitle: '车间管理'
        }
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    },
});