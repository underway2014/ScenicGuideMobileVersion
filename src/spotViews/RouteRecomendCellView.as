package spotViews
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import core.baseComponent.CCImage;
	import core.fontFormat.CFontFormat;
	
	import spotModes.SitesMd;
	
	public class RouteRecomendCellView extends Sprite
	{
		private var siteMd:SitesMd;
		private var cureLen:int = 6;
		public var data:*;
		public function RouteRecomendCellView(_md:SitesMd = null,_index:int = 0)
		{
			super();
			siteMd = _md;
			var pen:Shape = new Shape();
			pen.graphics.lineStyle(2,_index,.8);
			pen.graphics.moveTo(0,23);
			pen.graphics.lineTo(15,16);
			pen.graphics.lineTo(15,16 - cureLen);
			pen.graphics.curveTo(15,0,15 + cureLen,0);
			pen.graphics.lineTo(307 - cureLen,0);
			pen.graphics.curveTo(307,0,307,cureLen);
			pen.graphics.lineTo(307,101 - cureLen);
			pen.graphics.curveTo(307,101,307 - cureLen,101);
			pen.graphics.lineTo(15 + cureLen,101);
			pen.graphics.curveTo(15,101,15,101 - cureLen);
			pen.graphics.lineTo(15,30);
			pen.graphics.lineTo(0,23);
			addChild(pen);
			
			var nameTxt:TextField = new TextField();
			nameTxt.text = siteMd.siteName;
			nameTxt.width = 160;
			nameTxt.setTextFormat(CFontFormat.formatRouteGuideSite);
			addChild(nameTxt);
			nameTxt.x = 20;
			nameTxt.y = 11;
			nameTxt.mouseEnabled = false;
			var dscTxt:TextField = new TextField();
			dscTxt.text = siteMd.siteDesc;
			dscTxt.width = 160;
			dscTxt.multiline = true;
			dscTxt.wordWrap = true;
//			dscTxt.height = 40;
			dscTxt.mouseEnabled = false;
			dscTxt.setTextFormat(CFontFormat.getRouteGuideDsc());
			dscTxt.height = 60;
			addChild(dscTxt);
			dscTxt.x = 20;
			dscTxt.y = 40;
			
			var tipImage:CCImage = new CCImage(120,60,false);
			tipImage.url = SpotGuide.JSON_NAME + siteMd.siteCover;
			addChild(tipImage);
			tipImage.x = 300 - 125;
			tipImage.y = 10;
			
			var spendTxt:TextField = new TextField();
			spendTxt.width = 140;
			spendTxt.mouseEnabled = false;
			spendTxt.text = "游览时间：" + siteMd.siteSpendTime;
			addChild(spendTxt);
			spendTxt.x = 300 - 115;
			spendTxt.y = tipImage.y + tipImage.height + 8;
		}
	}
}