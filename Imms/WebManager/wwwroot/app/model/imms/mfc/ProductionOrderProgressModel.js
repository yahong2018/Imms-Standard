Ext.define("app.model.imms.mfc.ProductionOrderProgressModel", {
    extend: "app.model.TrackableModel",
    requires: ["app.ux.ZhxhDate"],    
    fields: [
        { name: "productionOrderId", type: "int" },
        { name: "productionOrderNo", type: "string" },

        { name: "workshopId", type: "int" },
        { name: "workshopCode", type: "string" },
        { name: "workshopName", type: "string" },

        { name: "workstationId", type: "int" },
        { name: "workstationCode", type: "string" },
        { name: "workstationName", type: "string" },

        { name: "productionId", type: "int" },
        { name: "productionCode", type: "string" },
        { name: "productionName", type: "string" },

        { name: "operatorId", type: "int" },
        { name: "employeeId", type: "string" },
        { name: "emploeyeeName", type: "string" },

        { name: "rfidTerminatorId", type: "int" },
        { name: "rfidControllerId", type: "int" },

        { name: "reportTime", type: 'zhxhDate', dateFormat: 'Y-m-d H:i:s'  },
        { name: "reportQty", type: "int" },        
        { name: "rfidCardNo", type: "string" },
        { name: "reportType", type: "int" },

        { name: "goodQty", type: "int" },
        { name: "badQty", type: "int" },

        { name: "remark", type: "string" },
    ]
});