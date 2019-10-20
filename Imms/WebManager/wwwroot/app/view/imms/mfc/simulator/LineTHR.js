Ext.define("app.view.imms.mfc.simulator.LineTHR", {
    extend: "Ext.container.Container",
    xtype: "app_view_imms_mfc_simulator_LineTHR",
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
                    workstationName: "THR 1号线",
                    GID: 3,
                    DID: 61,
                },
                {
                    xtype: "imms_mfc_simulator_RfidTerminator",
                    workstationName: "THR 2号线",
                    GID: 3,
                    DID: 62,
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
                    workstationName: "THR 3号线",
                    GID: 3,
                    DID: 63
                },
                {
                    xtype: "imms_mfc_simulator_RfidTerminator",
                    workstationName: "THR 4号线",
                    GID: 3,
                    DID: 64
                }]
        }
    ]
});