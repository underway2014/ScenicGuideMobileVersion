package spotViews
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CCScrollBar;
	import core.baseComponent.CImage;
	import core.baseComponent.CTextButton;
	import core.constant.Const;
	import core.layout.Group;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	
	import spotModes.SitesMd;
	import spotModes.VisitsMd;
	
	import spotPages.VisitRecomendDetailPage;
	
	public class VisitListView extends Sprite
	{
		public static const HIDEN_SELF:String = "hiden_self";
		public static const SHOW_SELF:String = "show_self";
		public static const LINE_CHANGE:String = "line_change";
		public var isHiden:Boolean = false;
		private var visitArray:Array;
		private var allLineSprite:Sprite;
		private var lineButtonSprite:Sprite;
		private var scroll:CCScrollBar;
		public function VisitListView(_arr:Array)
		{
			super();
			
			visitArray = _arr;
			allLineSprite = new Sprite();
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0xffffff);
			bg.graphics.drawRect(0,0,440,552);
			bg.graphics.endFill();
			addChild(bg);
			var barArray:Array = [SpotGuide.MAIN_PATH + "scroll_slider.png",SpotGuide.MAIN_PATH + "scroll_bg.png"];
			scroll = new CCScrollBar(420,552,barArray);
			this.addChild(scroll);
			scroll.target = allLineSprite;
			if(visitArray.length > 1)
			{
				lineButtonSprite = new Sprite();
				scroll.y = 47;
				addChild(lineButtonSprite);
				initChangeLineButton();
			}
			
//			addChild(allLineSprite);
			initContent();
			
			hidenBtn = new CButton([SpotGuide.MAIN_PATH + "show_allmap.png",SpotGuide.MAIN_PATH + "hiden_allmap.png"],false,true,true);
			hidenBtn.addEventListener(MouseEvent.CLICK,hidenChangeHandler);
			addChildAt(hidenBtn,0);
			hidenBtn.x = -39;
			hidenBtn.y = 215;
		}
		private var lineGroup:Group = new Group();
		private function initChangeLineButton():void
		{
			var lineButton:CTextButton;
			var cx:int = 0;
			var i:int = 0;
			var sepImg:CImage;
			for each(var vmd:VisitsMd in visitArray)
			{
				var bgArr:Array = new Array();
				if(visitArray.length == 2)
				{
					bgArr.push(SpotGuide.MAIN_PATH + "lineChange_up_1.png");
					bgArr.push(SpotGuide.MAIN_PATH + "lineChange_down_1.png");
				}else{
					bgArr.push(SpotGuide.MAIN_PATH + "lineChange_up_2.png");
					bgArr.push(SpotGuide.MAIN_PATH + "lineChange_down_2.png");
					
				}
				lineButton = new CTextButton(bgArr,false);
				lineButton.brotherNum = visitArray.length;
				lineButton.text = vmd.visitName;
				lineButtonSprite.addChild(lineButton);
				lineButton.x = cx;
				lineButton.data = i;
				cx += lineButton.width;
				lineGroup.add(lineButton);
				lineButton.addEventListener(MouseEvent.CLICK,lineButtonClickHandler);
				i++;
				if(i < visitArray.length)
				{
					sepImg = new CImage(1,47);
					sepImg.url = SpotGuide.MAIN_PATH + "lineChange_seprate.png";
					addChild(sepImg);
					sepImg.x = cx;
				}
			}
			lineGroup.selectById(0);
			lineGroup.addEventListener(Cevent.SELECT_CHANGE,lineChangeHandler);
		}
		private function lineChangeHandler(event:Event):void
		{
			scroll.reset();
			var dataEv:DataEvent = new DataEvent(DataEvent.CLICK);
			dataEv.data = lineGroup.getCurrentId();
			dispatchEvent(dataEv);
			showLineById(lineGroup.getCurrentId());
		}
		private var currentId:int = 0;
		private function showLineById(_id:int):void
		{
			var o:DisplayObject = linesArray[currentId];
			o.visible = false;
			currentId = _id;
			var oo:DisplayObject = linesArray[currentId];
			oo.visible = true;
		}
		private var curretnButton:CTextButton;
		private function lineButtonClickHandler(event:MouseEvent):void
		{
			var currentTxtButton:CTextButton = event.currentTarget as CTextButton;
			if(curretnButton == currentTxtButton)
			{
				return;
			}
			curretnButton = currentTxtButton;
			lineGroup.selectByItem(curretnButton);
		}
		private var hidenBtn:CButton;
		public function hidenVisitListView():void
		{
			hidenBtn.select(true);
			hidenChangeHandler(null);
		}
		public function showVistiListView():void
		{
			if(visitArray.length > 1)
			{
				lineGroup.selectById(0);
				curretnButton = lineGroup.getCurrentObj() as CTextButton;
			}
			currentId = 0;
			hidenBtn.select(false);
			allLineSprite.y = 0;
			if(isHiden)
			hidenChangeHandler(null);
		}
		private function hidenChangeHandler(event:MouseEvent):void
		{
			if(!isHiden)
			{
				dispatchEvent(new Event(HIDEN_SELF));
			}else{
				dispatchEvent(new Event(SHOW_SELF));
			}
		}
		private var CELL_SPACE:int = 25;
		private var CELL_X:int = 80;
		private var linesArray:Array;//存放ALL 线路
		
		private var lineLength:int = 10;
		private var textHeight:int = 36;
		private var imageHeight:int = 61;
		private function initContent():void
		{
			var lineSprite:Sprite;
			var i:int = 0;
			var j:int = 0;
			linesArray = new Array();
			for each(var vmd:VisitsMd in visitArray)
			{
				lineSprite = new Sprite();
				allLineSprite.addChild(lineSprite);
				linesArray.push(lineSprite);
				i = 0;
				if(j > 0)
				{
					lineSprite.visible = false;//z只显示第一条线路
				}
				var currentY:int = 0;
				var rcImage:CImage = new CImage(348,22,true,false);
				rcImage.url = SpotGuide.MAIN_PATH + "routeGuide_recomend.png";
				rcImage.x = 50;
				rcImage.y = 30;
				lineSprite.addChild(rcImage);
				currentY += (30 +rcImage.height + CELL_SPACE);
				var cell:RouteRecomendCellView;
				var numImage:CImage;
				var disLine:Shape;
				var disTxt:TextField;
				for each(var smd:SitesMd in vmd.visitSitsArray)
				{
					i++;
					numImage = new CImage(52,imageHeight,true,false);//79
					numImage.url = SpotGuide.MAIN_PATH + "visits/" + i + ".png";
					numImage.x = 15;
					lineSprite.addChild(numImage);
					
					cell = new RouteRecomendCellView(smd,Const.colorArray[i - 1]);
					lineSprite.addChild(cell);
					cell.y = currentY;
					numImage.y = currentY - 10;
					cell.x = CELL_X;
					currentY = (101 + CELL_SPACE) + currentY;
					cell.data = smd;
					cell.addEventListener(MouseEvent.CLICK,cellClickHandler);
					
					if(i < vmd.visitSitsArray.length)
					{
						disLine = new Shape();
						disLine.graphics.lineStyle(2,Const.colorArray[i - 1]);
						disLine.graphics.moveTo(numImage.x + 26,numImage.y + imageHeight - 8);
						disLine.graphics.lineTo(numImage.x + 26,numImage.y + imageHeight + lineLength);
						disLine.graphics.moveTo(numImage.x + 26,numImage.y + imageHeight + lineLength + textHeight + 10);
						disLine.graphics.lineTo(numImage.x + 26,numImage.y + imageHeight + lineLength + textHeight + 50);
						lineSprite.addChild(disLine);
						
						var tformat:TextFormat = new TextFormat(null,12,Const.colorArray[i - 1],true,null,null,null,null,TextFormatAlign.CENTER);
						disTxt = new TextField();
						disTxt.width = textHeight + 6;
						disTxt.mouseEnabled = false;
						disTxt.selectable = false;
						disTxt.text = smd.siteDistance;
						disTxt.setTextFormat(tformat);
						disTxt.x = numImage.x + 26 + 6;
						disTxt.y = numImage.y + imageHeight + lineLength + 2;
						lineSprite.addChild(disTxt);
						disTxt.rotationZ = 90;
					}
				}
//				currentY = (101 + CELL_SPACE) + currentY;
				if(vmd.visitOtherSitesArray.length)
				{
					var otImage:CImage = new CImage(348,22,true,false);
					otImage.url = SpotGuide.MAIN_PATH + "routeGuide_other.png";
					otImage.x = 50;
					otImage.y = currentY;
					currentY += otImage.height + CELL_SPACE;
					lineSprite.addChild(otImage);
//					i = 0;
					for each(var omd:SitesMd in vmd.visitOtherSitesArray)
					{
						i++;
						numImage = new CImage(52,imageHeight,true,false);//79
						numImage.url = SpotGuide.MAIN_PATH + "otherStates/other_state_" + i + ".png";
						numImage.x = 15;
						lineSprite.addChild(numImage);
						
						cell = new RouteRecomendCellView(omd,0XD3D3D3);
//						cell = new RouteRecomendCellView(omd,Const.otherColor);
//						cell = new RouteRecomendCellView(omd,Const.colorArray[(i - 1) % 20]);
						lineSprite.addChild(cell);
						cell.y = currentY;
						numImage.y = currentY - 10;
						cell.x = CELL_X;
						currentY = (101 + CELL_SPACE) + currentY;
						cell.data = omd;
						cell.addEventListener(MouseEvent.CLICK,cellClickHandler);
					}
				}
				j++;
			}
		}
		private var detailPage:VisitRecomendDetailPage;
		private function cellClickHandler(event:MouseEvent):void
		{
			var cellT:RouteRecomendCellView = event.currentTarget as RouteRecomendCellView;
			detailPage = new VisitRecomendDetailPage(cellT.data);
			detailPage.addEventListener(Event.REMOVED_FROM_STAGE,setDetailNullHandler);
			if(this.parent)
			{
				this.parent.addChild(detailPage);
			}
		}
		private function setDetailNullHandler(event:Event):void
		{
			detailPage = null;
		}
	}
}