package spotPages
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Json.ParseJSON;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.CStateImage;
	import core.constant.Const;
	import core.layout.Group;
	import core.loadEvents.CLoaderMany;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	import core.tween.TweenLite;
	
	import spotModes.PointMd;
	import spotModes.RouteMd;
	import spotModes.SpotMd;
	
	import spotViews.AudioPointView;
	import spotViews.VisitListView;
	
	public class RouteSpotGuidePage extends Sprite
	{
		private var jsonData:ParseJSON;
		private var mapContain:Sprite;
		private var greyContain:Sprite;
		private var statesContain:Sprite;
		private var greyStateContain:Sprite;
		private var colorContain:Sprite;
		private var routeSprite:Sprite;
		private var buttonSprite:Sprite;
		private var pointSpite:Sprite;
		
		private var lineObjArray:Array;
		private var currentLineObj:DisplayObject;
		
		private var routeDataArr:Array;
		private var visitDataArray:Array;
		
		private var alphaMask:Sprite;
//		private var colorArray:Array = [0xed4f11,0xf27e18,0xefc814,0xbadc0a,0x0cd115,0x10b7d6,0x1173c7,0x021cda,0x6120e6,0x8a01e2,0xfb02e1,0xe63862,0xe74a0e,0xf37f1b,0xe9c313,0xb2d108,0xcca14];//17
//		private var otherColor:int = 0x4e0cd5;
		public function RouteSpotGuidePage(_json:ParseJSON)
		{
			super();
			this.graphics.beginFill(0);
			this.graphics.drawRect(0,0,1080,608);
			this.graphics.endFill();
			
			jsonData = _json;
			
			routeDataArr = jsonData.getRouteData();
			visitDataArray = jsonData.getVisitsData();
			
			mapContain = new Sprite();
			addChild(mapContain);
			alphaMask = new Sprite();
			alphaMask.graphics.beginFill(0xaacc00,0);
			alphaMask.graphics.drawRect(0,0,1080,608);
			alphaMask.graphics.endFill();
			addChild(alphaMask);
			alphaMask.visible = false;
			
			buttonSprite = new Sprite();
			buttonSprite.x = 50 + 40;
			buttonSprite.y = 32;
			addChild(buttonSprite);
			greyContain = new Sprite();
			colorContain = new Sprite();
			statesContain = new Sprite();
			greyStateContain = new Sprite();
			pointViewContain = new Sprite();
			mapContain.addChild(colorContain);
			mapContain.addChild(greyContain);
			mapContain.addChild(greyStateContain);
			mapContain.addChild(pointViewContain);
			mapContain.addChild(statesContain);
			
//			this.addEventListener(MouseEvent.MOUSE_DOWN,startDragHandler);
//			this.addEventListener(MouseEvent.MOUSE_UP,stopDragHandler);
//			this.addEventListener(MouseEvent.MOUSE_OUT,stopDragHandler);
			mapContain.addEventListener(MouseEvent.MOUSE_DOWN,startDragHandler);
			mapContain.addEventListener(MouseEvent.MOUSE_UP,stopDragHandler);
//			mapContain.addEventListener(MouseEvent.MOUSE_OUT,stopDragHandler);
			
			routeSprite = new Sprite();
			addChild(routeSprite);
			routeSprite.x = 680;
			routeSprite.y = 56;
			
			headSprite = new Sprite();
			addChild(headSprite);
			var titleImage:CImage = new CImage(1080,62,true,false);
			titleImage.url = SpotGuide.MAIN_PATH + "routeGuide_title.png";
			headSprite.addChild(titleImage);
			
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
			
			
			
			initMap();
			initLine();
			initChnageMapButton();
			initZoomButton();
			initRightList();
		}
		private var headSprite:Sprite;
		private var zoomButton:CButton;
		private function initZoomButton():void
		{
			zoomButton = new CButton([SpotGuide.MAIN_PATH + "mapZoom_up.png",SpotGuide.MAIN_PATH + "mapZoom_down.png"],false,true,true);
			zoomButton.y = 608 - 73;
			zoomButton.x = 1080 - 197;
			addChild(zoomButton);
			zoomButton.addEventListener(MouseEvent.CLICK,zoomMapHandler);
		}
		private var scale:Number = 0;
		private var widthIsBig:Boolean;
		private var bigWH:Point = new Point();;
		private var beginXY:Point = new Point();;
		private function cuputSamllXY():void
		{
			bigWH.x = greyContain.width;
			bigWH.y = greyContain.height;
			beginXY.x = mapContain.x;
			beginXY.y = mapContain.y;
			
			
			if(bigWH.x / bigWH.y > 1080 / 608)
			{
				scale = 1080. / bigWH.x;
				widthIsBig = true;
			}else{
				scale = 608. / bigWH.y;
				widthIsBig = false;
			}
				
		}
		private var isBig:Boolean = true;
		private function zoomMapHandler(event:MouseEvent):void
		{
			cuputSamllXY();
			mapContain.x = 0;
			mapContain.y = 0;
			zoomButton.mouseEnabled = zoomButton.mouseChildren = false;
			if(isBig)
			{
				greyContain.scaleX = colorContain.scaleX = colorContain.scaleY = greyContain.scaleY = scale;
				greyStateContain.scaleX = greyStateContain.scaleY = statesContain.scaleX = statesContain.scaleY = scale;
				if(widthIsBig)
				{
					greyStateContain.x = greyContain.x = colorContain.x = statesContain.x = pointViewContain.x = 0;
					greyStateContain.y = greyContain.y = colorContain.y = statesContain.y = pointViewContain.y = (608 - greyContain.height) / 2;
//					greyContain.x = colorContain.x = statesContain.x = -beginXY.x;
//					greyContain.y = colorContain.y = statesContain.y = (bigWH.y - greyContain.height) / 2 - beginXY.y;
					
				}else{
					
					greyStateContain.x = greyContain.x = colorContain.x = statesContain.x = pointViewContain.x = (1080 - greyContain.width) / 2;
					greyStateContain.y = greyContain.y = colorContain.y = statesContain.y = pointViewContain.y = 0;
//					greyContain.x = colorContain.x = statesContain.x = (bigWH.x - greyContain.width) / 2 - beginXY.x;
//					greyContain.y = colorContain.y = statesContain.y = beginXY.y;
				}
				
				isBig = false;
				zoomButton.mouseEnabled = zoomButton.mouseChildren = true;
			}else{
				greyContain.scaleX = colorContain.scaleX = colorContain.scaleY = greyContain.scaleY = 1;
				greyStateContain.scaleX = greyStateContain.scaleY = statesContain.scaleX = statesContain.scaleY = 1;
				isBig = true;
				centerPointToMapcontain();
			}
		}
		private var rightListView:VisitListView;
		private function initRightList():void
		{
			rightListView = new VisitListView(jsonData.getVisitsData());
			rightListView.addEventListener(VisitListView.HIDEN_SELF,hidenSelfHandler);
			rightListView.addEventListener(VisitListView.SHOW_SELF,showSelfHandler);
			rightListView.addEventListener(DataEvent.CLICK,changeLineHandler);
			rightListView.y = 56;
			addChild(rightListView);
			rightListView.x = 650;
		}
		private function changeLineHandler(event:DataEvent):void
		{
			trace(event.data);
			showLineState(event.data);
		}
		private function showLine(_num:int):void
		{
			var obj:DisplayObject = lineObjArray[_num];
			obj.visible = true;
		}
		private function hidenSelfHandler(event:Event):void
		{
			rightListView.isHiden = true;
			headSprite.visible = false;
			TweenLite.to(rightListView,.4,{x:1080});
		}
		private function showSelfHandler(event:Event):void
		{
			showGreyMapHandler(null);
			headSprite.visible = true;
			rightListView.isHiden = false;
			TweenLite.to(rightListView,.4,{x:640});
			rightListView.visible = true;
		}
		
		private function backHomeHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(SpotGuide.BACK_HOME,true));
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
				changeGroup.selectById(0);
				if(!isBig)
				{
					zoomMapHandler(null);
				}
//				showGreyMapHandler(null);
				rightListView.showVistiListView();
				if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME,autoRotationHandler);
			}
		}
		private function startDragHandler(event:MouseEvent):void
		{
			mouse_beginX = this.mouseX;
			mouse_beginY = this.mouseY;
			mapContain.startDrag(false);
			mapContain.startDrag(false,new Rectangle(1080 - mapContain.width,608 - mapContain.height,mapContain.width - 1080,mapContain.height - 608));
			
			if(!this.hasEventListener(Event.ENTER_FRAME))
			{
				this.addEventListener(Event.ENTER_FRAME,autoRotationHandler);
			}
//			mapContain.addEventListener(MouseEvent.MOUSE_MOVE,mapContainMovehandler);
		}
		private var mouse_beginX:int = 0;
		private var mouse_beginY:int = 0;
		private var standar_dis:int = 10;
		private var hasAddMove:Boolean;//是否已经注册MOVE事件
		private function autoRotationHandler(event:Event):void
		{
			if(!hasAddMove && Math.sqrt((this.mouseX - mouse_beginX)*(this.mouseX - mouse_beginX) + (this.mouseY - mouse_beginY)*(this.mouseY - mouse_beginY)) >= standar_dis)
			{
				mapContain.addEventListener(MouseEvent.MOUSE_MOVE,mapContainMovehandler);
				hasAddMove = true;
				trace("add move event");
			}
			if(pointView)
			{
				var angel:Number = cuputAngle();
				pointView.rotationZ = angel;
				pointView.autoRotation(-angel);
				var np:Point = pointView.parent.localToGlobal(new Point(pointView.x,pointView.y));
				trace("np.x.y = " + np.x,np.y);
//				if(np.x <= 0||np.y >= 1730||np.x >= 1080||np.y <= 1122)
				if(np.x <= 0||np.y >= 608||np.x >= 1080||np.y <= 0)
				{
					showGreyMapHandler(null);
				}
			}
		}
		private function mapContainMovehandler(event:MouseEvent):void
		{
//			if( Math.sqrt((this.mouseX - mouse_beginX)*(this.mouseX - mouse_beginX) + (this.mouseY - mouse_beginY)*(this.mouseY - mouse_beginY)) < standar_dis)
//			{
//				trace("this is click event..");
//				return;
//			}
			
			alphaMask.addEventListener(MouseEvent.MOUSE_UP,stopDragHandler);
			alphaMask.addEventListener(MouseEvent.MOUSE_OUT,stopDragHandler);
			alphaMask.visible = true;
			blackMaskShape.mouseEnabled = statesContain.mouseChildren = statesContain.mouseEnabled = false;
			
			trace("mouse is moving..");
			
		}
		private function stopDragHandler(event:MouseEvent):void
		{
			alphaMask.visible = false;
			mapContain.stopDrag();
			if(hasAddMove)
			{
				alphaMask.removeEventListener(MouseEvent.MOUSE_UP,stopDragHandler);
				alphaMask.removeEventListener(MouseEvent.MOUSE_OUT,stopDragHandler);
			}
			mapContain.removeEventListener(MouseEvent.MOUSE_MOVE,mapContainMovehandler);
			this.removeEventListener(Event.ENTER_FRAME,autoRotationHandler);
			blackMaskShape.mouseEnabled = statesContain.mouseChildren = statesContain.mouseEnabled = true;
			hasAddMove = false;
		}
		private var spotMd:SpotMd;
		private function initMap():void
		{
			spotMd = jsonData.getSpotAllInfoData();
			var greyLoader:CLoaderMany = new CLoaderMany();
			greyLoader.load([SpotGuide.JSON_NAME + spotMd.spotGrayMap,SpotGuide.JSON_NAME + spotMd.spotColorMap]);
			greyLoader.addEventListener(CLoaderMany.LOADE_COMPLETE,greyMapOkHandler);
		}
		
		private function initLine():void
		{
			
			lineObjArray = new Array();
			var arr:Array = new Array();
			for each(var rdMd:RouteMd in routeDataArr)
			{
				arr.push(SpotGuide.JSON_NAME + rdMd.routeIcon)
			}
			var linesLoader:CLoaderMany = new CLoaderMany();
			linesLoader.load(arr);
			linesLoader.addEventListener(CLoaderMany.LOADE_COMPLETE,linesOkHandler);
		}
		private function linesOkHandler(event:Event):void
		{
			var linel:CLoaderMany = event.target as CLoaderMany;
			for each(var o:DisplayObject in linel._loaderContent)
			{
				lineObjArray.push(o);
				greyContain.addChild(o);
				o.visible = false;
			}
			currentLineObj = lineObjArray[0];
			currentLineObj.visible = true;
			
			addBlackMask();
			
//			pointViewContain = new Sprite();
//			greyContain.addChild(pointViewContain);
//			greyContain.addChild(statesContain);//////避免被线路遮挡
			
			initState();
		}
		private var pointViewContain:Sprite;
		private var blackMaskShape:Sprite;
		private function addBlackMask():void
		{
			blackMaskShape = new Sprite();
			blackMaskShape.graphics.beginFill(0,.4);
			blackMaskShape.graphics.drawRect(0,0,greyContain.width,greyContain.height);
			blackMaskShape.graphics.endFill();
			greyContain.addChild(blackMaskShape);
			blackMaskShape.visible = false;
			blackMaskShape.addEventListener(MouseEvent.CLICK,showGreyMapHandler);
		}
		private function showGreyMapHandler(event:MouseEvent):void
		{
			blackMaskShape.visible = false;
			clearAudioPointView();
			showAllStateNumber();
		}
		private function clearAudioPointView():void
		{
			if(pointView)
			{
				zoomButton.visible = true;
				currentNumImage = null;
				pointView.clear();
				pointViewContain.removeChild(pointView);
//				mapContain.removeChild(pointView);
				pointView = null;
			}
		}
		private var stateObjArray:Array;
		private var greyStateObjArray:Array;
		
		private function initState():void
		{
		
			stateObjArray = new Array();
			greyStateObjArray = new Array();
			var stateImage:CStateImage;
			var greyImage:CImage;
			var i:int = 1;
			var rj:uint = 0;
			for each(var rdMd:RouteMd in routeDataArr)
			{
				i = 1;
				rj++;
				var isShow:Boolean = true;
				if(rj > 1)
				{
					isShow = false;
				}
				var arr:Array = new Array();
				var greyArr:Array = new Array();
				for each(var pmd:PointMd in rdMd.routePointArray)
				{
					stateImage = new CStateImage(52,79,false,false);
//					stateImage = new CImage(52,79,false,false);
					greyImage = new CImage(52,79,false,false);
					greyImage.url = SpotGuide.MAIN_PATH + "states/greyState_" + i + ".png";
					greyImage.visible = false;
					stateImage.visible = isShow;
					stateImage.url = SpotGuide.MAIN_PATH + "states/state_" + i +".png";
					greyImage.x = stateImage.x = pmd.pointPositin.x;
					greyImage.y = stateImage.y = pmd.pointPositin.y;
					pmd.pointIndex = i;
					stateImage.data = pmd;
					statesContain.addChild(stateImage);
					greyContain.addChild(greyImage);
					stateImage.addEventListener(MouseEvent.CLICK,showAudioHandler);
					arr.push(stateImage);
					greyArr.push(greyImage);
					if(i == 1)
					{
						numOnePoint = pmd.pointPositin;
					}
					i++;
				}
				
				for each(var opmd:PointMd in rdMd.routeOtherPointArray)
				{
//					stateImage = new CImage(49,49,false,false);
					stateImage = new CStateImage(49,49,false,false);
					stateImage.visible = isShow;
					stateImage.url = SpotGuide.MAIN_PATH + "otherStates/other_state_" + i +".png";
					greyImage = new CImage(49,49,false,false);
					greyImage.url = SpotGuide.MAIN_PATH + "otherStates/other_grey_" + i + ".png";
					greyImage.visible = false;
					greyImage.x = stateImage.x = opmd.pointPositin.x;
					greyImage.y = stateImage.y = opmd.pointPositin.y;
					opmd.pointIndex = 11;// othre state use same color
					stateImage.data = opmd;
					statesContain.addChild(stateImage);
					greyStateContain.addChild(greyImage);
					stateImage.addEventListener(MouseEvent.CLICK,showAudioHandler);
					arr.push(stateImage);
					greyArr.push(greyImage);
					i++;
				}
				stateObjArray.push(arr);
				greyStateObjArray.push(greyArr);
			}
			centerPointToMapcontain();
		}
		private var currentLineNumber:uint = 0;
		private function showLineState(_lineNum):void
		{
			if(currentLineNumber == _lineNum)
			{
				return;
			}
			var oldObj:DisplayObject = lineObjArray[currentLineNumber];
			oldObj.visible = false;
			var carr:Array = stateObjArray[currentLineNumber];
			hidenAllSatates(carr);
			currentLineNumber = _lineNum;
			showAllStateNumber();
			showLine(currentLineNumber);
		}
		private function hidenAllSatates(_arr:Array):void
		{
			for each(var oo:DisplayObject in _arr)
			{
				oo.visible = false;
			}
			for each(var go:DisplayObject in greyStateObjArray[currentLineNumber])
			{
				go.visible = false;
			}
		}
		private function hidenOtherStateNumber(_cc:CStateImage):void
		{
			var sa:Array = stateObjArray[currentLineNumber];
			var ga:Array = greyStateObjArray[currentLineNumber];
			var i:int = 0;
			for each(var co:CStateImage in sa)
			{
				if(co != _cc)
				{
					co.visible = false;
//					co.showGreySatate(true);
//					co.hidenNormal(false);
					var go:DisplayObject = ga[i];
					go.visible = true;
				}
				i++;
			}
		}
		private function showAllStateNumber():void
		{
			var _sa:Array = stateObjArray[currentLineNumber];
			var _ga:Array = greyStateObjArray[0];
			var j:int = 0;
			for each(var co:CStateImage in _sa)
			{
				co.visible = true;
//				co.showGreySatate(false);
//				co.hidenNormal(true);
				var _go:DisplayObject = _ga[j];
				_go.visible = false;
				j++;
			}
		}
		private function showAudioHandler(event:MouseEvent):void
		{
			if(!rightListView.isHiden)
			{
				rightListView.hidenVisitListView();
				
			}
			if(headSprite.visible)
			{
				headSprite.visible = false;
			}
			trace("show audio..");
			blackMaskShape.visible = true;
			var cimg:CStateImage = event.currentTarget as CStateImage;
			if(currentNumImage == cimg)
			{
				return;
			}
			currentNumImage = cimg;
			hidenOtherStateNumber(currentNumImage);
			
			var pd:PointMd = currentNumImage.data;
			var pt:Point = new Point(pd.pointPositin.x + currentNumImage.width / 2,pd.pointPositin.y + currentNumImage.height - 15);
			var angle:Number = cuputAngle();
				
			var colorIndex:int;
			if(pd.pointType)
			{
				colorIndex = Const.colorArray[10];// (11 -1) other state
			}else{
				colorIndex = Const.colorArray[pd.pointIndex - 1];//pd.pointType = 0
			}
			pointView = new AudioPointView(pd,colorIndex,-angle);
			if(isBig)
			{
				pointView.x = pt.x;
				pointView.y = pt.y;
			}else{
				pointView.x = pt.x * scale;
				pointView.y = pt.y * scale;
			}
			zoomButton.visible = false;
			pointView.rotationZ = angle;
			pointViewContain.addChild(pointView);
			
			var angel:Number = cuputAngle();
			pointView.rotationZ = angel;
			pointView.autoRotation(-angel);
			
//			mapContain.addChild(pointView);
		}
		private var currentNumImage:CStateImage;
		private function cuputAngle():Number
		{
			var pd:PointMd = currentNumImage.data;
			var pt:Point;
			if(isBig)
			{
				pt = new Point(pd.pointPositin.x + currentNumImage.width / 2,pd.pointPositin.y + currentNumImage.height - 15);
			}else{
				pt = new Point(pd.pointPositin.x * scale + currentNumImage.width / 2,pd.pointPositin.y * scale + currentNumImage.height - 15);
			}
			var np:Point = mapContain.localToGlobal(pt);
//			trace("localToGlobal = " ,np.x,np.y);
			
			var disX:Number = np.x - 540;//气泡所指向中心点坐标
			var disY:Number = np.y - 300;
//			var disY:Number = np.y - 1400;
			var xlong:Number = Math.sqrt(Math.pow(disX,2) + Math.pow(disY,2));
			var cos:Number = disX / xlong;
			var radian:Number = Math.acos(cos);
			var angle:Number = 180 / (Math.PI / radian);
			if(disY > 0)
			{
				angle = -angle;
			}else if((disY == 0) && (disX < 0)){
				angle = 180;
			}
//			trace("angel = " + angle);
			angle = 180 - angle;
			return angle;
		}
		private var numOnePoint:Point;
		public function centerPointToMapcontain():void
		{
			if(!numOnePoint)
			{
				return;
			}
			var nnp:Point = new Point(mapContain.width,mapContain.height);
//			var nnp:Point = mapContain.localToGlobal(new Point(mapContain.width,mapContain.height));
			var cp:Point = new Point(350,300);
//			var np:Point = mapContain.globalToLocal(cp);
			zoomButton.select(false);
			
			var disX:int = numOnePoint.x - cp.x;
			var disY:int = numOnePoint.y - cp.y;
			if(disX < 0)
			{
				disX = 0;
			}
			if(disY < 0)
			{
				disY = 0;
			}
			if(nnp.x - 1080 < disX )
			{
				disX = -(nnp.x - 1080);
			}else{
				disX *= -1;
			}
			if(nnp.y - 608 < disY)
			{
				disY = -(nnp.y - 608);
			}else{
				disY *= -1;
			}
			
			TweenLite.to(mapContain,.4,{x:disX,y:disY,onComplete:setZoomButton});
//			mapContain.x = disX;
//			mapContain.y = disY;
		}
		private function setZoomButton():void
		{
			zoomButton.mouseEnabled = zoomButton.mouseChildren = true;
		}
		private var pointView:AudioPointView;
		private function greyMapOkHandler(event:Event):void
		{
			var gl:CLoaderMany = event.target as CLoaderMany;
			greyContain.addChildAt(gl._loaderContent[0],0);
			colorContain.addChild(gl._loaderContent[1]);
			
		}
		private function initVisit():void
		{
			
		}
		private var changeGroup:Group;
		private function initChnageMapButton():void
		{
			changeGroup = new Group();
			var routeBtn:CButton = new CButton([SpotGuide.MAIN_PATH + "greyMap_up.png",SpotGuide.MAIN_PATH + "greyMap_down.png"]);
			routeBtn.data = "grey_map";
			routeBtn.addEventListener(MouseEvent.CLICK,mapWillChange);
			var colorBtn:CButton = new CButton([SpotGuide.MAIN_PATH + "colorMap_up.png",SpotGuide.MAIN_PATH + "colorMap_down.png"]);
			colorBtn.data = "color_map";
			colorBtn.addEventListener(MouseEvent.CLICK,mapWillChange);
			changeGroup.add(routeBtn);
			changeGroup.add(colorBtn);
			changeGroup.setItemSelected(0);
			changeGroup.addEventListener(Cevent.SELECT_CHANGE,changeMapHandler);
			buttonSprite.addChild(routeBtn);
			buttonSprite.addChild(colorBtn);
			colorBtn.x = 119;
			
		}
		private function mapWillChange(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			changeGroup.selectByItem(btn);
			
		}
		private function changeMapHandler(event:Event):void
		{
			var btn:CButton = changeGroup.getCurrentObj() as CButton;
			if(btn.data == "color_map")
			{
				colorContain.visible = true;
				greyContain.visible = false;
				statesContain.visible = false;
				greyStateContain.visible = false;
				showGreyMapHandler(null);
			}else{
				colorContain.visible = false;
				greyContain.visible = true;
				greyStateContain.visible = true;
				statesContain.visible = true;
			}
		}
		public function clear():void
		{
			if(pointView)
			{
				pointView.clear();
				pointView = null;
			}
		}
	}
}