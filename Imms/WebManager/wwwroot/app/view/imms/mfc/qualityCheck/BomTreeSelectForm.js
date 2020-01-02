Ext.define("app.view.imms.mfc.qualityCheck.BomTreeSelectForm", {
    extend: "Ext.form.Panel",
    xtype: "imms_mfc_qualityCheck_BomTreeSelectForm",
    uses: ["Ext.tree.Panel", "Ext.grid.GridPanel"],
    layout: "border",
    height: 500,
    width: 780,
    bodyPadding: 5,
    items: [
        {
            region: "north",
            xtype: "panel",
            layout: "hbox",
            margin: '0 0 3 ',
            items: [
                { xtype: "textfield", name: "productionCode", fieldLabel: "产品编码", flex: 1 },
                {
                    xtype: "button", glyph: 0xf002, tooltip: '查找', handler: function () {
                        var form = this.up("imms_mfc_qualityCheck_BomTreeSelectForm");
                        var productionCode = form.down("[name='productionCode']").getValue();
                        var bomTreeStore = form.down("app_view_imms_mfc_qualityCheck_BomTreePanel").getStore();
                        bomTreeStore.proxy.url = "api/imms/material/bom/getBomTree?materialCode=" + productionCode;
                        bomTreeStore.load();
                    }
                }
            ]
        }, {
            region: "center",
            xtype: "app_view_imms_mfc_qualityCheck_BomTreePanel",           
        }
    ]
});