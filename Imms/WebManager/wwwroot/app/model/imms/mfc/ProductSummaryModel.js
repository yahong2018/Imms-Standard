Ext.define("app.model.mfc.ProductSummaryModel", {
    extend: "Ext.data.Model",
    fields: [
        { name: "productionId", type: "int" },
        { name: "productionCode", type: "string" },
        { name: "productionName", type: "string" },
        { name: "workshopId", type: "int" },
        { name: "workshopCode", type: "string" },
        { name: "workshopName", type: "string" },
        { name: "qty", type: "int" }
    ]
});