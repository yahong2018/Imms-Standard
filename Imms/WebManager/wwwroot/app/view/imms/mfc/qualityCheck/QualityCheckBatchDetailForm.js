Ext.define("app.view.imms.mfc.qualityCheck.QualityCheckBatchDetailForm", {
    extend: "Ext.form.Panel",
    xtype: "imms_mfc_qualityCheck_QualityCheckBatchDetailForm",
    uses: ["Ext.window.Window", "app.view.imms.mfc.qualityCheck.BomTreeSelectForm"],
    width: 650,
    padding: 5,
    layout: "anchor",
    defaults: {
        layout: "anchor",
        anchor: "100%",
    },
    defectStore: Ext.create({ xtype: "imms_mfc_DefectStore", autoLoad: true, pageSize: 0 }),
    operatorStore: Ext.create({ xtype: 'imms_org_OperatorStore', autoLoad: true, pageSize: 0 }),
    productionStore: Ext.create({ xtype: 'app_store_imms_material_MaterialStore', autoLoad: true, pageSize: 0 }),
    items: [
        { name: "defectId", xtype: "hidden" },
        { name: "productionId", xtype: "hidden" },
        { name: "productionName", xtype: "hidden" },
        { name: "workshopCode", xtype: "hidden" },
        { name: "workshopName", xtype: "hidden" },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "timeOfOriginWork", xtype: "datefield", format: 'Y-m-d', fieldLabel: "工作日", allowBlank: false },
                { name: "qty", xtype: "textfield", fieldLabel: "缺陷数量", margin: '0 20 0 20', allowBlank: false },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { name: "shiftId", xtype: "textfield", fieldLabel: "班次", margin: '0 20 5 0', allowBlank: false },
                { xtype: "label", margin: '5 0 0 0', text: "0.白班  1.夜班" },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            items: [
                {
                    name: "workshopId", xtype: "combobox", fieldLabel: "部门", allowBlank: false,
                    valueField: "recordId", displayField: "orgName",
                    store: Ext.create({ xtype: 'imms_org_WorkshopStore', autoLoad: true, pageSize: 0 }),
                    listeners: {
                        change: function (self, newValue, oldValue, eOpts) {
                            var form = this.up("imms_mfc_qualityCheck_QualityCheckBatchDetailForm");
                            var record = self.getSelectedRecord();
                            if (record != null) {
                                form.down("[name='workshopCode']").setValue(record.get("orgCode"));
                                form.down("[name='workshopName']").setValue(record.get("orgName"));

                                var wocgCodeStore = form.down("[name='wocgCode']").getStore();
                                wocgCodeStore.proxy.url = "api/imms/org/workstation/getWorkshopWocgList?workshopId=" + record.get("recordId");
                                wocgCodeStore.load();

                                var locCodestore = form.down("[name='locCode']").getStore();
                                locCodestore.proxy.url = "api/imms/org/workstation/getWorkshopLocList?workshopId=" + record.get("recordId");
                                locCodestore.load();
                            }
                        }
                    }
                },
                {
                    name: "wocgCode", xtype: "combobox", margin: '0 20 0 20', fieldLabel: "工作中心组", allowBlank: false,
                    valueField: "wocgCode", displayField: "wocgCode",
                    store: Ext.create("Ext.data.JsonStore", {
                        fields: [{ name: "wocgCode" }],
                        autoLoad: false,
                        pageSize: 0,
                        params: function () {
                            return { "workshopId": 3 };
                        },
                        proxy: {
                            type: "ajax",
                            url: "api/imms/org/workstation/getWorkshopWocgList",
                            reader: {
                                rootProperty: "rootProperty"
                            }
                        }
                    })
                },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [

                {
                    name: "locCode", xtype: "combobox", margin: '8 20 5 0', fieldLabel: "存储区域", allowBlank: false,
                    displayField: "locCode", valueField: "locCode",
                    store: Ext.create("Ext.data.JsonStore", {
                        fields: [{ name: "locCode" }],
                        autoLoad: false,
                        pageSize: 0,
                        params: function () {
                            return { "workshopId": 3 };
                        },
                        proxy: {
                            type: "ajax",
                            url: "api/imms/org/workstation/getWorkshopLocList",
                            reader: {
                                rootProperty: "rootProperty"
                            }
                        }
                    })
                },
            ]
        },
        {
            xtype: "container",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                {
                    name: "defectCode", xtype: "textfield", fieldLabel: "缺陷", margin: '0 20 5 0', allowBlank: false, listeners: {
                        change: function (self, newValue, oldValue, eOpts) {
                            var form = this.up("imms_mfc_qualityCheck_QualityCheckBatchDetailForm");
                            var record = form.defectStore.findRecord("defectCode", newValue, 0, false, false, true);
                            if (record != null) {
                                form.down("[name='defectId']").setValue(record.get("recordId"));
                                form.down("[name='defectName']").setValue(record.get("defectName"));
                            } else {
                                form.down("[name='defectId']").setValue(-1);
                                form.down("[name='defectName']").setValue("");
                            }
                        }
                    }
                },
                { name: "defectName", xtype: "textfield", margin: '0 20 5 0', readOnly: true, allowBlank: false, flex: 0.8 },
            ]
        }, {
            xtype: "fieldcontainer",
            layout: "hbox",
            fieldLabel: "缺陷产品",
            defaults: {
                hideLabel: true
            },
            margin: '0 0 3 ',
            items: [
                { name: "productionCode", xtype: "textfield", fieldLabel: "产品", readOnly: true, allowBlank: false, flex: 1 },
                {
                    xtype: "button", glyph: 0xf002, tooltip: '查找', handler: function () {
                        var detailForm = this.up("imms_mfc_qualityCheck_QualityCheckBatchDetailForm");
                        var win = Ext.create({
                            xtype: "window",
                            modal: true,
                            title: "部件选择",
                            maximizable: true,
                            minimizable: true,
                            items: [{ xtype: "imms_mfc_qualityCheck_BomTreeSelectForm" }],
                            buttons: [
                                '->'
                                , {
                                    text: '确定',
                                    handler: function () {
                                        var tree = win.down("app_view_imms_mfc_qualityCheck_BomTreePanel");
                                        var componentIdList = [];
                                        var componentCodeList = [];
                                        var componentNameList = [];
                                        var throughTree = function (node) {
                                            for (var i = 0; i < node.childNodes.length; i++) {
                                                var child = node.getChildAt(i);
                                                if (!child.get('checked')) {
                                                    continue;
                                                }
                                                componentIdList.push(child.get("componentId"));
                                                componentCodeList.push(child.get("componentCode"));
                                                componentNameList.push(child.get("componentName"));
                                                throughTree(child);
                                            }
                                        };
                                        var node = tree.getRootNode();
                                        throughTree(node);

                                        detailForm.down("[name='productionId']").setValue(componentIdList.join(";"));
                                        detailForm.down("[name='productionCode']").setValue(componentCodeList.join(";"));
                                        detailForm.down("[name='productionName']").setValue(componentNameList.join(";"));

                                        win.close();
                                        win.destroy();
                                        delete win;
                                        win = null;
                                    }
                                }
                                , {
                                    text: '取消', handler: function () {
                                        win.close();
                                        win.destroy();
                                        delete win;
                                        win = null;
                                    }
                                }
                            ],
                        });
                        win.show();
                    }
                }
            ]
        },
    ]
});