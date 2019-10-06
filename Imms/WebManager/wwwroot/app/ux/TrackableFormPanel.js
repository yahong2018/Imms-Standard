Ext.define('app.ux.TrackableFormPanel', {
    extend: 'Ext.form.FormPanel',
    alias: "widget.app_ux_TrackableFormPanel",

    constructor: function (config) {
        var tempItems = [{
            name: 'recordId',
            xtype: 'hidden',
        }, {
            xtype: "hidden",
            name: "createById",
        }, {
            xtype: "hidden",
            name: "createByCode",
        }, {
            xtype: "hidden",
            name: "createByName",
        }, {
            xtype: "hidden",
            name: "createTime",
        }, {
            xtype: "hidden",
            name: "updateById",
        }, {
            xtype: "hidden",
            name: "updateByCode",
        }, {
            xtype: "hidden",
            name: "updateByName",
        }, {
            xtype: "hidden",
            name: "updateTime",
        }, {
            xtype: "hidden",
            name: "optFlag",
        }];

        for (var i = 0; i < tempItems.length; i++) {
            var exists = false;
            for (var j = 0; j < this.items.length; j++) {
                if (tempItems[i].name == this.items[j].name) {
                    exists = true;
                    break;
                }
            }
            if (!exists) {
                this.items.push(tempItems[i]);
            }
        }

        this.callParent(arguments);
    }
});