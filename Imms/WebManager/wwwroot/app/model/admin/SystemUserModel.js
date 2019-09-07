Ext.define('app.model.admin.SystemUserModel', {
    extend: 'app.model.EntityModel',
    requires: ["app.ux.ZhxhDate"],  
    fields: [                
        { name: "userCode", dbFieldName: 'userCode', type: "string", unique: true },
        { name: "userName", dbFieldName: 'userName', type: "string" },
        { name: "pwd", dbFieldName: 'pwd', type: "string" },
        { name: "userStatus", dbFieldName: 'userStatus', type: "string" },
        { name: "email", dbFieldName: 'email', type: "string" },        
        { name: "online", dbFieldName: 'online', type: "boolean" },        
        { name: "lastLoginTime", dbFieldName: 'lastLoginTime', type: 'zhxhDate',dateFormat: 'Y-m-d H:i:s'},
    ]
});