Ext.define("app.model.imms.org.WorkshopModel", {
    extend: 'app.model.imms.org.OrganizationModel',
    fields: [
        { name: "nextWorkShopId", dbFieldName: 'next_workshop_id', type: "int" },
        {
            name: "nextWorkshopCode", calculate: function (data) {               
                if (data["nextWorkshop"]!=null){
                    return data["nextWorkshop"].workshopCode;
                }
                return "";
            }
        },
        {
            name: "nextWorkshopName",  calculate: function (data) {
                if (data["nextWorkshop"] != null) {
                    return data["nextWorkshop"].workshopName;
                }
                return "";
            }
        }
    ]
});