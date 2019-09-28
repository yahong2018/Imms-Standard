Ext.define("app.view.imms.org.workshop.Workshop", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "org_workshop_Workshop",
    requires: ["app.model.imms.org.WorkshopModel", "app.store.imms.org.WorkshopStore"],
    uses: ["app.view.imms.org.workshop.WorkshopDetailForm"],
    hideDefeaultPagebar: true,
    hideSearchBar: true,

    columns: [
        { dataIndex: "organizationCode", text: "车间代码", width: 100 },
        { dataIndex: "organizationName", text: "车间名称", width: 100 },
        { dataIndex: "nextWorkShopCode", text: "下一车间代码", width: 100, disableSearch:true },
        { dataIndex: "nextWorkShopName", text: "下一车间名称", width: 100, disableSearch:true},
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