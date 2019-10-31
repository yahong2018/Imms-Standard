Ext.define("app.model.admin.SystemParameterModel", {
    extend: "app.model.EntityModel",
    fields: [
        { name: "parameterClassId", type: "int" },
        { name: "parameterClassName", type: "string" },
        { name: "parameterCode", type: "string" },
        { name: "parameterName", type: "string" },
        { name: "parameterValue", type: "string" },
    ]
});

Ext.define("app.model.admin.SystemParameterClassModel", {
    extend: "app.model.EntityModel",
    fields: [
        { name: "className", type: "string" }
    ]
});

