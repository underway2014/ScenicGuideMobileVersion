package spotViews
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import core.baseComponent.AudioButton;
	import core.baseComponent.CImage;
	import core.baseComponent.MusicPlayer;
	import core.fontFormat.CFontFormat;
	import core.layout.Group;
	import core.loadEvents.Cevent;
	
	import spotModes.AudioMd;
	import spotModes.PointMd;
	
	public class AudioPointView extends Sprite
	{
		private var beginAngle:int = 180;
		private var rotationAngle:int;
		private var everyAngle:int = 40;
		private var stateIndex:int;
		private var pointMd:PointMd;
		private var centerImage:CImage;
		private var centerImageSprite:Sprite;
		
		private var nameTxt:TextField;
		private var nameSprite:Sprite;
		private var LINE_LONG:int = 100;
		private var stateName:TextField;
		
		private var RIGHT_SHADOW:int = 26;
		
		public function AudioPointView(_md:PointMd,_color:int = 1,_angle:Number = 0)
		{
			super();
			pointMd = _md;
			rotationAngle = _angle;
			stateIndex = _md.pointIndex;
			
			var line:Shape = new Shape();
			if(pointMd.pointType)
			{
				line.graphics.lineStyle(3,0xffffff);//other state use white color
			}else{
				line.graphics.lineStyle(3,_color);
			}
			line.graphics.moveTo(0,0);
			line.graphics.lineTo(LINE_LONG + RIGHT_SHADOW,0);
			addChild(line);
			
			centerImage = new CImage(234,234,false,false);
			centerImage.url = SpotGuide.MAIN_PATH + "audio/audio_" + stateIndex + ".png";
			centerImageSprite = new Sprite();
			addChild(centerImageSprite);
			centerImageSprite.x = LINE_LONG + centerImage.width/2;
			centerImageSprite.addChild(centerImage);
			centerImage.x = -centerImage.width / 2;
			centerImage.y = -centerImage.height / 2;
			
			nameTxt = new TextField();
			nameTxt.text = pointMd.pointName;
			nameTxt.mouseEnabled = false;
			formatAudioCenterName = new TextFormat(null,20,_color,true,null,null,null,null,TextFormatAlign.CENTER,null,null,null,-8);//play MUSIC spot name
			nameTxt.setTextFormat(formatAudioCenterName);
			nameSprite = new Sprite();
			nameSprite.addChild(nameTxt);
			addChild(nameSprite);
			nameSprite.x = centerImageSprite.x;
			nameTxt.width = 234;
			nameTxt.x = -234 / 2;
			
			stateName = new TextField();
			stateName.mouseEnabled = false;
			nameSprite.addChild(stateName);
			stateName.width = 234;
			stateName.x = -234 / 2;
			childSprite = new Sprite();
			addChild(childSprite);
			initChildButton();
		}
		private var childSprite:Sprite;
		private var formatAudioCenterName:TextFormat;
		private var group:Group;
		private function initChildButton():void
		{
			var audioButton:AudioButton;
			var txtsprite:Sprite;
			var txtContain:Sprite;
			var i:int = 0;
			group = new Group();
			playButtonArray = new Array();
			playTxtArray = new Array();
			txtContainArray = new Array();
			group.autoChangeState = true;
			var txt:TextField;
			for each(var audioMd:AudioMd in pointMd.pointAudioArray)
			{
				audioButton = new AudioButton([SpotGuide.MAIN_PATH + "play/bofang" + stateIndex + ".png",SpotGuide.MAIN_PATH + "pause/zanting" + stateIndex + ".png"],true,true,true);
//				audioButton.direct = 0;
				audioButton.data = audioMd;
				txt = new TextField();
				txt.htmlText = audioMd.audioName;
				txt.mouseEnabled = false;
				txt.width = 120;
//				txt.wordWrap = true;
				txt.multiline = true;
				txt.setTextFormat(CFontFormat.formatAudioText);
				txt.height = txt.textHeight + 10;
				txtsprite = new Sprite();
				txtsprite.addChild(txt);
				txtContain = new Sprite();
				txtContain.addChild(txtsprite);
				txtContainArray.push(txtContain);
				addChild(txtContain);
				
				txt.x = -txt.width / 2;
				txt.y = -txt.height / 2;
				playTxtArray.push(txtsprite);
				var endAngel:int;
				if(i % 2 == 0)
				{
					 endAngel = beginAngle - everyAngle *(Math.floor( i / 2) + 1);
				}else
				{
					 endAngel = beginAngle + everyAngle * (Math.floor( i / 2) + 1);
				}
				var xx:int = 150 * Math.cos(endAngel / 360 * 2*Math.PI) + centerImageSprite.x;
				var yy:int = 150 * Math.sin(endAngel / 360 * 2*Math.PI) + centerImageSprite.y;
				txtContain.x = audioButton.x = xx;
				txtContain.y = audioButton.y = yy;
//				txtsprite.x = xx;
				if(i % 2 == 0)
				{
					audioButton.direct = true;//up
					txtsprite.y = - txtsprite.height / 2 - 35;
					audioButton.upY = txtsprite.y;
					audioButton.downY = 65;
					trace(" if rotationAngle <= 0");
				}else{
					trace(" if rotationAngle > 0");
					audioButton.direct = false;
					txtsprite.y = 65;
					audioButton.upY = - txtsprite.height / 2 - 35;
					audioButton.downY = 65
				}
				
				childSprite.addChild(audioButton);
				playButtonArray.push(audioButton);
//				playButtonArray.push(bsprite);
				audioButton.addEventListener(MouseEvent.CLICK,clickHandler);
				group.add(audioButton);
//				audioButton.x = audioButton.y = -55;
				i++;
			}
			group.addEventListener(Cevent.SELECT_CHANGE,selectChangeHandler);
			autoRotation(rotationAngle);
			
		}
		private var playButtonArray:Array;
		private var playTxtArray:Array;
		private var txtContainArray:Array;
		public function autoRotation(_angle):void
		{
			var i:int = 0;
			centerImageSprite.rotationZ = _angle;
			nameSprite.rotationZ = _angle;
			for each(var po:AudioButton in playButtonArray)
			{
				po.rotationZ = _angle;
				var vo:DisplayObject = txtContainArray[i];
				vo.rotationZ = _angle;
				var txtF:DisplayObject = playTxtArray[i];
				
				
//				var p:Point = new Point(0,0);
//				var cimgP:Point = centerImage.parent.localToGlobal(p);
//				var bp:Point = childSprite.localToGlobal(p);
				var cimgP:Point = centerImageSprite.localToGlobal(new Point(-117,-117));
				var bp:Point = po.parent.localToGlobal(new Point(po.x,po.y));
//				trace("centerImageXY =" + i + "=" + centerImage.x, centerImage.y);
//				trace("centerImage.parent = " +  centerImage.parent.x,centerImage.parent.y );
//				trace("centerImageSpriteXY = " + centerImageSprite.x ,centerImageSprite.y);
//				trace("po.x.y = " + po.x,po.y);
//				trace("cimgP.x.y = " + cimgP.x, cimgP.y," bp.x.y = " + bp.x, bp.y);
//				trace("****************");
				if(cimgP.y + 117 > bp.y)//
				{
					if(!po.direct)
					{
						
						//文字从下到上
//						trace("文字从下到上 =" + i + "=" + po.data,"YY = " + cimgP.y ,bp.y);
//						vo.rotationX = 180;
//						txtF.rotationX = 180;
						txtF.y = po.upY;;
						po.direct = true;
					}
						
				}else{
					if(po.direct)
					{
//						trace("文字从上倒下 =" + i + "="  + po.data,"YY = " + cimgP.y ,bp.y);
						// 文字从上倒下
//						vo.rotationX = 180;
//						txtF.rotationX = 180;
						txtF.y = po.downY;;
						po.direct = false;
					}
				}
				i++;
			}
//			for each(var vo:DisplayObject in txtContainArray)
//			{
//				vo.rotationZ = _angle;
//				
//			}
			
		}
		private function changeTxtDir():void
		{
		}
		private var currentButton:AudioButton;
		private function clickHandler(event:MouseEvent):void
		{
			var btn:AudioButton = event.currentTarget as AudioButton;
			if(isPlay||isPause)
			{
				if(currentButton == btn)
				{
					if(isPause)
					{
						musicPlayer.play();
						dispatchEvent(new Event("soundoff",true));
						isPause = false;
						isPlay = true;
					}else if(isPlay)
					{
						musicPlayer.pause();
						dispatchEvent(new Event("soundon",true));
						isPlay = false;
						isPause = true;
					}else{
						group.selectByItem(btn);
					}
				}else{
					currentButton = btn;
					group.selectByItem(btn);
				}
			}else{
				currentButton = btn;
				group.selectByItem(btn);
			}
		}
		private var musicPlayer:MusicPlayer;
		private var isPlay:Boolean;
		private var isPause:Boolean;
		private function selectChangeHandler(event:Event):void
		{
			trace("play music.");
			var bt:AudioButton = group.getCurrentObj() as AudioButton;
			var md:AudioMd = bt.data;
			if(musicPlayer)
			{
				musicPlayer.removeEventListener(MusicPlayer.PLAY_OVER,musicPlayOverHandler);
				musicPlayer.clear();
				musicPlayer = null;
			}
			stateName.text = md.audioName;
			stateName.setTextFormat(formatAudioCenterName);
			if(stateName.numLines > 1)
			{
				stateName.y = -stateName.textHeight / 2 + 15;
			}
			stateName.visible = true;
			nameTxt.visible = false;
			musicPlayer = new MusicPlayer(SpotGuide.JSON_NAME + md.audioUrl,true,false);
			musicPlayer.addEventListener(MusicPlayer.PLAY_OVER,musicPlayOverHandler);
			isPlay = true;
			isPause = false;
			dispatchEvent(new Event("soundoff",true));
		}
		private function musicPlayOverHandler(event:Event):void
		{
			currentButton.select(false);
			group.selectById(-1);
			musicPlayer.removeEventListener(MusicPlayer.PLAY_OVER,musicPlayOverHandler);
			isPlay = isPause = false;
			musicPlayer = null;
			stateName.visible = false;
			nameTxt.visible = true;
			dispatchEvent(new Event("soundon",true));
		}
		public function clear():void
		{
			if(musicPlayer)
			{
				dispatchEvent(new Event("soundon",true));
				musicPlayer.removeEventListener(MusicPlayer.PLAY_OVER,musicPlayOverHandler);
				musicPlayer.clear();
				musicPlayer = null;
			}
		}
	}
}