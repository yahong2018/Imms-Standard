Ext.define("app.view.imms.mfc.defectCode.DefectCodeDetailForm", {
    extend: "Ext.form.Panel",
    xtype: "imms_mfc_defectCode_DefectCodeDetailForm",
    width: 500,
    bodyPadding: 5,
    items: [
        { name: "recordId", xtype: "hidden" },
        { name: "defectCode", xtype: "textfield", width: 300, fieldLabel: "缺陷代码", allowBlank: false },
        { name: "defectName", xtype: "textarea", width: 480, fieldLabel: "缺陷描述", allowBlank: false },
    ]
})