Ext.define("app.view.imms.org.operator.OperatorDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "imms_org_operator_OperatorDetailForm",
    width: 400,
    bodyPadding: 5,
    defaults: {
        labelWidth: 70
    },
    items: [
        {
            name: "orgCode",
            xtype: "hidden"
        }, {
            name: "orgName",
            xtype: "hidden"
        },
        {
            name: "orgId",
            xtype: "combobox",
            fieldLabel: "所属车间",
            width: 380,
            valueField: "recordId",
            displayField: "orgName",
            store: Ext.create("Ext.data.Store", {
                model: "app.model.imms.org.WorkshopModel",
                autoLoad: false,
                proxy: {
                    type: 'ajax',
                    url: 'imms/org/workshop/getAll',
                    reader: {
                        type: 'json',
                        rootProperty: "rootProperty"
                    }
                }
            }),
            listeners: {
                change: function (self, newValue, oldValue, eOpts) {
                    var record = self.getSelectedRecord();
                    var form = self.up("imms_org_operator_OperatorDetailForm");
                    var orgCode = form.down("[name='orgCode']");
                    var orgName = form.down("[name='orgName']");
                    orgCode.setValue(record.get("orgCode"));
                    orgName.setValue(record.get("orgName"));
                }
            }
        }, {
            name: "employeeId",
            xtype: "textfield",
            fieldLabel: "工号",
            allowBlank: false,
            maxLength: 10,
            enforceMaxLength: true,
            width: 380
        }, {
            name: "employeeName",
            xtype: "textfield",
            fieldLabel: "姓名",
            allowBlank: false,
            maxLength: 20,
            enforceMaxLength: true,
            width: 380,
        }, {
            name: "employeeCardNo",
            xtype: "textfield",
            fieldLabel: "工卡号",
            allowBlank: false,
            maxLength: 10,
            enforceMaxLength: true,
            width: 380
        }
    ]
});