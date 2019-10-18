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
					text:"当日各系列生产状态一览表",
					style: "text-align:center;font-size:24px;font-weight:bolder;line-height:50px;vertical-align: middle;"
				},
				{
					region: "center",
					xtype: "container",
					layout: "hbox",
					items: [
						{
							xtype: "gridpanel",
							flex: 0.3,
							height: "100%",
							border: 1,
							columns: [
								{ text: "产品编号" },
								{ text: "产品名称" },
								{ text: "压铸", width: 50 },
								{ text: "粗加工", width: 60 },
								{ text: "M/C加工", width: 75 },
								{ text: "THR", width: 50 },
								{ text: "入库", width: 50 }
							]
						},
						{
							xtype: "gridpanel",
							flex: 0.33,
							height: "100%",
							border: 1,
							columns: [
								{ text: "产品编号" },
								{ text: "产品名称" },								
								{ text: "锻造", width: 50 },
								{ text: "E/V前加工", width: 85 },
								{ text: "渗氮", width: 50 },
								{ text: "E/V后加工", width: 85 },
								{ text: "入库", width: 50 }
							]
						}, {
							xtype: "gridpanel",
							flex: 0.3,
							height: "100%",
							border: 1,
							columns: [
								{ text: "产品编号" },
								{ text: "产品名称" },								
								{ text: "注塑", width: 50 },
								{ text: "组装", width: 50 },
								{ text: "入库", width: 50 }
							]
						}
					]
				}
			]
		}];
		this.callParent();
	},
	listeners: {
	}
});

