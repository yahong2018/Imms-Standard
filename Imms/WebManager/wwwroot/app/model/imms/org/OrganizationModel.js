Ext.define("app.model.imms.org.OrganizationModel", {
    extend: 'Ext.data.Model',
    requires: ["app.model.EmptyGenerator"],
    identifier: 'empty',
    fields: [
        { name: "recordId", dbFieldName: 'record_id', type: "int", unique: true },
        { name: "organizationCode", dbFieldName: 'organization_code', type: "string" },
        { name: "organizationName", dbFieldName: 'organization_name', type: "string" },
        { name: "description", dbFieldName: 'description', type: "string" },
        { name: "parentOrganizationId", dbFieldName: 'parent_organization_id', type: "int" },
    ],
    idProperty: "recordId"
});