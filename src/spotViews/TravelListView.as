package spotViews
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CCScrollBar;
	
	import spotModes.NoteMd;
	
	public class TravelListView extends Sprite
	{
		private var noteArray:Array;
		private var contentSprite:Sprite;
		private var SELF_WIDTH:int = 696;
		private var SELF_HEIGHT:int = 546;
		private var maskBg:Sprite;
		private var scroll:CCScrollBar;
		public function TravelListView(_arr:Array)
		{
			super();
			noteArray = _arr;
			contentSprite = new Sprite();
			var barArray:Array = [SpotGuide.MAIN_PATH + "scroll_slider.png",SpotGuide.MAIN_PATH + "scroll_bg.png"];
			scroll = new CCScrollBar(SELF_WIDTH - 60,SELF_HEIGHT,barArray);
			contentSprite.x = 47;
			this.addChild(scroll);
			maskBg = new Sprite();
			maskBg.graphics.beginFill(0,.4);
			maskBg.graphics.drawRect(0,0,SELF_WIDTH,SELF_HEIGHT);
			maskBg.graphics.endFill();
			maskBg.visible = false;
			addChild(maskBg);
			
			scroll.target = contentSprite;
//			addChild(contentSprite);
			initContent();
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,0,SELF_WIDTH,SELF_HEIGHT);
			this.graphics.endFill();
		}
		private function initContent():void
		{
			var noteCell:TravelListCellView;
			var i:int = 0;
			for each(var noteMd:NoteMd in noteArray)
			{
				noteCell = new TravelListCellView(noteMd);
				noteCell.y = i * noteCell.SELF_HEIGHT;
				noteCell.data = noteMd;
				contentSprite.addChild(noteCell);
				noteCell.addEventListener(MouseEvent.CLICK,clickHandler);
				i++;
			}
			if(i < 4)
			{
				scroll.changeScrollBarState(false);
			}
			
		}
		private var travelDetail:TravelNoteDetailView;
		private function clickHandler(event:MouseEvent):void
		{
			maskBg.visible = true;
			var cell:TravelListCellView = event.currentTarget as TravelListCellView;
			travelDetail = new TravelNoteDetailView(cell.data);
			travelDetail.addEventListener(Event.REMOVED_FROM_STAGE,setDetailNullHandler);
			travelDetail.x = (SELF_WIDTH - travelDetail.width) /2;
			travelDetail.y = (SELF_HEIGHT - 512) / 2;
			addChild(travelDetail);
		}
		private function setDetailNullHandler(event:Event):void
		{
			travelDetail = null;
			maskBg.visible = false;
		}
		public function clear():void
		{
			if(travelDetail)
			{
				if(travelDetail.parent)
				{
					travelDetail.parent.removeChild(travelDetail);
				}
			}
		}
		public function reset():void
		{
			scroll.reset();
		}
	}
}