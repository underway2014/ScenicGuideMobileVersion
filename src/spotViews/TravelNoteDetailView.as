package spotViews
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import core.baseComponent.CCScrollBar;
	import core.baseComponent.CImage;
	import core.fontFormat.CFontFormat;
	
	import spotModes.NoteArticleMd;
	import spotModes.NoteMd;
	
	
	public class TravelNoteDetailView extends Sprite
	{
		private var modeArray:Array;
		private var SELF_WIDHT:int = 545 + 14;
		private var SELF_HEIGHT:int = 512;
		private var detailSprite:Sprite;
		private var cscroll:CCScrollBar;
		public function TravelNoteDetailView(_md:NoteMd)
		{
			super();
			
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff);
			bg.graphics.drawRoundRect(0,0,SELF_WIDHT,SELF_HEIGHT,20,20);
			bg.graphics.endFill();
			this.addChild(bg);
			
			modeArray = _md.noteArticlesArr;
			
			var nameText:TextField = new TextField();
			nameText.text = _md.noteTitle;
			nameText.x = 22;
			nameText.y = 25;
			nameText.setTextFormat(CFontFormat.getTravelDetailTitleFormat());
			nameText.width = 500;
			addChild(nameText);
			
			var sourceTxt:TextField = new TextField();
			sourceTxt.text = _md.noteTime + " 来源: " + _md.noteSource;
			var sourceFor:TextFormat = new TextFormat(null,16,0x757575);
			sourceTxt.setTextFormat(sourceFor);
			addChild(sourceTxt);
			sourceTxt.width = 500;
			sourceTxt.x = 22;
			sourceTxt.y = 55;
			
			var closeImage:CImage = new CImage(66,58,true,false);
			closeImage.url = SpotGuide.MAIN_PATH + "traveNote_close.png";
			addChild(closeImage);
			closeImage.x = SELF_WIDHT - closeImage.width;
			closeImage.y = 5;
			closeImage.addEventListener(MouseEvent.CLICK,closeHandler);
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(3,0xf2f2f2);
			line.graphics.moveTo(22,85);
			line.graphics.lineTo(SELF_WIDHT - 22,85);
			this.addChild(line);
			
			detailSprite = new Sprite();
			scrollSrpte = new Sprite();
			scrollSrpte.y = 67 + 20;
			scrollSrpte.x = 22;
			addChild(scrollSrpte);
			var barArray:Array = [SpotGuide.MAIN_PATH + "scroll_slider.png",SpotGuide.MAIN_PATH + "scroll_bg.png"];
			cscroll = new CCScrollBar(SELF_WIDHT - 35,SELF_HEIGHT - scrollSrpte.y - 10,barArray);
			cscroll.target = detailSprite;
			scrollSrpte.addChild(cscroll);
			initContent();
		}
		private function closeHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		private var scrollSrpte:Sprite;
		private function initContent():void
		{
			var detailCell:TravelDetailCellView;
			var currentY:int = 0;
			for each(var md:NoteArticleMd in modeArray)
			{
				detailCell = new TravelDetailCellView(md);
				detailCell.y = currentY;
				detailSprite.addChild(detailCell);
				currentY += detailCell.cellHeight;
			}
			if(currentY > SELF_HEIGHT)
			{
				cscroll.changeScrollBarState(true);
			}else{
				cscroll.changeScrollBarState(false);
			}
		}
	}
}