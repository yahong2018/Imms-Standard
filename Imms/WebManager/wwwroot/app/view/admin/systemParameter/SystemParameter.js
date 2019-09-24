Ext.define('app.view.admin.systemParameter.SystemParameter', {
    extend: 'Ext.form.FormPanel',
    xtype: 'admin_systemParameter_SystemParameter',
    items: [
        {
            xtype: 'fieldset',
            title: '与ERP的接口',            
            defaults: {
                labelWidth: 90,
                anchor: '100%',
                //layout: 'hbox'
            },
            items:[
                {
                    name: 'recordId',
                    xtype: 'hidden',                    
                },{
                    name: 'parameter_class',
                    xtype: 'hidden',    
                }
            ]
        }
    ]
});