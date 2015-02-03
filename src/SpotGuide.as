package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	
	import Json.ParseJSON;
	
	import core.admin.Administrator;
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.CRVideo;
	import core.cache.CacheData;
	import core.fontFormat.CFontFormat;
	import core.loadEvents.CLoaderMany;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	
	import spotModes.RecomendMd;
	import spotModes.SpotMd;
	import spotModes.VideoMd;
	
	import spotPages.InfomationPage;
	import spotPages.PicturesFlowPage;
	import spotPages.RecomendPage;
	import spotPages.RouteSpotGuidePage;
	
	
	[SWF(width="1080",height="608",frameRate="30")]
	public class SpotGuide extends Sprite
	{
		public static var JSON_NAME:String = "ynylxs";
		public static const MAIN_PATH:String = "source/spotSource/spotPublic/";
		private static const RECOMEND_TYPE:String = "recomend";
		private static const VIDEO_TYPE:String = "video";
		private static const INFO_TYPE:String = "info";
		private static const PICTURE_TYPE:String = "picture";
		
		public static const BACK_HOME:String = "close_mobileview";
		public function SpotGuide()
		{
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,0,1080,608);
			this.graphics.endFill();
			
			Administrator.instance.addEventListener(DataEvent.CLICK, ClickHandler);
			this.addEventListener(BACK_HOME,closeSelfHandler);
//			ClickHandler(null);
		}
		private function closeSelfHandler(event:Event):void
		{
			if(this.parent)
			{
				Administrator.instance.dispatchEvent(new Event(Cevent.CLEAR_DM_QGL));
			}
		}
		private function ClickHandler(event:DataEvent):void
		{
			Administrator.instance.removeEventListener(DataEvent.CLICK, ClickHandler);
//			JSON_NAME = "source/yunnan/mobileSource/shgz/";//source/yunnan/mobileSource/ynylxs   //ynjlcg
			JSON_NAME = "source/" + event.data + "/";//yunnan/mobileSource/ynylxs
			initData();
//			initUI();
		}
		private var picLoader:CLoaderMany;
		private function initUI():void
		{
			var picArray:Array = new Array();
			picArray.push(MAIN_PATH + "spot_home_shadow.png");
			picArray.push(MAIN_PATH + "guide_text.png");
//			picArray.push(MAIN_PATH + "enter_button.png");
			picLoader = new CLoaderMany();
			picLoader.load(picArray);
			picLoader.addEventListener(CLoaderMany.LOADE_COMPLETE,picLoadOkHandler);
			
		}
		private function picLoadOkHandler(event:Event):void
		{
			addChild(picLoader._loaderContent[0]);
			picLoader._loaderContent[0].x = 374 - picLoader._loaderContent[0].width;
			addChild(picLoader._loaderContent[1]);
			picLoader._loaderContent[1].x = 374 + 33;
			picLoader._loaderContent[1].y = 608 - 114;
			
			var enterButton:CButton = new CButton([MAIN_PATH + "enter_button.png",MAIN_PATH + "enter_button.png"],false);
			enterButton.addEventListener(MouseEvent.CLICK,enterHandler);
			enterButton.x = 1080 - 227;
			enterButton.y = 608 - 90;
			addChild(enterButton);
		}
		private var routeGuidePage:RouteSpotGuidePage;
		private function enterHandler(event:MouseEvent):void
		{
			if(!routeGuidePage)
			{
				routeGuidePage = new RouteSpotGuidePage(nameJson);
				routeGuidePage.addEventListener(Event.REMOVED_FROM_STAGE,clearRouteGuidePage);
				addChild(routeGuidePage);
			}else{
				routeGuidePage.visible = true;
				routeGuidePage.centerPointToMapcontain();
			}
			
		}
		private function clearRouteGuidePage(event:Event):void
		{
			if(routeGuidePage)
			{
				routeGuidePage.clear();
				routeGuidePage = null;
			}
		}
		private function initData():void
		{
			var cacheData:* = CacheData.getDataByName("scjzg");
			if(!cacheData)
			{
				
			}
			
			var arr:Array = (JSON_NAME.split("/"));
			dynamicJson = new ParseJSON(JSON_NAME + "guide_more.json",1);
			dynamicJson.addEventListener(ParseJSON.LOAD_COMPLETE_INFO,infoJsonOkHandler);
			
			trace(arr.length,arr[arr.length - 2]);
			
			
		}
		private var dynamicJson:ParseJSON;
		private var nameJson:ParseJSON;
		private function nameJsonOkHandler(event:Event):void
		{
//			var arr:Array = nameJson.getPictureData();
//			for each(var picMd:PictureMd in arr)
//			{
//				trace("dsc = " + picMd.descText +  "path = " + picMd.pathUrl);
//			}
			initButton();
			initHomeMap();
			initMainSpot();
			
			initUI();
		}
		private function initMainSpot():void
		{
			var txtSpace:int = 10;
			var txtDown:int = 4;
			
			var beginX:int = 374 + 33;
			var beginY:int = 608 - 75;
			var nameArr:Array = nameJson.getAllSoptsName();
			
			var totalNum:TextField = new TextField();
			totalNum.mouseEnabled = false;
			totalNum.text = "共" + nameArr.length + "景点";
			totalNum.setTextFormat(CFontFormat.formatHomeGuideSpotName);
			totalNum.y = 608 - 40;
			totalNum.x = 374 + 33;
			addChild(totalNum);
			
			var oneImage:CImage = new CImage(22,27,true,false);
			oneImage.x = beginX;
			oneImage.y = beginY;
			oneImage.url = MAIN_PATH + "number_1.png";//853
			var oneTxt:TextField = new TextField();
			oneTxt.mouseEnabled = false;
			oneTxt.text = nameArr[0];
			oneTxt.setTextFormat(CFontFormat.formatHomeGuideSpotName);
			oneTxt.width = (oneTxt.textWidth + txtSpace);
			beginX += oneImage.width;
			oneTxt.x = beginX;
			oneTxt.y = beginY + txtDown;
			addChild(oneTxt);
			addChild(oneImage);
			beginX += oneTxt.width;
			
			if(nameArr.length < 2)
			{
				return;
			}
			
			var twoImage:CImage = new CImage(22,27,true,false);
			twoImage.url = MAIN_PATH + "number_2.png";
			twoImage.x = beginX;
			twoImage.y = beginY;
			addChild(twoImage);
			beginX += (twoImage.width);
			var twoTxt:TextField = new TextField();
			twoTxt.text = nameArr[1];
			twoTxt.mouseEnabled = false;
			twoTxt.setTextFormat(CFontFormat.formatHomeGuideSpotName);
			twoTxt.width = twoTxt.textWidth + txtSpace;
			twoTxt.x = beginX;
			twoTxt.y = beginY + txtDown;
			beginX += twoTxt.width;
			addChild(twoTxt);
			
			var threeImage:CImage = new CImage(22,27,true,false);
			threeImage.url = MAIN_PATH + "number_3.png";
			threeImage.x = beginX;
			threeImage.y = beginY;
			
			beginX += threeImage.width;
			
			if(nameArr.length < 3)
			{
				return;
			}
			
			var threeTxt:TextField = new TextField();
			threeTxt.text = nameArr[2] + "...";
			threeTxt.mouseEnabled = false;
			threeTxt.setTextFormat(CFontFormat.formatHomeGuideSpotName);
			threeTxt.x = beginX;
			threeTxt.y = beginY + txtDown;
			threeTxt.width = threeTxt.textWidth + txtSpace;
			beginX += threeTxt.width;
			
			if(beginX < 853 - txtSpace)
			{
				addChild(threeImage);
				addChild(threeTxt);
			}
			
			
		}
		private function initHomeMap():void
		{
			var spotMd:SpotMd = nameJson.getSpotAllInfoData();
			var mapImage:CImage = new CImage(706,386,false);
			mapImage.url = JSON_NAME + spotMd.spotIcon;
			addChild(mapImage);
			mapImage.x = 374;
			mapImage.y = 80;
			mapImage.addEventListener(MouseEvent.CLICK,enterHandler);
			
//			var mapImage:CutImage = new CutImage(640,350,new Point(0,240));
//			mapImage.url = JSON_NAME + spotMd.spotIcon;
//			mapImage.x = 374;
//			mapImage.y = 80 - 260;
//			addChild(mapImage);
//			var allFonts:Array = Font.enumerateFonts(true);
//			allFonts.sortOn("fontName", Array.CASEINSENSITIVE);
//			for (var i:uint=0; i<allFonts.length; i++) {
//				trace(allFonts[i].fontName);
//			}
			var spoteName:TextField = new TextField();
			spoteName.y = 20;
			spoteName.height = 50;
			spoteName.mouseEnabled = false;
			spoteName.text = spotMd.spotName;
			spoteName.antiAliasType = AntiAliasType.ADVANCED;
			spoteName.setTextFormat(CFontFormat.formatSpotName);
			spoteName.width = 706;
			addChild(spoteName);
			spoteName.x = 374;
			
			var closeButton:CButton = new CButton([SpotGuide.MAIN_PATH + "back_home_up.png",SpotGuide.MAIN_PATH + "back_home_down.png"],false);
			closeButton.addEventListener(MouseEvent.CLICK,closeSpotGuidHandler);
			addChild(closeButton);
			closeButton.x = 1080 - 111;
//			closeButton.y = 14;
		}
		private function closeSpotGuidHandler(event:MouseEvent):void
		{
			closeSelfHandler(null);
		}
		private function infoJsonOkHandler(event:Event):void
		{
			var recomendArr:Array = dynamicJson.getRecomendData();
			for each(var remd:RecomendMd in recomendArr)
			{
//				trace("recomendTitle = "+ remd.recomendTitle,"& recomendAddress = " + remd.recomendAddress,"& recomendPhone = " + remd.recomendPhone + "***");
			}
			var arr:Array = (JSON_NAME.split("/"));
			nameJson = new ParseJSON(JSON_NAME + arr[arr.length - 2] + ".json",0);
			nameJson.addEventListener(ParseJSON.LOAD_COMPLETE_MAP,nameJsonOkHandler);
		}
		private function initButton():void
		{
			var videoArr:Array = nameJson.getVideosData();
			var videoGuide_button:CButton = new CButton([MAIN_PATH + "guide_video_up.png",MAIN_PATH + "guide_video_up.png"],false);
//			var videoGuide_button:CButton = new CButton([MAIN_PATH + "guide_video_up.png",MAIN_PATH + "guide_video_down.png"],false);
			videoGuide_button.addEventListener(MouseEvent.CLICK,showVideoHandler);
			videoGuide_button.x = videoGuide_button.y = 0;
			videoGuide_button.data = videoArr[0];
			
//			var videoImpress_button:CButton = new CButton([MAIN_PATH + "impress_video_up.png",MAIN_PATH + "impress_video_down.png"],false);
			var recomentSkinArr:Array = [MAIN_PATH + "recomend_up.png",MAIN_PATH + "recomend_up.png"];
			if(videoArr.length>1)
			{
				var videoImpress_button:CButton = new CButton([MAIN_PATH + "impress_video_up.png",MAIN_PATH + "impress_video_up.png"],false);
				videoImpress_button.addEventListener(MouseEvent.CLICK,showVideoHandler);
				videoImpress_button.x = 0;
				videoImpress_button.y = 206 + 12;
				videoImpress_button.data = videoArr[1];
				addChild(videoImpress_button);
			}else{
				recomentSkinArr = [MAIN_PATH + "recomend_up_big.png",MAIN_PATH + "recomend_down_big.png"];
				
			}
			
			var recomend_button:CButton = new CButton(recomentSkinArr,false);
//			var recomend_button:CButton = new CButton([MAIN_PATH + "recomend_up.png",MAIN_PATH + "recomend_down.png"],false);
			recomend_button.addEventListener(MouseEvent.CLICK,recomendHandler);
			if(videoArr.length>1)
			{
				recomend_button.x = 190;
				recomend_button.y = 206 + 12;
			}else{
				recomend_button.x = 0;
				recomend_button.y = 206 + 12;
			}
			
			recomend_button.data = "recomend";
			
			var pic_button:CButton = new CButton([MAIN_PATH + "pictures_up.png",MAIN_PATH + "pictures_up.png"],false);
//			var pic_button:CButton = new CButton([MAIN_PATH + "pictures_up.png",MAIN_PATH + "pictures_down.png"],false);
			pic_button.addEventListener(MouseEvent.CLICK,pictureHandler);
			pic_button.x = 0;
			pic_button.y = 419;
			pic_button.data = "recomend";
			
			var info_button:CButton = new CButton([MAIN_PATH + "info_up.png",MAIN_PATH + "info_up.png"],false);
//			var info_button:CButton = new CButton([MAIN_PATH + "info_up.png",MAIN_PATH + "info_down.png"],false);
			info_button.addEventListener(MouseEvent.CLICK,infomationHandler);
			info_button.x = 209;
			info_button.y = 419;
			info_button.data = "info";
			
			addChild(videoGuide_button);
			
			addChild(recomend_button);
			addChild(info_button);
			addChild(pic_button);
		}
		private var videoWindow:CRVideo;
		private function showVideoHandler(event:MouseEvent):void
		{
			var targetButton:CButton = event.currentTarget as CButton;
			trace(targetButton.data);
			if(!targetButton.data)
			{
				return;
			}
			var videoMd:VideoMd = targetButton.data as VideoMd;
			if(!videoWindow)
			{
				videoWindow = new CRVideo();
				videoWindow.addEventListener(Event.REMOVED_FROM_STAGE,clearVideoHandler);
				videoWindow.addEventListener(CRVideo.VIDEO_PLAY_OVER,videoPlayOverHandler);
				videoWindow.closeButton = new CButton([SpotGuide.MAIN_PATH + "videoClose_up.png",SpotGuide.MAIN_PATH + "videoClose_down.png"],false);
				dispatchEvent(new Event("soundoff",true));
				addChild(videoWindow);
			}else{
//				videoWindow.visible = true;
				addChild(videoWindow);
			}
			videoWindow.url = SpotGuide.JSON_NAME + videoMd.videoUrl;
		}
		private function videoPlayOverHandler(event:Event):void
		{
			removeChild(videoWindow);
		}
		private var recomendPage:RecomendPage;
		private function recomendHandler(event:MouseEvent):void
		{
			if(recomendPage)
			{
				recomendPage.visible = true;
			}else{
				recomendPage = new RecomendPage(dynamicJson.getRecomendData());
				recomendPage.addEventListener(Event.REMOVED_FROM_STAGE,clearRecomendPage);
				addChild(recomendPage);
			}
		}
		private function clearRecomendPage(event:Event):void
		{
			if(recomendPage)
			{
				recomendPage = null;
			}
		}
		private var picPage:PicturesFlowPage;
		private function pictureHandler(event:MouseEvent):void
		{
			var arr:Array = nameJson.getPictureData();
			if (!arr.length)
			{
				return;
			}
			if(picPage)
			{
				picPage.visible = true;
			}else{
				picPage = new PicturesFlowPage(nameJson.getPictureData());
				picPage.addEventListener(Event.REMOVED_FROM_STAGE,clearPicPage);
				addChild(picPage);
			}
		}
		private function clearPicPage(event:Event):void
		{
			if(picPage)
			{
				picPage = null;
			}
		}
		private var infoPage:InfomationPage;
		private function infomationHandler(event:MouseEvent):void
		{
			var arr:Array = nameJson.getNoteData();
			var inarr:Array = dynamicJson.getInfoData();
			if (!inarr.length)
			{
				return;
			}
			if(infoPage)
			{
				infoPage.visible = true;
			}else{
				infoPage = new InfomationPage(inarr,arr);
				infoPage.addEventListener(Event.REMOVED_FROM_STAGE,clearInfoPage);
				addChild(infoPage);
			}
		}
		private function clearInfoPage(event:Event):void
		{
			infoPage = null;
		}
		private function clearVideoHandler(event:Event):void
		{
			dispatchEvent(new Event("soundon",true));
			videoWindow.close();
			videoWindow = null;
		}
	}
}