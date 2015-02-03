package spotViews
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import core.baseComponent.CCScrollBar;
	import core.layout.PictureZoom;
	import core.loadEvents.CLoader;
	
	import spotModes.RecomendMd;
	
	public class RecomendView extends Sprite
	{
		private var SELF_WIDHT:int = 884;
		private var SELF_HEIGHT:int = 457;
		private var PIC_WIDTH:int = 542;
		
		private var TEXT_WIDHT:int = 302;
		
		private var DSC_Y:int = 90;
		
		private var constentSpite:Sprite;
		private var rightSprite:Sprite;
		public function RecomendView(_md:RecomendMd)
		{
			super();
			var bgShape:Shape = new Shape();
			bgShape.graphics.beginFill(0xffffff);
			bgShape.graphics.drawRect(0,0,SELF_WIDHT,SELF_HEIGHT);
			bgShape.graphics.endFill();
			this.addChild(bgShape);
			
			var maskShape:Shape = new Shape();
			maskShape.graphics.beginFill(0xaa0000,.3);
			maskShape.graphics.drawRoundRect(0,0,SELF_WIDHT,SELF_HEIGHT,40,40);
			maskShape.graphics.endFill();
			
			
			constentSpite = new Sprite();
			bgShape.y = maskShape.y = constentSpite.y = -SELF_HEIGHT/2;
			bgShape.x = maskShape.x = constentSpite.x = -SELF_WIDHT/2;
			addChild(constentSpite);
			this.mask = maskShape;
			this.addChild(maskShape);
			
			rightSprite = new Sprite();
//			rightSprite.graphics.beginFill(0xffffff);
//			rightSprite.graphics.drawRect(0,0,322,SELF_HEIGHT);
//			rightSprite.graphics.endFill();
//			rightSprite.y = -SELF_HEIGHT/2;
			rightSprite.x = PIC_WIDTH + 20;
			constentSpite.addChild(rightSprite);
			
			initPic(_md.recomendIcon);
			initText(_md);
		}
		private function initPic(_url:String):void
		{
			var loader:CLoader = new CLoader();
			loader.load(SpotGuide.JSON_NAME + _url);
			loader.addEventListener(CLoader.LOADE_COMPLETE,leftHandler);
		}
		private function leftHandler(event:Event):void
		{
			var ll:CLoader = event.target as CLoader;
			PictureZoom.strench(ll._loader,PIC_WIDTH,SELF_HEIGHT);
			constentSpite.addChild(ll._loader);
		}
		private function initText(md:RecomendMd):void
		{
			var nameFormat:TextFormat = new TextFormat();
			nameFormat.size = 30;
			nameFormat.color = 0x076699;
			var nameText:TextField = new TextField();
			nameText.width = TEXT_WIDHT;
			nameText.mouseEnabled = false;
			nameText.text = md.recomendTitle;
			nameText.setTextFormat(nameFormat);
			nameText.y = 40;
			rightSprite.addChild(nameText);
			
			var detailFormat:TextFormat = new TextFormat();
			detailFormat.letterSpacing = 2;
			detailFormat.leading = 2;
			detailFormat.color = 0x181818;
			detailFormat.size = 18;
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.letterSpacing = 2;
			titleFormat.color = 0x5d5d5d;
			titleFormat.bold = true;
			titleFormat.size = 20;
			var barArray:Array = [SpotGuide.MAIN_PATH + "scroll_slider.png",SpotGuide.MAIN_PATH + "scroll_bg.png"];
			if (md.recomendDesc)
			{
				var dsTitle:TextField = new TextField();
				dsTitle.mouseEnabled = false;
				dsTitle.height = 30;
				dsTitle.text = "简介：";
				dsTitle.x = 30;
				dsTitle.setTextFormat(titleFormat);
				dsTitle.y = dscBeginY;
				rightSprite.addChild(dsTitle);
				var dscText:TextField = new TextField();
				phoneBeginY += 30;
				dscText.y = dscBeginY + 30;
				dscText.width = TEXT_WIDHT;
				dscText.mouseEnabled = false;
				dscText.wordWrap = true;
//				dscText.selectable = false;
				dscText.multiline = true;
				dscText.text = md.recomendDesc;
				
				dscText.setTextFormat(detailFormat);
				dscText.height = dscText.textHeight + 10;
				if(dscText.height > 242)
				{
//					dscText.height = 242;
					var ts:Sprite = new Sprite();
					ts.addChild(dscText);
					dscText.x = dscText.y = 0;
					var scroll:CCScrollBar = new CCScrollBar(TEXT_WIDHT + 3,242,barArray);
					scroll.target = ts;
					scroll.x = 0;
					scroll.y = dscBeginY + 30;
					rightSprite.addChild(scroll);
					phoneBeginY += 252;
				}
				else{
					rightSprite.addChild(dscText);
					phoneBeginY += (dscText.textHeight + 10);
				}
				adressBeginY = phoneBeginY;
				var dscLoad:CLoader = new CLoader();
				dscLoad.load(SpotGuide.MAIN_PATH + "recomend_dsc.png");
				dscLoad.addEventListener(CLoader.LOADE_COMPLETE,dscOkHandler);
			}
			if (md.recomendPhone) 
			{
				var phoneTitle:TextField = new TextField();
				phoneTitle.text = "联系电话：";
				phoneTitle.mouseEnabled = false;
				phoneTitle.height = 30;
				phoneTitle.x = 20;
				phoneTitle.setTextFormat(titleFormat);
				phoneTitle.width = phoneTitle.textWidth;
				rightSprite.addChild(phoneTitle);
				var phoneText:TextField = new TextField();
				phoneText.x = phoneTitle.textWidth + phoneTitle.x;
				phoneText.width = 342 - phoneText.x;
				phoneText.mouseEnabled = false;
				phoneText.text = md.recomendPhone;
				phoneText.setTextFormat(detailFormat);
				phoneTitle.y = phoneText.y = phoneBeginY;
				rightSprite.addChild(phoneText);
				adressBeginY += 30 + 10;
				var phLoad:CLoader = new CLoader();
				phLoad.load(SpotGuide.MAIN_PATH + "recomend_phone.png");
				phLoad.addEventListener(CLoader.LOADE_COMPLETE,phoneOkHandler);
			}
			if (md.recomendAddress) 
			{
				var adressLoader:CLoader = new CLoader();
				adressLoader.load(SpotGuide.MAIN_PATH + "recomend_adress.png");
				adressLoader.addEventListener(CLoader.LOADE_COMPLETE,adressoKHandler);
				
				var adressTitle:TextField = new TextField();
				adressTitle.text = "地址：";
				adressTitle.mouseEnabled = false;
				adressTitle.x = 21;
				adressTitle.setTextFormat(titleFormat);
				adressTitle.width = adressTitle.textWidth;
				rightSprite.addChild(adressTitle);
				
				var adressText:TextField = new TextField();
				adressText.x = adressTitle.x + adressTitle.textWidth;
				adressText.width = 300 - adressTitle.textWidth - 25;
				adressText.mouseEnabled = false;
				adressText.wordWrap = true;
				adressText.multiline = true;
				adressText.text = md.recomendAddress;
				adressText.setTextFormat(detailFormat);
				adressText.height = adressText.textHeight + 10;
				rightSprite.addChild(adressText);
				adressText.y = adressTitle.y = adressBeginY;
			}
		}
		private var dscBeginY:Number = DSC_Y;
		private var phoneBeginY:int = DSC_Y;
		private var adressBeginY:int = DSC_Y;
		private function dscOkHandler(event:Event):void
		{
			var dl:CLoader = event.target as CLoader;
			rightSprite.addChild(dl._loader);
			dl._loader.y = dscBeginY;
		}
		private function phoneOkHandler(event:Event):void
		{
			var pl:CLoader = event.target as CLoader;
			rightSprite.addChild(pl._loader);
			pl._loader.y = phoneBeginY;
		}
		private function adressoKHandler(event:Event):void
		{
			var al:CLoader = event.target as CLoader;
			rightSprite.addChild(al._loader);
			al._loader.y = adressBeginY;
		}
	}
}