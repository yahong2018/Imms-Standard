Ext.define('app.view.admin.systemParameter.SystemParameter', {
    extend: 'Ext.form.FormPanel',
    xtype: 'admin_systemParameter_SystemParameter',
    items: [
        {
           xtype:"button",
           text:"同步",
           handler:function(){
               app.ux.Utils.ajaxRequest({
                   url:"api/system/parameter/sync_wdb",
                   method:"GET",
                   successCallback: function (result, response, opts){
                       debugger;
                       alert(result);
                   }
               })
           }
        }
    ]
});