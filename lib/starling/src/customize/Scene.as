package customize
{
	import starling.display.DisplayObjectContainer;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;

	public class Scene extends DisplayObjectContainer
	{
		public static const START:String = "sceneStart";
		public static const END:String = "sceneEnd";
		
		private var _key:String;
		private var _data:Object;
		
		public function Scene()
		{
			addEventListener(Scene.START, onStart);
			addEventListener(Scene.END, onEnded);
			addEventListener(EnterFrameEvent.ENTER_FRAME, onUpdate);
		}
		
		protected virtual function onStart(event:Event):void
		{
			this.visible = true;
		}
		
		protected virtual function onEnded(event:Event):void
		{
			this.visible = false;
		}
		
		protected virtual function onUpdate(event:EnterFrameEvent):void
		{
			
		}
		
		public function distroy():void
		{
			removeEventListener(Scene.START, onStart);
			removeEventListener(Scene.END, onEnded);
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onUpdate);
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		public function get key():String
		{
			return _key;
		}

		public function set key(value:String):void
		{
			_key = value;
		}


	}
}