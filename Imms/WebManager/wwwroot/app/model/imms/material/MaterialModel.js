Ext.define('app.model.imms.material.MaterialModel', {
    extend: 'app.model.TrackableModel',
    fields: [
        { name: "materialCode", type: "string" },
        { name: "materialName", type: "string" },
        { name: "description", type: "string" },
    ]
});