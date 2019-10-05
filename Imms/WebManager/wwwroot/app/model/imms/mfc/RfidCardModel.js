Ext.define("app.model.imms.mfc.RfidCardModel", {
    extend: "app.model.TrackableModel",
    fields: [
        { name: "rfidNo", dbFieldName: 'rfid_no', type: "string" },
        { name: "cardType", dbFieldName: 'card_type', type: "int" },
        { name: "cardStatus", dbFieldName: 'card_status', type: "int" },
        { name: "workShopId", dbFieldName: 'workshop_Id', type: "int" },
        { name: "productionId", dbFieldName: 'production_id', type: "int" },
        { name: "qty", dbFieldName: 'qty', type: "int" },
        {
            name: "productionCode", calculate: function (data) {
                if (data["production"] != null) {
                    return data["production"].materialNo;
                }
                return "";
            }
        },        
        {
            name: "productionName", calculate: function (data) {
                if (data["production"] != null) {
                    return data["production"].materialName;
                }
                return "";
            }
        },
        {
            name: "workshopCode", calculate: function (data) {
                if (data["workshop"] != null) {
                    return data["workshop"].workshopCode;
                }
                return "";
            }
        },
        {
            name: "workshopName", calculate: function (data) {
                if (data["workshop"] != null) {
                    return data["workshop"].workshopName;
                }
                return "";
            }
        }
    ]
});