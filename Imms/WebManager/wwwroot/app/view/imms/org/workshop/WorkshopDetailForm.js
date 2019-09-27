Ext.define("app.view.imms.org.workshop.WorkshopDetailForm", {
    extend: "Ext.form.Panel",
    xtype: "imms_org_workshop_WorkshopDetailForm",
    requires: ["app.model.imms.org.WorkshopModel"],
    width: 400,
    bodyPadding: 5,
    defaults: {
        labelWidth: 70
    },
    items: [
        {
            name: 'recordId',
            xtype: 'hidden',
        }, {
            name: "organizationCode",
            xtype: "textfield",
            fieldLabel: "车间代码",
            allowBlank: false,
            maxLength: 6,
            enforceMaxLength: true,
            width: 150
        }, {
            name: "organizationName",
            xtype: "textfield",
            fieldLabel: "车间名称",
            allowBlank: false,
            maxLength: 50,
            enforceMaxLength: true,
            width: 380
        }, {
            name: "nextWorkShopId",
            xtype: "combobox",
            fieldLabel: "下一车间",
            width: 380,
            valueField: "recordId",
            displayField: "organizationName",
            store: Ext.create("Ext.data.Store", {
                model: "app.model.imms.org.WorkshopModel",
                proxy: {
                    type: 'ajax',
                    url: 'imms/org/workshop/getAll',
                    reader: {
                        type: 'json',
                        rootProperty: "children"
                    }
                }
            })
        }, {
            name: "description",
            xtype: "textarea",
            fieldLabel: "备注",
            width: 380
        }
    ]
});