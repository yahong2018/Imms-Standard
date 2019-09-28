Ext.define("app.view.imms.org.workstation.WorkstationDetailForm",{
    extend: "Ext.form.Panel",
    xtype: "imms_org_workstation_WorkstationDetailForm",
  
    width: 400,
    bodyPadding: 5,
    defaults: {
        labelWidth: 100
    },
    items: [
        {
            name: 'recordId',
            xtype: 'hidden',
        }, {
            name: "organizationCode",
            xtype: "textfield",
            fieldLabel: "工位代码",
            allowBlank: false,
            maxLength: 6,
            enforceMaxLength: true,
            width: 180
        }, {
            name: "organizationName",
            xtype: "textfield",
            fieldLabel: "工位名称",
            allowBlank: false,
            maxLength: 50,
            enforceMaxLength: true,
            width: 380
        }, {
            name: "rfidControllerId",
            xtype: "textfield",
            fieldLabel: "Rfid控制器编号",
            allowBlank: false,
            maxLength: 3,
            enforceMaxLength: true,
            width: 180
        }, , {
            name: "rfidTerminatorId",
            xtype: "textfield",
            fieldLabel: "Rfid工位机编号",
            allowBlank: false,
            maxLength: 3,
            enforceMaxLength: true,
            width: 180
        }, 
        {
            name: "parentOrganizationId",
            xtype: "combobox",
            fieldLabel: "所属车间",
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
                        rootProperty: "rootProperty"
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