package spotViews
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import core.baseComponent.CCImage;
	import core.baseComponent.CImage;
	import core.fontFormat.CFontFormat;
	
	import spotModes.NoteMd;
	
	public class TravelListCellView extends Sprite
	{
		public var data:*;
		private var noteMd:NoteMd;
		private var dscSprite:Sprite;
		private var SELF_WIDHT:int = 600 - 50;
		public var SELF_HEIGHT:int = 150;
		public function TravelListCellView(_md:NoteMd)
		{
			super();
//			this.graphics.beginFill(0xaacc00,.4);
//			this.graphics.drawRect(0,0,SELF_WIDHT,SELF_HEIGHT);
//			this.graphics.endFill();
			
			noteMd = _md;
			var image:CCImage = new CCImage(110,111,false);
			image.url = SpotGuide.JSON_NAME + noteMd.noteIcon;
			image.y = (SELF_HEIGHT - 110) / 2;
			addChild(image);
			
			dscSprite = new Sprite();
			addChild(dscSprite);
			dscSprite.x = 141;
			dscSprite.y = 30;
			initDsc();
			
			var rightImage:CImage = new CImage(33,44,true,false);
			rightImage.url = SpotGuide.MAIN_PATH + "traveNote_arrow.png";
			addChild(rightImage);
			rightImage.x = SELF_WIDHT - 33;
			rightImage.y = 50;
			
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(2,0xf2f2f2);//0xebebeb
			line.graphics.moveTo(0,SELF_HEIGHT - 3);
			line.graphics.lineTo(SELF_WIDHT,SELF_HEIGHT - 3);
			this.addChild(line);
		}
		private function initDsc():void
		{
			var nameFormat:TextFormat = new TextFormat();
			nameFormat.size = 20;
			nameFormat.bold = true;
			nameFormat.color = 0x5b5b5b;
			var nameTxt:TextField = new TextField();
			nameTxt.mouseEnabled = false;
			nameTxt.text = noteMd.noteTitle;
			nameTxt.wordWrap = true;
			nameTxt.multiline = true;
			nameTxt.width = SELF_WIDHT - dscSprite.x;
			nameTxt.setTextFormat(nameFormat);
			dscSprite.addChild(nameTxt);
			
			if(noteMd.noteSubtitle)
			{
				var subTxt:TextField = new TextField();
				subTxt.width = SELF_WIDHT - dscSprite.x;
				subTxt.mouseEnabled = false;
				subTxt.wordWrap = true;
				subTxt.multiline = true;
				subTxt.height = 50;
				subTxt.y = nameTxt.textHeight + 5;
				subTxt.text = noteMd.noteSubtitle;
				subTxt.setTextFormat(CFontFormat.getTravelDscFormat());
				dscSprite.addChild(subTxt);
				
			}
			if(noteMd.noteAuthor)
			{
				var authorTxt:TextField = new TextField();
				authorTxt.mouseEnabled = false;
				authorTxt.text = "作者：" + noteMd.noteAuthor;
				authorTxt.width = 400;
				authorTxt.y = SELF_HEIGHT - 70;
				authorTxt.setTextFormat(CFontFormat.formatAuthor);
				dscSprite.addChild(authorTxt);
			}
			
		}
	}
}