Ext.define('app.model.imms.material.MaterialModel', {
    extend: 'app.model.TrackableModel',
    fields: [
        { name: "materialCode", type: "string" },
        { name: "materialName", type: "string" },
        { name: "description", type: "string" },
        { name: "firstWorkshopId", type: "int" },
        { name: "firstWorkshopCode", type: "string" },
        { name: "firstWorkshopName", type: "string" }
    ]
});