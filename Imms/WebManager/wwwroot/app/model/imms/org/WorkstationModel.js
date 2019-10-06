Ext.define("app.model.imms.org.WorkstationModel", {
    extend: "app.model.imms.org.OrganizationModel",
    fields: [
        { name: "rfidControllerId", type: "int" },
        { name: "rfidTerminatorId", type: "int" }        
    ]
});