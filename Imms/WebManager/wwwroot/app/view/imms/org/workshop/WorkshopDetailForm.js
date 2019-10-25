Ext.define("app.view.imms.org.workshop.WorkshopDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "imms_org_workshop_WorkshopDetailForm",
    requires: ["app.model.imms.org.WorkshopModel"],
    width: 400,
    bodyPadding: 5,
    defaults: {
        labelWidth: 70
    },
    items: [
         {
            name: "orgCode",
            xtype: "textfield",
            fieldLabel: "车间代码",
            allowBlank: false,
            maxLength: 20,
            enforceMaxLength: true,
            width: 250
        }, {
            name: "orgName",
            xtype: "textfield",
            fieldLabel: "车间名称",
            allowBlank: false,
            maxLength: 50,
            enforceMaxLength: true,
            width: 380
        },
        {
            name:"operationIndex",
            xtype:"textfield",
            fieldLabel:"本工序",
            width:380,
        },
        {
            name: "prevOperationIndex",
            xtype: "textfield",
            fieldLabel: "上工序",
            width: 380,
        },
         {
            name: "description",
            xtype: "textarea",
            fieldLabel: "备注",
            width: 380
        }
    ]
});