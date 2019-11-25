Ext.define("app.view.imms.material.material.BomDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "app_view_imms_material_material_BomDetailForm",
    padding: 10,
    width: 520,
    items: [
        {
            xtype: "hidden",
            name: "bomNo",
            value: ""
        },
        {
            xtype: "hidden",
            name: "bomStatus",
            value: "0",
        }, {
            xytpe: "hidden",
            name: "bomType",
            value: "1",
        },
        { name: "materialCode", fieldLabel: "父件编码", xtype: "textfield", maxLength: 20, allowBlank: false, enforceMaxLength: true, width: 250, readOnly: true, },
        { name: "materialName", fieldLabel: "父件名称", xtype: "textfield", maxLength: 50, allowBlank: false, enforceMaxLength: true, width: 500, readOnly: true, },
        { name: "materialQty", fieldLabel: "父件用量", xtype: "textfield", width: 200,allowBlank: false, enforceMaxLength: true, },
        { name: "componentCode", fieldLabel: "组品编码", xtype: "textfield", maxLength: 20, allowBlank: false, enforceMaxLength: true, width: 250, },
        { name: "componentName", fieldLabel: "组品名称", xtype: "textfield", maxLength: 50, allowBlank: false, enforceMaxLength: true, width: 500,readOnly:true },
        { name: "componentQty", fieldLabel: "组件用量", xtype: "textfield", width: 200,allowBlank: false, enforceMaxLength: true },
        { name: "effectDate", fieldLabel: "生效日期", xtype: "textfield", width: 200,allowBlank: false, enforceMaxLength: true },
    ]
});