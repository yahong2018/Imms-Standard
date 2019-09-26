Ext.define("app.model.imms.org.WorkshopModel", {
    extend: 'Ext.data.Model',
    requires: ["app.model.EmptyGenerator"],
    identifier: 'empty',
    fields: [
        { name: "recordId", dbFieldName: 'record_id', type: "int", unique: true },
        { name: "organizationCode", dbFieldName: 'organization_code', type: "string" },
        { name: "organizationName", dbFieldName: 'organization_name', type: "string" },
        { name: "description", dbFieldName: 'description', type: "string" },
        { name: "nextWorkShopId", dbFieldName: 'next_workshop_id', type: "int" },
        { name: "nextWorkShopCode", dbFieldName: 'next_workshop_code', type: "int" },
        { name: "nextWorkShopName", dbFieldName: 'next_workshop_name', type: "string" }
    ],
    idProperty: "recordId"
});