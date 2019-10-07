Ext.define("app.model.imms.mfc.ProductionOrderModel",{
    extend:"app.model.OrderModel",
    fields:[
        { name: "productionId", type: "int" },
        { name: "productionCode", type: "string" },
        { name: "productionName", type: "string" },

        { name: "workshopId", type: "int" },
        { name: "workshopCode", type: "string" },
        { name: "workshopName", type: "string" },

        { name: "qtyPlanned", type: "int" },
        { name: "qtyGood", type: "int" },
        { name: "qtyBad", type: "int" },
    ]
});