Ext.define("app.view.imms.mfc.qualityCheck.QualityCheckDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "imms_mfc_qualityCheck_QualityCheckDetailForm",
    width: 750,
    padding: 5,
    layout: "anchor",
    defaults: {
        layout: "anchor",
        anchor: "100%",
    },
    // productionOrderStore: Ext.create({ xtype: "imms_mfc_ProductionOrderStore", autoLoad: false }),
    operatorStore: Ext.create({ xtype: 'imms_org_OperatorStore', autoLoad: true, pageSize: 0 }),
    workshopStore: Ext.create({ xtype: 'imms_org_WorkshopStore', autoLoad: true, pageSize: 0 }),
    workstationStore: Ext.create({ xtype: 'imms_org_WorkstationStore', autoLoad: true, pageSize: 0 }),
    items: [
        // { name: "productionOrderId", xtype: "hidden" },
        { name: "productionId", xtype: "hidden" },
        { name: "discoverId", xtype: "hidden" },
        { name: "producerId", xtype: "hidden" },
        { name: "responseId", xtype: "hidden" },

        // {
        //     name: "productionOrderNo", xtype: "textfield", fieldLabel: "计划单号", margin: '0 20 5 0', allowBlank: false,
        //     listeners: {
        //         change: function (elf, newValue, oldValue, eOpts) {
        //             var form = this.up("imms_mfc_qualityCheck_QualityCheckDetailForm");
        //             form.productionOrderStore.clearCustomFilter();
        //             form.productionOrderStore.addCustomFilter({ L: "orderNo", O: "=", "R": newValue });
        //             form.productionOrderStore.buildFilterUrl();
        //             form.productionOrderStore.load(function (records, operation, success) {
        //                 if (records.length == 0) {
        //                     return;
        //                 }
        //                 form.down("[name='productionId']").setValue(records[0].get("productionId"));
        //                 form.down("[name='productionCode']").setValue(records[0].get("productionCode"));
        //                 form.down("[name='productionName']").setValue(records[0].get("productionName"));
        //             });
        //         }
        //     }
        // },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "productionCode", xtype: "textfield", fieldLabel: "产品", allowBlank: false },
                { name: "productionName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                {
                    name: "discoverCode", xtype: "textfield", fieldLabel: "发现人", allowBlank: false,
                    listeners: {
                        change: function (self, newValue, oldValue, eOpts) {
                            var form = this.up("imms_mfc_qualityCheck_QualityCheckDetailForm");
                            var record = form.operatorStore.findRecord("employeeId", newValue, 0, false, false, true);
                            if (record != null) {
                                form.down("[name='discoverId']").setValue(record.get("recordId"));
                                form.down("[name='discoverName']").setValue(record.get("employeeName"));
                            }
                        }
                    }
                },
                { name: "discoverName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        },
        { name: "discoverTime", xtype: "textfield", fieldLabel: "发现时间", margin: '0 20 5 0', allowBlank: false },

        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                {
                    name: "producerCode", xtype: "textfield", fieldLabel: "产生人", allowBlank: false,
                    listeners: {
                        change: function (self, newValue, oldValue, eOpts) {
                            var form = this.up("imms_mfc_qualityCheck_QualityCheckDetailForm");
                            var record = form.operatorStore.findRecord("employeeId", newValue, 0, false, false, true);
                            if (record != null) {
                                form.down("[name='producerId']").setValue(record.get("recordId"));
                                form.down("[name='producerName']").setValue(record.get("employeeName"));
                            }
                        }
                    }
                },
                { name: "producerName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        },
        { name: "produceTime", xtype: "textfield", fieldLabel: "产生时间", margin: '0 20 5 0', allowBlank: false },

        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                {
                    name: "responseCode", xtype: "textfield", fieldLabel: "责任人", allowBlank: false,
                    listeners: {
                        change: function (self, newValue, oldValue, eOpts) {
                            var form = this.up("imms_mfc_qualityCheck_QualityCheckDetailForm");
                            var record = form.operatorStore.findRecord("employeeId", newValue, 0, false, false, true);
                            if (record != null) {
                                form.down("[name='responseId']").setValue(record.get("recordId"));
                                form.down("[name='responseName']").setValue(record.get("employeeName"));
                            }
                        }
                    }
                },
                { name: "responseName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        },

        { name: "defectTypeCode", xtype: "textfield", fieldLabel: "缺陷代码", margin: '0 20 5 0', allowBlank: false },
        { name: "qty", xtype: "textfield", fieldLabel: "缺陷数量", margin: '0 20 5 0', allowBlank: false },
        { name: "defectDescription", xtype: "textarea", fieldLabel: "缺陷描述", margin: '0 20 5 0', allowBlank: false },
    ],
    showHiddenItems: [
        {
            name: "recordId",
            xtype: "textfield",
            fieldLabel: "业务流水号",
            readOnly: true,
        }
    ]
});