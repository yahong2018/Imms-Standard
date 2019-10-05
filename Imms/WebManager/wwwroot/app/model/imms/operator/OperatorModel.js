Ext.define("app.model.imms.operator.OperatorModel",{
    extend:"app.model.EntityModel",
    fields:[        
        { name: "organizationId", dbFieldName: 'organization_id', type: "int" },
        { name: "employeeId", dbFieldName: 'employee_id', type: "int" },
        { name: "employeeName", dbFieldName: 'employee_name', type: "string" },
        { name: "EmployeeCardNo", dbFieldName: 'employee_card_no', type: "string" },
    ]
});