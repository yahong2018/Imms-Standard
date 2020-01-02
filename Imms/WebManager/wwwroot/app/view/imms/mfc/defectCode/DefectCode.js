Ext.define("app.view.imms.mfc.defectCode.DefectCode", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "app_view_imms_mfc_defectCode_DefectCode",
    requires: ["app.model.imms.mfc.DefectModel", "app.store.imms.mfc.DefectStore"],
    uses: ["app.view.imms.mfc.defectCode.DefectCodeDetailForm"],
    columns: [
        { dataIndex: "defectCode", text: "缺陷代码" },
        { dataIndex: "defectName", text: "缺陷描述", flex: 1 }
    ],
    constructor: function (config) {
        var configBase = {
            detailFormClass: 'imms_mfc_defectCode_DefectCodeDetailForm',
            detailWindowTitle: '缺陷代码',
            store: Ext.create({ xtype: 'imms_mfc_DefectStore' })
        }
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    }
});