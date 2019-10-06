Ext.define("app.model.imms.org.WorkshopModel", {
    extend: 'app.model.imms.org.OrganizationModel',
    fields: [
        { name: "nextWorkShopId", type: "int" },
        { name: "nextWorkshopCode", type: "string" },
        { name: "nextWorkshopName", type: "string" }
    ]
});