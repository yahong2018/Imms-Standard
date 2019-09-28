Ext.define("app.model.imms.org.WorkstationModel", {
    extend: "app.model.imms.org.OrganizationModel",
    fields: [
        { name: "rfidControllerId", dbFieldName: "rfid_controller_id", type: "int" },
        { name: "rfidTerminatorId", dbFieldName: "rfid_terminator_id", type: "int" }        
    ]
});