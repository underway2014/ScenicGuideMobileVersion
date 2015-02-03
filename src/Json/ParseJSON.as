package Json
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import spotModes.AudioMd;
	import spotModes.InfoArticlMd;
	import spotModes.InfoMd;
	import spotModes.NoteArticleMd;
	import spotModes.NoteMd;
	import spotModes.PictureMd;
	import spotModes.PointMd;
	import spotModes.RecomendMd;
	import spotModes.RouteMd;
	import spotModes.SitesMd;
	import spotModes.SpotMd;
	import spotModes.VideoMd;
	import spotModes.VisitsMd;

	public class ParseJSON extends EventDispatcher
	{
		
		public static const LOAD_COMPLETE_INFO:String = "info_load_ok";
		public static const LOAD_COMPLETE_MAP:String = "load_ok_map";
//		public static 
		
		private var type:int;
		/**
		 * 
		 * @param path
		 * @param _type !0 parseInfo else  
		 * 
		 */		
		public function ParseJSON(path:String,_type:int = 0)
		{
			type = _type;
			loadJson(path);
		}
		public function loadJson(path:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(path));
			loader.addEventListener(Event.COMPLETE,jsonLoadOkHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
		}
		private function jsonLoadOkHandler(event:Event):void
		{
			var obj:Object = JSON.parse(URLLoader(event.target).data);
			if (type) 
			{
				parseInfoJson(obj);
			}else{
				parseJson(obj);
			}
			
		}
		private function errorHandler(event:IOErrorEvent):void
		{
			trace("json load wrong!");
		}
		private var spotAllInfo:SpotMd;
		private var pictureArray:Array;
		private var videosArray:Array;
		private var visitArray:Array;// list data
		private var routeArray:Array;//map data
		private var noteArray:Array;
		private var spotsNameArray:Array;
		public function parseJson(data:Object):void
		{
			//parse spotAll info
			spotAllInfo = new SpotMd();
			spotAllInfo.spotName = data.name;
			spotAllInfo.spotFree = data.is_free;
			spotAllInfo.spotColorMap = data.colour_icon;
			spotAllInfo.spotGrayMap = data.grey_icon;
			spotAllInfo.spotIcon = data.icon;
			
			//parse picture slides
			pictureArray = new Array();
			var picMd:PictureMd;
			for each(var pico:Object in data.slides)
			{
				picMd = new PictureMd();
				picMd.descText = pico.description;
				picMd.pathUrl = pico.image;
				pictureArray.push(picMd);
			}
			
			//parse videos
			videosArray = new Array();
			var videoMd:VideoMd;
			for each(var videoo:Object in data.videos)
			{
				videoMd = new VideoMd();
				videoMd.videoCover = videoo.cover;
				videoMd.videoDuration = videoo.duration;
				videoMd.videoSize = videoo.size;
				videoMd.videoName = videoo.name;
				videoMd.videoUrl = videoo.video;
				videosArray.push(videoMd);
			}
			
			//parse visits
			visitArray = new Array();
			spotsNameArray = new Array();
			var visitMd:VisitsMd;
			var i:int = 0;
			for each(var visito:Object in data.visits)
			{
				visitMd = new VisitsMd();
				visitMd.visitIcon = visito.icon;
				visitMd.visitName = visito.name;
				visitMd.visitSitsArray = new Array();
				visitMd.visitOtherSitesArray = new Array();
				
				var siteMd:SitesMd;
				var mainSoptArr:Array = new Array();
				var otherspotArr:Array = new Array();
				for each(var siteso:Object in visito.sites)
				{
					siteMd = new SitesMd();
					siteMd.siteCover = siteso.cover;
					siteMd.siteDesc = siteso.desc;
					siteMd.siteDistance = siteso.distance;
					siteMd.siteName = siteso.title;
					siteMd.siteSpendTime = siteso.spend_time;
					siteMd.siteType = siteso.type_cd;
					siteMd.siteArticlArray = new Array();
					var arMd:InfoArticlMd;
					for each(var aro:Object in siteso.articles)
					{
						arMd = new InfoArticlMd();
						arMd.articlDesc = aro.desc;
						arMd.articlIcon = aro.icon;
						arMd.articlTitle = aro.title;
						siteMd.siteArticlArray.push(arMd);
					}
					if(siteMd.siteType)// = 1
					{
						visitMd.visitOtherSitesArray.push(siteMd);//其他景点
						otherspotArr.push(siteMd.siteName);
					}else{
						visitMd.visitSitsArray.push(siteMd);
						mainSoptArr.push(siteMd.siteName);
					}
				}
				visitArray.push(visitMd);
				if(i == 0)
				{
					spotsNameArray = spotsNameArray.concat(mainSoptArr);
					spotsNameArray = spotsNameArray.concat(otherspotArr);
				}
				i++;
			}
			//parse routes
			routeArray = new Array();
			var routeMd:RouteMd;
			for each(var routo:Object in data.routes)
			{
				routeMd = new RouteMd();
				routeMd.routeIcon = routo.icon;
				routeMd.routePositio = routo.ios_position;
				routeMd.routePointArray = new Array();
				routeMd.routeOtherPointArray = new Array();
				var pointMd:PointMd;
				for each(var pointo:Object in routo.points)
				{
					pointMd = new PointMd();
					pointMd.pointName = pointo.name;
					var ar:Array = String(pointo.coord).split(",");
					pointMd.pointPositin = new Point(ar[0],ar[1]);
					pointMd.pointAudioArray = new Array();
					var audioMd:AudioMd;
					for each(var audioo:Object in pointo.audios)
					{
						audioMd = new AudioMd();
						audioMd.audioDuration = audioo.duration;
						audioMd.audioName = audioo.name;
						audioMd.audioSize = audioo.size;
						audioMd.audioUrl = audioo.audio;
						pointMd.pointAudioArray.push(audioMd);
					}
					pointMd.pointType = pointo.type_cd;
					if(pointMd.pointType)
					{
						routeMd.routeOtherPointArray.push(pointMd);
					}else{
						routeMd.routePointArray.push(pointMd);
					}
				}
				routeArray.push(routeMd);
			}
			
			//parse note
			noteArray = new Array();
			var noteMd:NoteMd;
			for each(var notoo:Object in data.notes)
			{
				noteMd = new NoteMd();
				noteMd.noteAuthor = notoo.author;
				noteMd.noteIcon = notoo.icon;
				noteMd.noteSource = notoo.source;
				noteMd.noteTitle = notoo.title;
				noteMd.noteSubtitle = notoo.subtitle;
				noteMd.noteTime = notoo.time;
				var noteArMd:NoteArticleMd;
				noteMd.noteArticlesArr = new Array();
				for each(var naro:Object in notoo.articles)
				{
					noteArMd = new NoteArticleMd();
					noteArMd.articleDsc = naro.desc;
					noteArMd.articleIcon = naro.icon;
					noteArMd.articlTitle = naro.title;
					noteMd.noteArticlesArr.push(noteArMd);
				}
				noteArray.push(noteMd);
			}
			
			dispatchEvent(new Event(LOAD_COMPLETE_MAP));
	
		}
		
		private var recomendArray:Array;
		private var infoArray:Array;
		public function parseInfoJson(data:Object):void
		{
			//parse lark
			recomendArray = new Array();
			var larkArr:Array = data.larks;
			var recomendMd:RecomendMd;
			for each(var o:Object in larkArr)
			{
				recomendMd = new RecomendMd();
				recomendMd.recomendId = o.id;
				recomendMd.recomendTitle = o.title;
				recomendMd.recomendValidity = o.validity;
				recomendMd.recomendPhone = o.phone;
				recomendMd.recomendAddress = o.address;
				recomendMd.recomendDesc = o.desc;
				recomendMd.recomendPosition = o.ios_position;
				recomendMd.recomendIcon = o.icon;
				recomendArray.push(recomendMd);
			}
			
			//parse info
			infoArray = new Array();
			var infoArr:Array = data.informs.tip;
			var infoMd:InfoMd;
			for(var j:int = 0;j<9;j++)
			{
				infoArray.push("");
			}
			
			for each(var infoO:Object in infoArr)
			{
				infoMd = new InfoMd();
				infoMd.infoTipTitle = infoO.title;
				infoMd.infoTipType = infoO.tip_type_cd;
				infoMd.infoTipSource = infoO.source;
				infoMd.infoTipArticArray = new Array();
				var infoArticMd:InfoArticlMd;
				for each(var arO:Object in infoO.articles)
				{
					infoArticMd = new InfoArticlMd();
					infoArticMd.articlTitle = arO.title;
					infoArticMd.articlDesc = arO.desc;
					infoArticMd.articlIcon = arO.icon;
					infoMd.infoTipArticArray.push(infoArticMd);
				}
				infoArray[infoMd.infoTipType] = infoMd;
			}
			//parse advertise
			
			dispatchEvent(new Event(LOAD_COMPLETE_INFO));
			
		}
		public function getRouteData():Array
		{
			return routeArray;
		}
		public function getVisitsData():Array
		{
			return visitArray;
		}
		public function getVideosData():Array
		{
			return videosArray;
		}
		public function getPictureData():Array
		{
			return pictureArray;
		}
		public function getSpotAllInfoData():SpotMd
		{
			return spotAllInfo;
		}
		public function getRecomendData():Array
		{
			return recomendArray;
		}
		public function getInfoData():Array
		{
			return infoArray;
		}
		public function getNoteData():Array
		{
			return noteArray;
		}
		public function getAllSoptsName():Array
		{
			return spotsNameArray;
		}
	}
}