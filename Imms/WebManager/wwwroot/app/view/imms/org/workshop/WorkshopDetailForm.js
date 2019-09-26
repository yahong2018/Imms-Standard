Ext.define("app.view.imms.org.workshop.WorkshopDetailForm",{
    extend:"Ext.form.Panel",
    xtype:"imms_org_workshop_WorkshopDetailForm",
    width:400,
    bodyPadding: 5,
    defaults: {
        labelWidth: 70
    },
    items:[
        {
            name: 'recordId',
            xtype: 'hidden',
        },{
            name:"organizationCode",
            xtype:"textfield",
            fieldLabel:"车间代码",
            allowBlank: false,            
            maxLength: 6,
            enforceMaxLength: true,
            width: 150
        },{
            name:"organizationName",
            xtype:"textfield",
            fieldLabel:"车间名称",
            allowBlank: false,            
            maxLength: 50,
            enforceMaxLength: true,
            width: 380
        },{
            name:"nextWorkShopId",
            xtype:"textfield",
            fieldLabel:"下一车间",
            allowBlank: false,            
            maxLength: 50,
            enforceMaxLength: true,
            width: 150
        },{
            name:"description",
            xtype:"textarea",
            fieldLabel:"备注",   
            width: 380
        }
    ]


});