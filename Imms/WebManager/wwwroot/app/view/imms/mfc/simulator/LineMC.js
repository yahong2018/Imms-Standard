Ext.define("app.view.imms.mfc.simulator.LineMC", {
    extend: "Ext.container.Container",
    xtype: "app_view_imms_mfc_simulator_LineMC",
    requires: ["app.view.imms.mfc.simulator.RfidTerminator"],
    margin: 5,
    items: [
        {
            xtype: "panel",
            layout: "hbox",
            margin: 5,
            items: [
                {
                    xtype: "imms_mfc_simulator_RfidTerminator",
                    workstationName: "MC加工1号线",
                    GID: 2,
                    DID: 31,
                },
                {
                    xtype: "imms_mfc_simulator_RfidTerminator",
                    workstationName: "MC加工2号线",
                    GID: 2,
                    DID: 32,
                },
            ]
        },
        {
            xtype: "panel",
            layout: "hbox",
            margin: 5,
            items: [
                {
                    xtype: "imms_mfc_simulator_RfidTerminator",
                    workstationName: "MC加工3号线",
                    GID: 2,
                    DID: 33
                },
                {
                    xtype: "imms_mfc_simulator_RfidTerminator",
                    workstationName: "MC加工4号线",
                    GID: 2,
                    DID: 34
                }]
        }
    ]
});