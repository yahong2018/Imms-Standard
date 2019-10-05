Ext.define("app.view.imms.operator.Operator", {
    extend: "app.ux.dbgrid.DbGrid",
    xtype: "app_view_imms_operator_Operator",
    requires: ["app.model.imms.operator.OperatorModel", "app.store.imms.operator.OperatorStore"],
    uses: ["app.view.imms.operator.OperatorDetailForm"],
    columns: [
        { dataIndex: "workshopCode", text: "所属车间", width: 100 },
        { dataIndex: "employeeId", text: "工号", width: 100 },
        { dataIndex: "employeeName", text: "姓名", width: 100 },
        { dataIndex: "employeeCardNo", text: "工卡号", width: 100 },
    ],

    constructor:function(config){
        var configBase = {
            detailFormClass: 'imms_operator_OperatorDetailForm',
            detailWindowTitle: '员工管理',
            store: Ext.create({xtype: 'imms_operator_OperatorStore'})
        }
        Ext.applyIf(config, configBase);

        this.callParent(arguments);
    }
});