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
            maxLength: 6,
            enforceMaxLength: true,
            width: 150
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
            name: "nextWorkshopCode",
            xtype: "hidden"
        }, {
            name: "nextWorkshopName",
            xtype: "hidden"
        },
        {
            name: "nextWorkshopId",
            xtype: "combobox",
            fieldLabel: "下一车间",
            width: 380,
            valueField: "recordId",
            displayField: "orgName",
            store: Ext.create("Ext.data.Store", {
                model: "app.model.imms.org.WorkshopModel",
                autoLoad: false,
                proxy: {
                    type: 'ajax',
                    url: 'api/imms/org/workshop/getAll',
                    reader: {
                        type: 'json',
                        rootProperty: "rootProperty"
                    }
                }
            }),
            listeners: {
                change: function (self, newValue, oldValue, eOpts) { 
                    var record = self.getSelectedRecord();                    
                    var form = self.up("imms_org_workshop_WorkshopDetailForm");
                    var nextWorkshopCode = form.down("[name='nextWorkshopCode']");
                    var nextWorkshopName = form.down("[name='nextWorkshopName']");
                    nextWorkshopCode.setValue(record.get("orgCode"));
                    nextWorkshopName.setValue(record.get("orgName"));
                }
            }
        }, {
            name: "description",
            xtype: "textarea",
            fieldLabel: "备注",
            width: 380
        }
    ],
    onRecordLoad: function (config) {
        var store = this.down('[name="nextWorkshopId"]').store;
        store.load();
    }
});