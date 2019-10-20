Ext.define("app.store.imms.mfc.ProductSummaryStore", {
    extend: "Ext.data.Store",
    alias: "widget.imms_mfc_ProductSummaryStore",
    model: "app.model.imms.mfc.ProductSummaryModel",
    proxy:{
        type: 'ajax',
        url: 'home/getTodayProductSummary',
        reader: {
            type: "json",
            rootProperty: 'rootProperty'
        }
    }    
});

Ext.define("app.store.imms.mfc.ProductSummaryReportStore", {
    extend: "Ext.data.Store",
    alias: "widget.imms_mfc_ProductSummaryReportStore",
    fields: [
        { name: "productionCode", type: "string" },
        { name: "productionName", type: "string" },
        { name: "RK", type: "int" },

        { name: "WK01_YZ", type: "int" },
        { name: "WK02_CJG", type: "int" },
        { name: "WK03_MC", type: "int" },
        { name: "WK04_THR", type: "int" },

        { name: "WK21_QD", type: "int" },
        { name: "WK22_DZ", type: "int" },
        { name: "WK23_EV_A", type: "int" },
        { name: "WK24_EV", type: "int" },
        { name: "WK25_EV_B", type: "int" },

        { name: "WK41_ZS", type: "int" },
        { name: "WK42_ZZ", type: "int" },
    ],

    loadReportData: function (innerStore) {
        var theReportStore = this;
        innerStore.load(function (records, operation, success) {
            // debugger;
            
            theReportStore.removeAll();
            theReportStore.commitChanges();

            for (var i = 0; i < records.length; i++) {
                var summaryItem = records[i];
                var reportItem = theReportStore.findRecord("productionCode", summaryItem.get("productionCode"));
                if (!reportItem) {
                    reportItem = theReportStore.createModel({});
                    reportItem.set("productionCode", summaryItem.get("productionCode"));
                    reportItem.set("productionName", summaryItem.get("productionName"));

                    theReportStore.add(reportItem);
                }

                var qty = summaryItem.get("qty");
                var operationCode = summaryItem.get("workshopCode");
                reportItem.set(operationCode, qty);
            }

            theReportStore.commitChanges();
        });
    }
});