Ext.define("app.store.imms.mfc.ProductSummaryStore", {
    extend: "Ext.data.Store",
    alias: "widget.imms_mfc_ProductSummaryStore",
    model: "app.model.imms.mfc.ProductSummaryModel",
    proxy: {
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
        { name: "RK", type: "string" },

        { name: "WK01_YZ_1", type: "string" },
        { name: "WK01_YZ_2", type: "string" },

        { name: "WK02_CJG_1", type: "string" },
        { name: "WK02_CJG_2", type: "string" },

        { name: "WK03_MC_1", type: "string" },
        { name: "WK03_MC_2", type: "string" },

        { name: "WK04_THR_1", type: "string" },
        { name: "WK04_THR_2", type: "string" },

        { name: "WK21_QD_1", type: "string" },
        { name: "WK21_QD_2", type: "string" },

        { name: "WK22_DZ_1", type: "string" },
        { name: "WK22_DZ_2", type: "string" },

        { name: "WK23_EV_A_1", type: "string" },
        { name: "WK23_EV_A_2", type: "string" },

        { name: "WK24_EV_1", type: "string" },
        { name: "WK24_EV_2", type: "string" },

        { name: "WK25_EV_B_1", type: "string" },
        { name: "WK25_EV_B_2", type: "string" },

        { name: "WK41_ZS_1", type: "string" },
        { name: "WK41_ZS_2", type: "string" },

        { name: "WK42_ZZ_1", type: "string" },
        { name: "WK42_ZZ_2", type: "string" },
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

                    reportItem.set("WK01_YZ_1", "N/A");
                    reportItem.set("WK21_QD_1", "N/A");
                    reportItem.set("WK41_ZS_1", "N/A");

                    theReportStore.add(reportItem);
                }

                var qty = summaryItem.get("qty");
                if (qty == 0) {
                    qty = "";
                }
                var operationCode = summaryItem.get("workshopCode") + "_" + summaryItem.get("dataType");
                reportItem.set(operationCode, qty);
            }

            theReportStore.commitChanges();
        });
    }
});