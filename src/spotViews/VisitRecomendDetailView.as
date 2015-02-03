package spotViews
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import core.baseComponent.CCScrollBar;
	import core.baseComponent.CImage;
	import core.fontFormat.CFontFormat;
	
	import spotModes.InfoArticlMd;
	
	public class VisitRecomendDetailView extends Sprite
	{
		public function VisitRecomendDetailView(_articlMd:InfoArticlMd)
		{
			super();
			
			var image:CImage = new CImage(724,552,true,false);
			image.url = SpotGuide.JSON_NAME + _articlMd.articlIcon;
			addChild(image);
			
			var titleTxt:TextField = new TextField();
			titleTxt.mouseEnabled = false;
			titleTxt.text = _articlMd.articlTitle;
			titleTxt.setTextFormat(CFontFormat.formatVisitDetailTitle);
			titleTxt.height = 30;
			titleTxt.width = 300;
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0xde390c);
			bg.graphics.drawRect(0,0,titleTxt.textWidth + 4,30);
			bg.graphics.endFill();
			addChild(bg);
			bg.x = titleTxt.x = 30 + 724;
			titleTxt.y = 50;
			bg.y = titleTxt.y - 3;
			addChild(titleTxt);
			
			
			var ts:Sprite = new Sprite();
			var dscTxt:TextField = new TextField();
			dscTxt.mouseEnabled = false;
			dscTxt.multiline = true;
			dscTxt.wordWrap = true;
			dscTxt.text = _articlMd.articlDesc;
			dscTxt.width = 254;
			dscTxt.setTextFormat(CFontFormat.getVisitDetailDsc());
			dscTxt.height = dscTxt.textHeight + 10;
			ts.addChild(dscTxt);
//			dscTxt.y = 100;
//			dscTxt.x = 20 + 724;
			var barArray:Array = [SpotGuide.MAIN_PATH + "scroll_slider.png",SpotGuide.MAIN_PATH + "scroll_bg.png"];
			trace("ts.height = ",ts.height);
			if(ts.height > 450)
			{
				scroll = new CCScrollBar(254,450,barArray);
			}else{
				scroll = new CCScrollBar(254,450);
			}
			
			scroll.target = ts;
			addChild(scroll);
			scroll.x = 20 + 724;
			scroll.y = 100;
//			addChild(dscTxt);
			
		}
		private var scroll:CCScrollBar;
		public function reset():void
		{
			scroll.reset();
		}
	}
}