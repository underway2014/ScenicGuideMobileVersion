package spotPages
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.fontFormat.CFontFormat;
	import core.tween.TweenLite;
	
	import spotModes.InfoArticlMd;
	import spotModes.SitesMd;
	
	import spotViews.VisitRecomendDetailView;
	
	public class VisitRecomendDetailPage extends Sprite
	{
		private var siteMd:SitesMd;
		private var contentSprite:Sprite;
		public function VisitRecomendDetailPage(_md:SitesMd)
		{
			super();
			siteMd = _md;
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,0,1080,608);
			this.graphics.endFill();
			var titleImage:CImage = new CImage(1080,62,true,false);
			titleImage.url = SpotGuide.MAIN_PATH + "visitRecomend_title.png";
			addChild(titleImage);
			
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
			
			contentSprite = new Sprite();
			addChild(contentSprite);
			contentSprite.y = 56;
			initContent();
			
			initPageButton();
		}
		private var leftButton:CButton;
		private var rightButton:CButton;
		private var currentPageIndex:int;
		private function initPageButton():void
		{
			if(siteMd.siteArticlArray.length <= 1)
			{
				return;
			}
			
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
			
			
			pageTxt = new TextField();
			pageTxt.width = 70;
			pageTxt.mouseEnabled = false;
			pageTxt.text = (currentPageIndex + 1) + " / " + siteMd.siteArticlArray.length;
			pageTxt.setTextFormat(CFontFormat.formatPageText);
			pageBg = new Shape();
			pageBg.graphics.beginFill(0xffffff,.7);
			pageBg.graphics.drawRoundRect(0,0,70,20,20,20);
			pageBg.graphics.endFill();
			addChild(pageBg);
			addChild(pageTxt);
			pageBg.y = pageTxt.y = 608 - 36;
			pageBg.x = pageTxt.x = 728 - pageTxt.width - 50;
			
		}
		private var pageTxt:TextField;
		private var pageBg:Shape;
		private function leftHandler(event:MouseEvent):void
		{
			if(!rightButton.visible)
			{
				rightButton.visible = true;
			}
			currentPageView.reset();
			currentPageIndex--;
			leftButton.mouseEnabled = leftButton.mouseChildren = rightButton.mouseEnabled = rightButton.mouseChildren = false;
			TweenLite.to(contentSprite,.5,{x:contentSprite.x + 1080,onComplete:onFinishTween});
		}
		private function rightHandler(event:MouseEvent):void
		{
			if(!leftButton.visible)
			{
				leftButton.visible = true;
			}
			currentPageView.reset();
			currentPageIndex++;
			leftButton.mouseEnabled = leftButton.mouseChildren = rightButton.mouseEnabled = rightButton.mouseChildren = false;
			TweenLite.to(contentSprite,.5,{x:contentSprite.x - 1080,onComplete:onFinishTween});
		}
		private function onFinishTween():void
		{
			leftButton.mouseEnabled = leftButton.mouseChildren = rightButton.mouseEnabled = rightButton.mouseChildren = true;
			pageTxt.text = (currentPageIndex + 1) + " / " + siteMd.siteArticlArray.length;
			pageTxt.setTextFormat(CFontFormat.formatPageText);
			if (contentSprite.x <= -(siteMd.siteArticlArray.length - 1) * 1080)
			{
				contentSprite.x = -(siteMd.siteArticlArray.length - 1) * 1080;
				rightButton.visible = false;
			}
			if (contentSprite.x >= 0)
			{
				contentSprite.x = 0;
				leftButton.visible = false;
			}
			currentPageView = pageArray[currentPageIndex];
		}
		private var pageArray:Array;
		private var currentPageView:VisitRecomendDetailView;
		private function initContent():void
		{
			var view:VisitRecomendDetailView;
			var i:int = 0;
			pageArray = new Array();
			for each(var md:InfoArticlMd in siteMd.siteArticlArray)
			{
				view = new VisitRecomendDetailView(md);
				view.x = i * 1080;
				contentSprite.addChild(view);
				pageArray.push(view);
				i++;
			}
			currentPageView = pageArray[0];
			
		}
		private function backHomeHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(SpotGuide.BACK_HOME,true));
		}
		private function backHandler(event:MouseEvent):void
		{
			contentSprite.x = 0;
			this.parent.removeChild(this);
		}
	}
}