Ext.define('app.view.main.region.Center', {
	extend: 'Ext.tab.Panel',
	alias: 'widget.maincenter',

	initComponent: function () {
		this.items = [{
			//	id:'homePage',
			glyph: 0xf015,
			title: '首页',
			border: true,
			frame: false,
			bodyCls: 'panel-background',
			reorderable: false,
			layout: "border",
			items: [
				{
					region: "north",
					height: 50,
					xtype: "label",
					text: "本日生产状态一览表",
					style: "text-align:center;font-size:24px;font-weight:bolder;line-height:50px;vertical-align: middle;"
				},
				{
					region: "center",
					xtype: "gridpanel",
					height: "100%",
					border: 1,
					columnLines: true,
					store: Ext.create({ xtype: "imms_mfc_ProductSummaryReportStore", autoLoad: false }),
					columns: [
						{dataIndex:"productionCode", text: "产品编号", width: 150, menuDisabled: true },
						{ dataIndex: "productionName", text: "产品名称", width: 300, menuDisabled: true },

						{ dataIndex: "RK", text: "入库", width: 50, menuDisabled: true },
						{ text: " ", width: 10, menuDisabled: true },

						{ dataIndex: "WK01_YZ", text: "压铸", width: 50, menuDisabled: true },
						{ dataIndex: "WK02_CJG", text: "粗加工", width: 60, menuDisabled: true },
						{ dataIndex: "WK03_MC", text: "M/C加工", width: 75, menuDisabled: true },
						{ dataIndex: "WK04_THR", text: "THR", width: 50, menuDisabled: true },
						{ text: " ", width: 10, menuDisabled: true },

						{ dataIndex: "WK21_QD", text: "切断", width: 50, menuDisabled: true },
						{ dataIndex: "WK22_DZ", text: "锻造", width: 50, menuDisabled: true },
						{ dataIndex: "WK23_EV_A", text: "E/V前工程", width: 85, menuDisabled: true },
						{ dataIndex: "WK24_EV", text: "渗氮", width: 50, menuDisabled: true },
						{ dataIndex: "WK25_EV_B",text: "E/V后工程", width: 85, menuDisabled: true },
						{ text: " ", width: 10, menuDisabled: true },

						{ dataIndex: "WK41_ZS",text: "注塑", width: 50, menuDisabled: true },
						{ dataIndex: "WK42_ZZ", text: "组装", width: 50, menuDisabled: true },
					],					  
				}
			]
		}];
		this.callParent();
	},
	listeners: {
	}
});

