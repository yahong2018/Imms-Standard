Ext.define("app.model.imms.org.WorkshopModel", {
    extend: 'app.model.imms.org.OrganizationModel',
    fields: [
        { name: "nextWorkShopId", dbFieldName: 'next_workshop_id', type: "int" },
        { name: "nextWorkShopCode", dbFieldName: 'next_workshop_code', type: "int" },
        { name: "nextWorkShopName", dbFieldName: 'next_workshop_name', type: "string" }
    ]    
});