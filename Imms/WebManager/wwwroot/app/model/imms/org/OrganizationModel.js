Ext.define("app.model.imms.org.OrganizationModel", {
    extend: 'app.model.EntityModel',      
    fields: [     
        { name: "organizationCode", dbFieldName: 'organization_code', type: "string" },
        { name: "organizationName", dbFieldName: 'organization_name', type: "string" },
        { name: "description", dbFieldName: 'description', type: "string" },
        { name: "parentOrganizationId", dbFieldName: 'parent_organization_id', type: "int" },
    ]
});