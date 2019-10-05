Ext.define('app.model.imms.material.MaterialModel', {
    extend: 'app.model.TrackableModel',    
    fields: [        
        { name: "materialNo", dbFieldName: 'material_no', type: "string"},
        { name: "materialName", dbFieldName: 'material_name', type: "string" },
        { name: "description", dbFieldName: 'description', type: "string" }
    ]
});