Ext.define("app.model.imms.rpt.ManufacturingSummaryModel", {
    extend: "Ext.data.Model",
    requires: ["app.ux.ZhxhDate"],
    fields: [
        { name: "productionId", type: "int" },
        { name: "productionCode", type: "string" },
        { name: "productionName", type: "string" },
        { name: "workshopId", type: "int" },
        { name: "workshopCode", type: "string" },
        { name: "workshopName", type: "string" },
        { name: "finishedQty", type: "int" },
        { name: "moveInQty", type: "int" },
        { name: "moveOutQty", type: "int" },
        { name: "badQty", type: "int" },        
        { name: "TimeOfOriginWork", type: "zhxhDate", dateFormat: 'Y-m-d' },
    ]
});