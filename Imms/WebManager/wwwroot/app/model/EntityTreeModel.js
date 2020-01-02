Ext.define('app.model.EntityTreeModel', {
    extend: 'Ext.data.TreeModel',    
    requires:["app.model.EmptyGenerator"],
    identifier:'empty',
    fields: [
        { name: "recordId", type: "string", unique: true },
    ],
    idProperty: 'recordId'
});