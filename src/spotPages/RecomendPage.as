package spotPages
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.fontFormat.CFontFormat;
	import core.loadEvents.CLoader;
	import core.tween.TweenLite;
	
	import spotModes.RecomendMd;
	
	import spotViews.RecomendView;
	
	public class RecomendPage extends Sprite
	{
		private var modeArray:Array;
		private var contentSprite:Sprite;
		private static const SINGLE_VIEW_WIDTH:int = 910;
		public function RecomendPage(_arr:Array)
		{
			super();
			this.graphics.beginFill(0);
			this.graphics.drawRect(0,0,1080,608);
			this.graphics.endFill();
			
			modeArray = _arr;
			var bgImg:CImage = new CImage(1080,608,false);
			bgImg.url =SpotGuide.MAIN_PATH + "recomend_background.png";
			addChild(bgImg);
			
			var titleLoader:CLoader = new CLoader();
			titleLoader.load(SpotGuide.MAIN_PATH + "recomend_title.png");
			titleLoader.addEventListener(CLoader.LOADE_COMPLETE,titleOkHandler);
			contentSprite = new Sprite();
			addChild(contentSprite);
			contentSprite.y = 56 + 37;
			
			pageTxt = new TextField();
			pageTxt.width = 70;
			pageTxt.mouseEnabled = false;
			pageTxt.text = (currentPage + 1) + " / " + modeArray.length;
			pageTxt.setTextFormat(CFontFormat.formatPageText);
			var pageBg:Shape = new Shape();
			pageBg.graphics.beginFill(0xffffff,.7);
			pageBg.graphics.drawRoundRect(0,0,70,20,20,20);
			pageBg.graphics.endFill();
			addChild(pageBg);
			addChild(pageTxt);
			pageBg.x = pageTxt.x = 510;
			pageBg.y = 565;
			pageTxt.y =564;
			
			initContent();
			initButton();
		}
		private var pageTxt:TextField;
		private function setPageTxt():void
		{
			pageTxt.text = (currentPage + 1) + " / " + modeArray.length;
			pageTxt.setTextFormat(CFontFormat.formatPageText);
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
				this.visible = false;
			}
//			leftButton.visible = false;
			contentSprite.x = 0;
			currentPage = 0;
			onFinishTween();
//			rightButton.visible = true;
		}
		private function initContent():void
		{
			var reView:RecomendView;
			var i:int = 0;
			for each(var md:RecomendMd in modeArray)
			{
				reView = new RecomendView(md);
				reView.y = 230;
				contentSprite.addChild(reView);
				reView.x = (1080 - SINGLE_VIEW_WIDTH) / 2 + i * SINGLE_VIEW_WIDTH + SINGLE_VIEW_WIDTH / 2;
				i++;
			}
		}
		private var currentPage:int;
		private var leftButton:CButton;
		private var rightButton:CButton;
		private function initButton():void
		{
			leftButton = new CButton([SpotGuide.MAIN_PATH + "left_arrowUp.png",SpotGuide.MAIN_PATH + "left_arrowDown.png"],false);
			this.addChild(leftButton);
			leftButton.visible = false;
			leftButton.x = 33;
			leftButton.y = 244;
			leftButton.addEventListener(MouseEvent.CLICK,leftHandler);
			
			rightButton = new CButton([SpotGuide.MAIN_PATH + "right_arrowUp.png",SpotGuide.MAIN_PATH + "right_arrowDown.png"],false);
			this.addChild(rightButton);
			rightButton.addEventListener(MouseEvent.CLICK,rightHandler);
			rightButton.y = 244;
			rightButton.x = 1080 - 141;
		}
		private function leftHandler(event:MouseEvent):void
		{
			if(!rightButton.visible)
			{
				rightButton.visible = true;
			}
			currentPage--;
			leftButton.mouseEnabled = leftButton.mouseChildren = rightButton.mouseEnabled = rightButton.mouseChildren = false;
			TweenLite.to(contentSprite,.5,{x:contentSprite.x + SINGLE_VIEW_WIDTH,onComplete:onFinishTween});
		}
		private function rightHandler(event:MouseEvent):void
		{
			trace("click right.");
			if(!leftButton.visible)
			{
				leftButton.visible = true;
			}
			currentPage++;
			leftButton.mouseEnabled = leftButton.mouseChildren = rightButton.mouseEnabled = rightButton.mouseChildren = false;
			TweenLite.to(contentSprite,.5,{x:contentSprite.x - SINGLE_VIEW_WIDTH,onComplete:onFinishTween});
		}
		private function onFinishTween():void
		{
			
			if (contentSprite.x >= 0)
			{
				contentSprite.x = 0;
				leftButton.visible = false;
				rightButton.visible = true;
			}
			if (contentSprite.x <= -(modeArray.length - 1) * SINGLE_VIEW_WIDTH + (1080 - SINGLE_VIEW_WIDTH) / 2)//(1080 - SINGLE_VIEW_WIDTH) / 2
			{
				contentSprite.x = -(modeArray.length - 1) * SINGLE_VIEW_WIDTH;
				rightButton.visible = false;
				leftButton.visible = true;
			}
			setPageTxt();
			leftButton.mouseEnabled = leftButton.mouseChildren = rightButton.mouseEnabled = rightButton.mouseChildren = true;
		}
	}
}