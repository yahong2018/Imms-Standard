Ext.define("app.view.imms.org.workshop.Workshop", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "org_workshop_Workshop",
    requires: ["app.model.imms.org.WorkshopModel", "app.store.imms.org.WorkshopStore"],
    uses: ["app.view.imms.org.workshop.WorkshopDetailForm"],
    hideDefeaultPagebar: true,
    hideSearchBar: true,

    columns: [
        { dataIndex: "orgCode", text: "车间代码", width: 100 },
        { dataIndex: "orgName", text: "车间名称", width: 100 },
    ],
    constructor: function (config) {
        var configBase = {
            detailFormClass: 'imms_org_workshop_WorkshopDetailForm',
            detailWindowTitle: '车间管理',
            store: Ext.create({ xtype: 'imms_org_WorkshopStore' , grid: this, listeners: {
                load: function () {
                    if (this.getCount() > 0 && !this.grid.dataProcessed) {
                        this.grid.dataProcessed = true;
                        this.grid.getSelectionModel().select(0);
                    }
                }            
            }})
        }
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    },

    listeners: {
        beforeselect: 'gridSelectionChanged',
    }
});