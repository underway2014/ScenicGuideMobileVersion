package spotViews
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import core.layout.PictureZoom;
	import core.loadEvents.CLoader;
	import core.loadEvents.CLoaderMany;
	
	import spotModes.PictureMd;

	public class PictureView extends Sprite
	{
		private static const PIC_WIDTH:int = 1080;
		private static const PIC_HEIGHT:int = 552;
		private static const BG_HEIGHT:int = 40;
		private var loader:CLoader;
		public function PictureView(_md:PictureMd)
		{
			super();
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0);
			shape.graphics.drawRect(0,0,PIC_WIDTH,PIC_HEIGHT);
			shape.graphics.endFill();
			addChild(shape);
			loader = new CLoader();
			loader.load(SpotGuide.JSON_NAME + _md.pathUrl);
			loader.addEventListener(CLoader.LOADE_COMPLETE,okHandler);
			initText(_md.descText);
		}
		private function okHandler(event:Event):void
		{
			PictureZoom.strench(loader._loader,PIC_WIDTH,PIC_HEIGHT);
			addChildAt(loader._loader,1);
		}
		private function initText(_txt:String):void
		{
			var bgShape:Shape = new Shape();
			
			addChild(bgShape);
			
			var textField:TextField = new TextField();
			textField.htmlText = _txt;
			textField.multiline = true;
			textField.wordWrap = true;
			textField.x = 40;
			textField.mouseEnabled = false;
			textField.width = PIC_WIDTH - 80;
			var textFormat:TextFormat = new TextFormat();
			textField.height = BG_HEIGHT;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.color = 0xffffff;
			textFormat.size = 20;
			textField.setTextFormat(textFormat);
			textField.y = PIC_HEIGHT - BG_HEIGHT + 10;
			
			bgShape.graphics.beginFill(0,0.4);
			bgShape.graphics.drawRect(0,PIC_HEIGHT - BG_HEIGHT,PIC_WIDTH,BG_HEIGHT);
			bgShape.graphics.endFill();
			addChild(textField);
			initQuota();
		}
		public var quotaLoad:CLoaderMany;
		private function initQuota():void
		{
			quotaLoad = new CLoaderMany();
			var arr:Array = new Array(SpotGuide.MAIN_PATH + "left_quota.png",SpotGuide.MAIN_PATH + "right_quota.png");
			quotaLoad.load(arr);
			quotaLoad.addEventListener(CLoaderMany.LOADE_COMPLETE,quotaHandler);
		}
		private function quotaHandler(event:Event):void
		{
			quotaLoad._loaderContent[0].y = quotaLoad._loaderContent[1].y = PIC_HEIGHT - BG_HEIGHT + 10;
			quotaLoad._loaderContent[1].x = PIC_WIDTH - 55;
			quotaLoad._loaderContent[0].x = 20;
			addChild(quotaLoad._loaderContent[0]);
			addChild(quotaLoad._loaderContent[1]);
		}
	}
}