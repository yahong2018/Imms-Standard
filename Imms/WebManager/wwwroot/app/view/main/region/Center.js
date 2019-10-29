Ext.define('app.view.main.region.Center', {
	extend: 'Ext.tab.Panel',
	alias: 'widget.maincenter',
	uses: ['app.ux.ButtonTransparent'],

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
					xtype:"panel",
					layout:"hbox",
					items:[
						{
							xtype: "label",
							text: "本日生产状态一览表",
							flex:1,
							style: "text-align:center;font-size:24px;font-weight:bolder;line-height:50px;vertical-align: middle;"
						},{
							xtype:"button",
							text:"刷新",
							width:80,
							margin:"5 5 5 5",
							handler:function(){
								var summaryGrid = this.up("maincenter").down("gridpanel");
								summaryGrid.store.loadTodayReportData(summaryGrid.summaryStore);								
							}
						}
					]
				},
				{
					region: "center",
					xtype: "gridpanel",
					height: "100%",
					border: 1,
					columnLines: true,
					store: Ext.create({ xtype: "imms_mfc_TodayProductSummaryReportStore", autoLoad: false }),
					columns: [
						{ dataIndex: "productionCode", text: "产品编号", width: 120,align:"center", menuDisabled: true },
						{ dataIndex: "productionName", text: "产品名称", width: 220, align: "center", menuDisabled: true },

						// { dataIndex: "RK", text: "入库", width: 50, menuDisabled: true },
						{ text: " ", width: 10, menuDisabled: true },

						{
							text: "压铸",
							columns: [
								{ dataIndex: "WK01_YZ_1", text: "投入", width: 50, menuDisabled: true },
								{ dataIndex: "WK01_YZ_2", text: "产出", width: 50, menuDisabled: true },
							]
						},

						{
							text: "粗加工",
							columns: [
								{ dataIndex: "WK02_CJG_1", text: "投入", width: 60, menuDisabled: true },
								{ dataIndex: "WK02_CJG_2", text: "产出", width: 60, menuDisabled: true },
							]
						},

						{
							text: "M/C加工",
							columns: [
								{ dataIndex: "WK03_MC_1", text: "投入", width: 75, menuDisabled: true },
								{ dataIndex: "WK03_MC_2", text: "产出", width: 75, menuDisabled: true },
							]
						},
						{
							text: "THR",
							columns: [
								{ dataIndex: "WK04_THR_1", text: "投入", width: 50, menuDisabled: true },
								{ dataIndex: "WK04_THR_2", text: "产出", width: 50, menuDisabled: true },
							]
						},
						{ text: " ", width: 10, menuDisabled: true },

						{
							text: "切断",
							columns: [
								{ dataIndex: "WK21_QD_1", text: "投入", width: 50, menuDisabled: true },
								{ dataIndex: "WK21_QD_2", text: "产出", width: 50, menuDisabled: true },
							]
						},

						{
							text: "锻造",
							columns: [
								{ dataIndex: "WK22_DZ_1", text: "投入", width: 50, menuDisabled: true },
								{ dataIndex: "WK22_DZ_2", text: "产出", width: 50, menuDisabled: true },
							]
						},
						{
							text: "E/V前工程",
							columns: [
								{ dataIndex: "WK23_EV_A_1", text: "投入", width: 85, menuDisabled: true },
								{ dataIndex: "WK23_EV_A_2", text: "产出", width: 85, menuDisabled: true },
							]
						},
						{
							text: "渗氮",
							columns: [
								{ dataIndex: "WK24_EV_1", text: "外发", width: 50, menuDisabled: true },
								{ dataIndex: "WK24_EV_2", text: "回厂", width: 50, menuDisabled: true },
							]
						},
						{
							text: "E/V后工程",
							columns: [
								{ dataIndex: "WK25_EV_B_1", text: "投入", width: 85, menuDisabled: true },
								{ dataIndex: "WK25_EV_B_2", text: "产出", width: 85, menuDisabled: true },
							]
						},
						{ text: " ", width: 10, menuDisabled: true },
						{
							text: "注塑",
							columns: [
								{ dataIndex: "WK41_ZS_1", text: "投入", width: 50, menuDisabled: true },
								{ dataIndex: "WK41_ZS_2", text: "产出", width: 50, menuDisabled: true },
							]
						},
						{
							text: "组装",
							columns: [
								{ dataIndex: "WK42_ZZ_1", text: "投入", width: 50, menuDisabled: true },
								{ dataIndex: "WK42_ZZ_2", text: "产出", width: 50, menuDisabled: true },
							]
						}
					],
				}
			]
		}];
		this.callParent();
	},
	listeners: {
	}
});

