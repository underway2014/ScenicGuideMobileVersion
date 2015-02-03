package spotPages
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.fontFormat.CFontFormat;
	import core.loadEvents.CLoader;
	import core.tween.TweenLite;
	
	import spotModes.PictureMd;
	
	import spotViews.PictureView;
	
	public class PicturesFlowPage extends Sprite
	{
		private var modeArray:Array;
		private var conetenSprite:Sprite;
		public function PicturesFlowPage(_array:Array)
		{
			super();
			
			modeArray = _array;
			var titleLoader:CLoader = new CLoader();
			titleLoader.load(SpotGuide.MAIN_PATH + "pictureFlow_title.png");
			titleLoader.addEventListener(CLoader.LOADE_COMPLETE,titleOkHandler);
			conetenSprite = new Sprite();
			conetenSprite.y = 56;
			addChild(conetenSprite);
			initContent();
			initButton();
		}
		private function titleOkHandler(event:Event):void
		{
			var tLoader:CLoader = event.target as CLoader;
			tLoader._loader.width = 1080;
			addChild(tLoader._loader);
			
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
//				this.parent.removeChild(this);
				this.visible = 0;
				resetSelf();
			}
		}
		private function resetSelf():void
		{
			conetenSprite.x = 0;
			leftButton.visible = false;
			rightButton.visible = true;
			currentPageIndex = 0;
			pageTxt.text = (currentPageIndex + 1) + " / " + modeArray.length;
			pageTxt.setTextFormat(pageFormat);
		}
		public function clear():void
		{
			while(conetenSprite.numChildren)
			{
				var co:DisplayObject = conetenSprite.removeChildAt(0);
				co = null;
			}
			conetenSprite = null;
		}
		private var loadTimer:Timer;
		private var thresholdValue:int;
		private function initContent():void
		{
			thresholdValue = 5;
			var beginNum:int;
			if (modeArray.length > thresholdValue)
			{
				beginNum = thresholdValue;
			}else{
				beginNum = modeArray.length;
			}
			var md:PictureMd;
			var picView:PictureView;
			for(var i:int = 0;i < beginNum;i++)
			{
				md = modeArray[i];
				picView = new PictureView(md);
				picView.x = i * 1080;
				conetenSprite.addChild(picView);
			}
			if(modeArray.length > thresholdValue)
			{
				loadTimer = new Timer(10);
				loadTimer.addEventListener(TimerEvent.TIMER,stepLoader);
				loadTimer.start();
			}
			
			pageFormat =  new TextFormat(null,20,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			var pageBg:Shape = new Shape();
			pageBg.graphics.beginFill(0,.5);
			pageBg.graphics.drawRoundRect(0,0,70,20,20,20);
			pageBg.graphics.endFill();
			addChild(pageBg);
			pageTxt = new TextField();
			pageTxt.width = 70;
			pageTxt.mouseEnabled = false;
			pageTxt.text = (currentPageIndex + 1) + " / " + modeArray.length;
			pageTxt.setTextFormat(pageFormat);
			addChild(pageTxt);
			pageBg.x = pageTxt.x = 510;
			pageBg.y = pageTxt.y = 550;
		}
		private var pageFormat:TextFormat;
		private var pageTxt:TextField;
		private function stepLoader(event:TimerEvent):void
		{
			var md:PictureMd;
			var picView:PictureView;
			var endIndex:int;
			thresholdValue += 5;
			if (thresholdValue > modeArray.length)
			{
				endIndex = modeArray.length;
				loadTimer.stop();
				loadTimer.removeEventListener(TimerEvent.TIMER,stepLoader);
			}else{
				endIndex = thresholdValue;
			}
			for(var m:int = thresholdValue - 5;m < modeArray.length;m++)
			{
				md = modeArray[m];
				picView = new PictureView(md);
				conetenSprite.addChild(picView);
				picView.x = m * 1080;
			}
		}
		private var leftButton:CButton;
		private var rightButton:CButton;
		private function initButton():void
		{
			leftButton = new CButton([SpotGuide.MAIN_PATH + "left_arrowUp.png",SpotGuide.MAIN_PATH + "left_arrowDown.png"],false);
			if(currentPageIndex == 0)
			{
				leftButton.visible = false;
			}
			this.addChild(leftButton);
			leftButton.x = 14;
			leftButton.y = 214 + 56;
			leftButton.addEventListener(MouseEvent.CLICK,leftHandler);
			
			rightButton = new CButton([SpotGuide.MAIN_PATH + "right_arrowUp.png",SpotGuide.MAIN_PATH + "right_arrowDown.png"],false);
			this.addChild(rightButton);
			rightButton.addEventListener(MouseEvent.CLICK,rightHandler);
			rightButton.y = 214 + 56;
			rightButton.x = 1080 - 122;
		}
		private var currentPageIndex:int;
		private function leftHandler(event:MouseEvent):void
		{
			if(!rightButton.visible)
			{
				rightButton.visible = true;
			}
			currentPageIndex--;
			leftButton.mouseEnabled = leftButton.mouseChildren = rightButton.mouseEnabled = rightButton.mouseChildren = false;
			TweenLite.to(conetenSprite,.5,{x:conetenSprite.x + 1080,onComplete:onFinishTween});
		}
		private function onFinishTween():void
		{
			if (conetenSprite.x >= 0)
			{
				conetenSprite.x = 0;
				leftButton.visible = false;
			}
			if (conetenSprite.x <= -(modeArray.length - 1) * 1080)
			{
				conetenSprite.x = -(modeArray.length - 1) * 1080;
				rightButton.visible = false;
			}
			leftButton.mouseEnabled = leftButton.mouseChildren = rightButton.mouseEnabled = rightButton.mouseChildren = true;
			pageTxt.text = (currentPageIndex + 1) + " / " + modeArray.length;
			pageTxt.setTextFormat(pageFormat);
		}
		private function rightHandler(event:MouseEvent):void
		{
			if(!leftButton.visible)
			{
				leftButton.visible = true;
			}
			currentPageIndex++;
			leftButton.mouseEnabled = leftButton.mouseChildren = rightButton.mouseEnabled = rightButton.mouseChildren = false;
			TweenLite.to(conetenSprite,.5,{x:conetenSprite.x - 1080,onComplete:onFinishTween});
		}
	}
}