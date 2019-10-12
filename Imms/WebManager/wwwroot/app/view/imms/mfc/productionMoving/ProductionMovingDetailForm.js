Ext.define("app.view.imms.mfc.productionMoving.ProductionMovingDetailForm", {
    extend: "app.ux.TrackableFormPanel",
    xtype: "imms_mfc_productionMoving_ProductionMovingDetailForm",
    padding: 5,
    width: 600,
    layout: "anchor",
    defaults: {
        layout: "anchor",
        anchor: "100%",
    },
    productionOrderStore: Ext.create({ xtype: "imms_mfc_ProductionOrderStore", autoLoad: false }),
    operatorStore: Ext.create({ xtype: 'imms_org_OperatorStore', autoLoad: true, pageSize: 0 }),
    workshopStore: Ext.create({ xtype: 'imms_org_WorkshopStore', autoLoad: true, pageSize: 0 }),
    workstationStore: Ext.create({ xtype: 'imms_org_WorkstationStore', autoLoad: true, pageSize: 0 }),
    items: [
        { name: "productionOrderId", xtype: "hidden" },
        { name: "productionId", xtype: "hidden" },
        { name: "rfidCardId", xtype: "hidden" },
        { name: "operatorId", xtype: "hidden" },
        { name: "workstationId", xtype: "hidden" },
        { name: "workshopId", xtype: "hidden" },
        { name: "prevProgressRecordId", xtype: "hidden" },

        {
            name: "productionOrderNo", xtype: "textfield", fieldLabel: "计划单号", margin: '0 20 5 0', allowBlank: false,
            listeners: {
                change: function (elf, newValue, oldValue, eOpts) {
                    var form = this.up("imms_mfc_productionMoving_ProductionMovingDetailForm");
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
                { name: "productionCode", xtype: "textfield", fieldLabel: "交接产品", allowBlank: false },
                { name: "productionName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "rfidTerminatorId", xtype: "textfield", fieldLabel: "工位机号" },
                { name: "rfidControllerGroupId", xtype: "textfield", fieldLabel: "控制器号", margin: '0 0 0 20' },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "rfidNo", xtype: "textfield", fieldLabel: "RFID号", },
                { name: "qty", xtype: "textfield", fieldLabel: "接收数量", margin: '0 0 0 20', allowBlank: false },
            ]
        },
        { name: "movingTime", xtype: "textfield", fieldLabel: "接收时间", margin: '0 20 5 0', allowBlank: false },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                {
                    name: "employeeId", xtype: "textfield", fieldLabel: "接收人", allowBlank: false, listeners: {
                        change: function (self, newValue, oldValue, eOpts) {
                            var form = this.up("imms_mfc_productionMoving_ProductionMovingDetailForm");
                            var record = form.operatorStore.findRecord("employeeId", newValue, 0, false, false, true);
                            if (record != null) {
                                form.down("[name='operatorId']").setValue(record.get("recordId"));
                                form.down("[name='employeeName']").setValue(record.get("employeeName"));
                            }
                        }
                    }
                },
                { name: "employeeName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                {
                    name: "workshopCode", xtype: "textfield", fieldLabel: "接收车间", allowBlank: false, listeners: {
                        change: function (self, newValue, oldValue, eOpts) {
                            var form = this.up("imms_mfc_productionMoving_ProductionMovingDetailForm");
                            var record = form.workshopStore.findRecord("orgCode", newValue, 0, false, false, true);
                            if (record != null) {
                                form.down("[name='workshopId']").setValue(record.get("workshopId"));
                                form.down("[name='workshopName']").setValue(record.get("workshopName"));
                            }
                        }
                    }
                },
                { name: "workshopName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                {
                    name: "workstationCode", xtype: "textfield", fieldLabel: "接收工位", allowBlank: false, listeners: {
                        change: function (self, newValue, oldValue, eOpts) {
                            var form = this.up("imms_mfc_productionMoving_ProductionMovingDetailForm");
                            var record = form.workstationStore.findRecord("orgCode", newValue, 0, false, false, true);
                            if (record != null) {
                                form.down("[name='workstationId']").setValue(record.get("recordId"));
                                form.down("[name='workstationName']").setValue(record.get("orgName"));
                            }
                        }
                    }
                },
                { name: "workstationName", xtype: "textfield", margin: '0 20 0 5', flex: 0.8, readOnly: true },
            ]
        }
    ]
});