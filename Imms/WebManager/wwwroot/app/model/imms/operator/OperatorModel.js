Ext.define("app.model.imms.operator.OperatorModel",{
    extend:"app.model.TrackableModel",
    fields:[        
        { name: "workshopCode", dbFieldName: 'workshop_code', type: "string" },
        { name: "employeeId", dbFieldName: 'employee_id', type: "string" },
        { name: "employeeName", dbFieldName: 'employee_name', type: "string" },
        { name: "employeeCardNo", dbFieldName: 'employee_card_no', type: "string" },
    ]
});