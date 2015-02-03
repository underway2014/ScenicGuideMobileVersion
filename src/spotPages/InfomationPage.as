package spotPages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.filter.CFilter;
	import core.layout.Group;
	import core.loadEvents.CLoader;
	import core.loadEvents.Cevent;
	
	import spotViews.InfomationView;
	import spotViews.TravelListView;
	
	public class InfomationPage extends Sprite
	{
		private var buttonSprite:Sprite;
		private var modeArr:Array;
		private var noteArr:Array;
		private var detailSprite:Sprite;
		public function InfomationPage(_arr:Array,_noteArr:Array)
		{
			super();
			modeArr = _arr;
			noteArr = _noteArr;
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,0,1080,608);
			this.graphics.endFill();
			
			buttonSprite = new Sprite();
			detailSprite = new Sprite();
			detailSprite.y = buttonSprite.y = 56;
			detailSprite.x = 384;
			addChild(detailSprite);
			addChild(buttonSprite);
			var titleLoader:CLoader = new CLoader();
			titleLoader.load(SpotGuide.MAIN_PATH + "info_title.png");
			titleLoader.addEventListener(CLoader.LOADE_COMPLETE,titleOkHandler);
			
			initButton();
		}
		private function titleOkHandler(event:Event):void
		{
			var tl:CLoader = event.target as CLoader;
			addChild(tl._loader);
			
			var homeButton:CButton = new CButton([SpotGuide.MAIN_PATH + "back_home_up.png",SpotGuide.MAIN_PATH + "back_home_up.png"],false);
			homeButton.addEventListener(MouseEvent.CLICK,backHomeHandler);
			addChild(homeButton);
			var sepImage:CImage = new CImage(1,34,true,false);
			sepImage.url = SpotGuide.MAIN_PATH + "seprate_line.png";
			var backButton:CButton = new CButton([SpotGuide.MAIN_PATH + "back_up.png",SpotGuide.MAIN_PATH + "back_up.png"],false);
			backButton.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backButton);
			addChild(sepImage);
			homeButton.x = 1080 - 222;
			backButton.x = 1080 - 111;
			sepImage.x = homeButton.x + 111;
			sepImage.y = 11;
		}
		private function backHomeHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(SpotGuide.BACK_HOME,true));
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				group.selectById(0);
				this.visible = false;
			}
		}
		private var group:Group = new Group();
		private function initButton():void
		{
			var infoButton:CButton;
			var nameArr:Array = ["门票","交通","游玩必做事","消费","装备","节庆","旅行路上","温馨提示","小贴士"];// 0 , 1, 5, 2 ,7
			var useArr:Array = [0,1,5,2,7];
			var arrUp:Array = ["info_mp_up.png","info_jt_up.png","info_jq_up.png","info_bx_up.png","info_ts_up.png","info_yj_up.png"];
			var arrDown:Array = ["info_mp_down.png","info_jt_down.png","info_jq_down.png","info_bx_down.png","info_ts_down.png","info_yj_down.png"];
			for(var i:int = 0;i < 5;i++)
			{
				infoButton = new CButton([SpotGuide.MAIN_PATH + arrUp[i],SpotGuide.MAIN_PATH + arrDown[i]],false);
				if(modeArr[useArr[i]] == "")
				{
					infoButton.filters = CFilter.grayFilter;
					infoButton.mouseEnabled = false;
					infoButton.mouseChildren = false;
				}else{
					infoButton.data = modeArr[useArr[i]];
					infoButton.addEventListener(MouseEvent.CLICK,clickHandler);
				}
				buttonSprite.addChild(infoButton);
				infoButton.x = (i % 2) * 192;	
				infoButton.y = Math.floor(i / 2) * 184;
				group.add(infoButton);
			}
			if(noteArr.length)
			{
				var yjBtn:CButton = new CButton([SpotGuide.MAIN_PATH + "info_yj_up.png",SpotGuide.MAIN_PATH + "info_yj_down.png"],false);
				yjBtn.x = 192;
				yjBtn.y = 2 * 184;
				yjBtn.data = "youji";
				yjBtn.addEventListener(MouseEvent.CLICK,clickHandler);
				buttonSprite.addChild(yjBtn);
			}
				
			group.add(yjBtn);
			group.addEventListener(Cevent.SELECT_CHANGE,selectChangeHandler);
			group.selectById(0);
			
			addShadow();
		}
		private function addShadow():void
		{
			var shadowLoad:CLoader = new CLoader();
			shadowLoad.load(SpotGuide.MAIN_PATH + "info_shadow.png");
			shadowLoad.addEventListener(CLoader.LOADE_COMPLETE,shadowHandler);
		}
		private function shadowHandler(event:Event):void
		{
			var sd:CLoader = event.target as CLoader;
			buttonSprite.addChild(sd._loader);
			sd._loader.x = 192 * 2;
		}
		private function clickHandler(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			group.selectByItem(btn);
		}
		private var detailView:InfomationView;
		private var travelView:TravelListView;
		private var currentBtn:CButton;
		private function selectChangeHandler(event:Event):void
		{
			var btn:CButton = group.getCurrentObj() as CButton;
			if(currentBtn == btn)
			{
				return;
			}
			currentBtn = btn;
			if ( currentBtn.data == "youji")
			{
				if(!travelView)
				{
					travelView = new TravelListView(noteArr);
					travelView.addEventListener(Event.REMOVED_FROM_STAGE,clearTravelView);
					detailSprite.addChild(travelView);
				}
				travelView.reset();
				travelView.visible = true;
				if(detailView)
				{
					detailView.visible = false;
				}
			}else{
				if (!detailView)
				{
					detailView = new InfomationView();
					detailSprite.addChild(detailView);
				}
				if(travelView)
				{
					travelView.visible = false;
					travelView.clear();
				}
				detailView.visible = true;
				detailView.infoMd = btn.data;
			}
			
		}
		private function clearTravelView(event:Event):void
		{
			if(travelView)
			{
				travelView = null;
			}
		}
	}
}