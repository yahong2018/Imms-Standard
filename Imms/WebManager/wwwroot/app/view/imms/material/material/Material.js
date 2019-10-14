Ext.define("app.view.imms.material.material.Material", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "app_view_imms_material_material_Material",

    requires: ["app.store.imms.material.MaterialStore", "app.model.imms.material.MaterialModel"],
    uses: ["app.view.imms.material.material.MaterialDetailForm"],

    columns: [
        { dataIndex: "materialCode", text: '产品编码', width: 150 },
        { dataIndex: "materialName", text: '产品名称', width: 150 },
        { dataIndex: "firstWorkshopCode", text: "首工序代码", width: 150 },
        { dataIndex: "firstWorkshopName", text: "首工序名称", width: 200 },
        { dataIndex: "description", text: '产品描述', flex: 1 }
    ],

    constructor: function (config) {
        var configBase = {
            store: Ext.create({ xtype: 'app_store_imms_material_MaterialStore' }),
            detailFormClass: 'app_view_imms_material_material_MaterialDetailForm',
            detailWindowTitle: '物料',
        }
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    }
});