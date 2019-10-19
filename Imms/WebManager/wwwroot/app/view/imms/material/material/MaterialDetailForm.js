Ext.define("app.view.imms.material.material.MaterialDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "app_view_imms_material_material_MaterialDetailForm",
    padding:10,
    width:420,
    defaults: {
        labelWidth: 100
    },
    workshopStore: Ext.create({ xtype: 'imms_org_WorkshopStore', autoLoad: true, pageSize: 0 }),
    items: [
        {
            xtype:"hidden",
            name:"firstWorkshopId"
        },
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
            name: "firstWorkshopCode", fieldLabel: "首工序编码", allowBlank: false, xtype: "textfield", width: 250, listeners: {
                change: function (self, newValue, oldValue, eOpts) {
                    var form = this.up("app_view_imms_material_material_MaterialDetailForm");
                    var record = form.workshopStore.findRecord("orgCode", newValue, 0, false, false, true);
                    if (record != null) {
                        form.down("[name='firstWorkshopId']").setValue(record.get("recordId"));                                
                        form.down("[name='firstWorkshopName']").setValue(record.get("orgName"));
                    }
                }
            }
        },
        { name: "firstWorkshopName", fieldLabel: "首工序名称", allowBlank: false, xtype: "textfield", width:380, readOnly: true },
        {
            name: "description",
            xtype: "textarea",            
            fieldLabel: "产品描述",
            width: 380,
        }
    ]
});