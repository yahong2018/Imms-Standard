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
					columns: [
						{ text: "产品编号", width: 150, menuDisabled: true },
						{ text: "产品名称", width: 300, menuDisabled: true },

						{ text: "入库", width: 50, menuDisabled: true },
						{ text: " ", width: 10, menuDisabled: true },

						{ text: "压铸", width: 50, menuDisabled: true },
						{ text: "粗加工", width: 60, menuDisabled: true },
						{ text: "M/C加工", width: 75, menuDisabled: true },
						{ text: "THR", width: 50, menuDisabled: true },
						{ text: " ", width: 10, menuDisabled: true },

						{ text: "切断", width: 50, menuDisabled: true },
						{ text: "锻造", width: 50, menuDisabled: true },
						{ text: "E/V前加工", width: 85, menuDisabled: true },
						{ text: "渗氮", width: 50, menuDisabled: true },
						{ text: "E/V后加工", width: 85, menuDisabled: true },
						{ text: " ", width: 10, menuDisabled: true },

						{ text: "注塑", width: 50, menuDisabled: true },
						{ text: "组装", width: 50, menuDisabled: true },
					]
				}
			]
		}];
		this.callParent();
	},
	listeners: {
	}
});

