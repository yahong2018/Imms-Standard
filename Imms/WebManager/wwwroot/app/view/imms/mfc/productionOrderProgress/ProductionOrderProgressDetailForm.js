Ext.define("app.view.imms.mfc.productionOrderProgress.ProductionOrderProgressDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "imms_mfc_productionOrderProgress_ProductionOrderProgressDetailForm",
    padding: 5,
    width: 850,
    layout: "anchor",
    defaults: {
        layout: "anchor",
        anchor: "100%",
    },
    workshopStore: Ext.create({ xtype: 'imms_org_WorkshopStore', autoLoad: true, pageSize: 0 }),
    workstationStore: Ext.create({ xtype: 'imms_org_WorkstationStore', autoLoad: true, pageSize: 0 }),
    operatorStore: Ext.create({ xtype: 'imms_org_OperatorStore', autoLoad: true, pageSize: 0 }),
    productionOrderStore: Ext.create({ xtype: "imms_mfc_ProductionOrderStore", autoLoad: false }),
    // rfidCardStore: Ext.create({ xtype: "imms_mfc_RfidCardStore", autoLoad: false }),
    items: [
        { name: "productionOrderId", xtype: "hidden" },
        { name: "workshopId", xtype: "hidden" },
        { name: "workstationId", xtype: "hidden" },
        { name: "productionId", xtype: "hidden" },
        { name: "operatorId", xtype: "hidden" },
        {
            name: "productionOrderNo", fieldLabel: "计划单号", allowBlank: false, xtype: "textfield", width: 250, listeners: {
                change: function (elf, newValue, oldValue, eOpts) {
                    var form = this.up("imms_mfc_productionOrderProgress_ProductionOrderProgressDetailForm");
                    form.productionOrderStore.clearCustomFilter();
                    form.productionOrderStore.addCustomFilter({ L: "orderNo", O: "=", "R": newValue });
                    form.productionOrderStore.buildFilterUrl();
                    form.productionOrderStore.load(function (records, operation, success) {
                        if (records.length == 0) {
                            return;
                        }
                        form.down("[name='productionId']").setValue(records[0].get("productionId"));
                        form.down("[name='productionCode']").setValue(records[0].get("productionCode"));
                        form.down("[name='productionName']").setValue(records[0].get("productionName"));
                    });
                }
            }
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                {
                    name: "workshopCode", fieldLabel: "车间编码", allowBlank: false, xtype: "textfield", width: 250, listeners: {
                        change: function (self, newValue, oldValue, eOpts) {
                            debugger;

                            var form = this.up("imms_mfc_productionOrderProgress_ProductionOrderProgressDetailForm");
                            var record = form.workshopStore.findRecord("orgCode", newValue, 0, false, false, true);
                            if (record != null) {
                                form.down("[name='workshopId']").setValue(record.get("workshopId"));                                
                                form.down("[name='workshopName']").setValue(record.get("workshopName"));
                            }
                        }
                    }
                },
                { name: "workshopName", fieldLabel: "车间名称", margin: '0 0 0 20', allowBlank: false, xtype: "textfield", flex: 0.8, readOnly: true },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                {
                    name: "workstationCode", fieldLabel: "工位编码", allowBlank: false, xtype: "textfield", width: 250, listeners: {
                        change: function (self, newValue, oldValue, eOpts) {
                            var form = this.up("imms_mfc_productionOrderProgress_ProductionOrderProgressDetailForm");
                            var record = form.workstationStore.findRecord("orgCode", newValue, 0, false, false, true);
                            if (record != null) {
                                form.down("[name='workstationId']").setValue(record.get("recordId"));
                                form.down("[name='workstationName']").setValue(record.get("orgName"));
                            }
                        }
                    }
                },
                { name: "workstationName", fieldLabel: "工位名称", margin: '0 0 0 20', allowBlank: false,xtype: "textfield", flex: 0.8, readOnly: true },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "productionCode", fieldLabel: "产品编码", xtype: "textfield", allowBlank: false, width: 250, readOnly: true },
                { name: "productionName", fieldLabel: "产品名称", margin: '0 0 0 20', allowBlank: false, xtype: "textfield", flex: 0.8, readOnly: true },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                {
                    name: "employeeId", fieldLabel: "操作员工号", allowBlank: false, xtype: "textfield", width: 250, listeners: {
                        change: function (self, newValue, oldValue, eOpts) {
                            var form = this.up("imms_mfc_productionOrderProgress_ProductionOrderProgressDetailForm");
                            var record = form.operatorStore.findRecord("employeeId", newValue, 0, false, false, true);
                            if (record != null) {
                                form.down("[name='operatorId']").setValue(record.get("recordId"));
                                form.down("[name='employeeName']").setValue(record.get("employeeName"));
                            }
                        }
                    }
                },
                { name: "employeeName", fieldLabel: "操作员姓名", allowBlank: false,margin: '0 0 0 20', xtype: "textfield", flex: 0.8, readOnly: true },
            ]
        },

        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "rfidTerminatorId", fieldLabel: "工位机", xtype: "textfield", width: 250 },
                { name: "rfidControllerId", fieldLabel: "控制器", margin: '0 0 0 20', xtype: "textfield", flex: 0.5 },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "rfidCardNo", fieldLabel: "RFID卡号", xtype: "textfield", width: 250 },
                { name: "reportType", fieldLabel: "汇报类型", allowBlank: false,margin: '0 0 0 20', xtype: "textfield", width: 250 },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "reportTime", fieldLabel: "报工时间", xtype: "textfield", width: 250, allowBlank: false,format: 'Y-m-d H:i:s', },
                { name: "reportQty", fieldLabel: "报工数量", margin: '0 0 0 20', allowBlank: false, xtype: "textfield", width: 250 },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "goodQty", fieldLabel: "良品数", allowBlank: false, xtype: "textfield", width: 250 },
                { name: "badQty", fieldLabel: "不良数", allowBlank: false, margin: '0 0 0 20', xtype: "textfield", width: 250 },
            ]
        },

        { name: "remark", xtype: "textarea", fieldLabel: "备注", flex: 1 },
    ],
    onRecordLoad: function (config) {
        if (config.seq == app.ux.data.DataOperationSeq.BEFORE && config.dataMode == app.ux.data.DataMode.INSERT) {
            config.record.data.reportTime = Ext.Date.format(new Date(), 'Y-m-d H:i:s');
        }
    }
});