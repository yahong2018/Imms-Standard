Ext.define("app.view.imms.material.material.MaterialDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "app_view_imms_material_material_MaterialDetailForm",
    padding:10,
    defaults: {
        labelWidth: 70
    },
    items: [
        {
            name: "materialCode",
            fieldLabel: "产品编码",
            xtype: "textfield",
            maxLength: 20,
            allowBlank: false,
            enforceMaxLength: true,
            width: 380,
        },
        {
            name: "materialName",
            fieldLabel: "产品名称",
            xtype: "textfield",
            maxLength: 50,            
            allowBlank: false,
            enforceMaxLength: true,
            width: 380,
        },
        {
            name: "description",
            xtype: "textarea",            
            fieldLabel: "产品描述",
            width: 380,
        }
    ]
});