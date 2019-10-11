Ext.define("app.model.imms.mfc.QualityCheckModel", {
    extend: "app.model.TrackableModel",
    fields: [
        { name: "productionOrderId", type: "int" },
        { name: "productionOrderNo", type: "string" },

        { name: "productionId", type: "int" },
        { name: "productionCode", type: "string" },
        { name: "productionName", type: "string" },

        { name: "discoverId", type: "int" },
        { name: "discoverCode", type: "string" },
        { name: "discoverName", type: "string" },
        { name: "discoverTime", type: "zhxhDate", dateFormat: "Y-m-d H:i:s" },

        { name: "producerId", type: "int" },
        { name: "producerCode", type: "string" },
        { name: "producerName", type: "string" },
        { name: "produceTime", type: "zhxhDate", dateFormat: "Y-m-d H:i:s" },

        { name: "responseId", type: "int" },
        { name: "responseCode", type: "string" },
        { name: "responseName", type: "string" },

        { name: "defectTypeCode", type: "string" },
        { name: "defectDescription", type: "string" },
        { name: "qty", type: "int" }
    ]
});