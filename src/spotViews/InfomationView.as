package spotViews
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import core.baseComponent.CCScrollBar;
	import core.baseComponent.CImage;
	
	import spotModes.InfoArticlMd;
	import spotModes.InfoMd;
	
	public class InfomationView extends Sprite
	{
		private var contentSprite:Sprite;
		private var _infoMd:InfoMd;
		private var SELF_WIDHT:int = 696;
		private var SELF_HEIGHT:int = 546;
		private var cscroll:CCScrollBar;
		public function InfomationView()
		{
			super();
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,0,696,546);
			this.graphics.endFill();
			var barArray:Array = [SpotGuide.MAIN_PATH + "scroll_slider.png",SpotGuide.MAIN_PATH + "scroll_bg.png"];
			cscroll = new CCScrollBar(SELF_WIDHT - 40,SELF_HEIGHT,barArray);
			this.addChild(cscroll);
			contentSprite = new Sprite();
//			this.addChild(contentSprite);
			cscroll.target = contentSprite;
		}
		private function initContent():void
		{
			var nameTxt:TextField = new TextField();
			nameTxt.x = 80;
			nameTxt.y = 60;
			nameTxt.width = 300;
			nameTxt.mouseEnabled = false;
			nameTxt.text = _infoMd.infoTipTitle;
			var nameFormat:TextFormat = new TextFormat();
			nameFormat.color = 0x5d5d5d;
			nameFormat.size = 30;
			nameFormat.bold = true;
			nameTxt.setTextFormat(nameFormat);
			contentSprite.addChild(nameTxt);
			
			initDetail();
		}
		private function initDetail():void
		{
			var beginY:int = 110;
			for each(var md:InfoArticlMd in _infoMd.infoTipArticArray)
			{
				if(md.articlIcon)
				{
					var img:CImage = new CImage(585,235,true,false);
					img.addEventListener(Event.REMOVED_FROM_STAGE,imgClear);
					img.url = SpotGuide.JSON_NAME + md.articlIcon;
					contentSprite.addChild(img);
					img.x = 47;
					img.y = beginY;
					beginY += 235 + 22;
				}
				if(md.articlDesc)
				{
					var dscTxt:TextField = new TextField();
					dscTxt.x = 80;
					dscTxt.mouseEnabled = false;
					dscTxt.wordWrap = true;
					dscTxt.multiline = true;
					dscTxt.text = md.articlDesc;
					var dsFormat:TextFormat = new TextFormat();
					dsFormat.letterSpacing = 2;
					dsFormat.leading = 2;
					dsFormat.color = 0x5d5d5d;
					dsFormat.size = 18;
					dscTxt.setTextFormat(dsFormat);
					dscTxt.width = 500;
					dscTxt.height = dscTxt.textHeight + 70;
					dscTxt.y = beginY;
					contentSprite.addChild(dscTxt);
					beginY += dscTxt.textHeight + 70;
				}
				
				if(contentSprite.height <= SELF_HEIGHT)
				{
					cscroll.changeScrollBarState(false);
				}else{
					cscroll.changeScrollBarState(true);
				}
				cscroll.reset();
			}
		}
		private function imgClear(event:Event):void
		{
			var ig:CImage = event.target as CImage;
			ig = null;
		}

		public function get infoMd():InfoMd
		{
			return _infoMd;
		}

		public function set infoMd(value:InfoMd):void
		{
			while(contentSprite.numChildren)
			{
				contentSprite.removeChildAt(0);
			}
			contentSprite.y = 0;
			_infoMd = value;
			initContent();
		}

	}
}