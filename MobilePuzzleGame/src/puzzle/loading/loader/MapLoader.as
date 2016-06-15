package puzzle.loading.loader
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import puzzle.loading.LoadingEvent;
	import puzzle.loading.StringHelper;
	
	import starling.events.EventDispatcher;

	public class MapLoader extends EventDispatcher
	{
		private var _stageNumber:int;
		private var _urlLoader:URLLoader;
		
		public function MapLoader(stageNumber:int)
		{
			_stageNumber = stageNumber;	
		}
		
		public function load():void
		{
			var urlRequest:URLRequest = new URLRequest(DBLoader.SEVER_URL + "/mapData/stage" + _stageNumber + ".json");
			_urlLoader = new URLLoader(urlRequest);
			_urlLoader.addEventListener(Event.COMPLETE, onCompleteLoaded);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoaded);
			_urlLoader.load(urlRequest);
		}
		
		private function onCompleteLoaded(event:Event):void
		{
			_urlLoader.addEventListener(Event.COMPLETE, onCompleteLoaded);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoaded);
			
			trace(_urlLoader.dataFormat);
			trace(_urlLoader.bytesTotal);
			trace(_urlLoader.data);
			trace(String(_urlLoader.data));
			
//			var mapString:String = StringHelper.unescapeString(String(_urlLoader.data));
			var mapString:String = String(_urlLoader.data).substring(2, String(_urlLoader.data).length);
			trace(mapString);
			
			dispatchEvent(new LoadingEvent(LoadingEvent.COMPLETE, mapString));
		}
		
		private function onFailedLoaded(event:IOErrorEvent):void
		{
			_urlLoader.addEventListener(Event.COMPLETE, onCompleteLoaded);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onFailedLoaded);
			
			dispatchEvent(new LoadingEvent(LoadingEvent.FAILED, event.text));
		}
	}
}