package spotViews
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class SpotRecomendView extends Sprite
	{
		private var axy:Point = new Point(0,27);
		private var bxy:Point = new Point(12,21);
		private var cxy:Point = new Point(12,10);
		private var c1xy:Point = new Point(22,0);
		private var dxy:Point = new Point(290,0);
		private var d1xy:Point = new Point(300,10);
		private var exy:Point = new Point(300,101);
		private var fxy:Point = new Point(12,101);
		private var gxy:Point = new Point(12,23);
		public function SpotRecomendView()
		{
			super();
			var bgshape:Shape = new Shape();
			bgshape.graphics.beginFill(0xaacc00,.3);
			bgshape.graphics.drawRect(0,0,300,101);
			bgshape.graphics.endFill();
			this.addChild(bgshape);
			
			var pen:Shape = new Shape();
			pen.graphics.lineStyle(2,0xff0000);
			pen.graphics.moveTo(axy.x,axy.y);
			pen.graphics.lineTo(bxy.x,bxy.y);
			pen.graphics.lineTo(cxy.x,cxy.y);
			pen.graphics.curveTo(12,0,c1xy.x,c1xy.y);
			pen.graphics.lineTo(dxy.x,dxy.y);
			pen.graphics.curveTo(300,0,d1xy.x,d1xy.y);
			
//			pen.graphics.moveTo(200,200);
//			pen.graphics.curveTo(700,200,450,600);
			this.addChild(pen);
		}
	}
}