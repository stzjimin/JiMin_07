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
		
		/**
		 * Scene.START이벤트를 받게되면 호출되는 함수 
		 * @param event
		 * 
		 */		
		protected virtual function onStart(event:Event):void
		{
			this.visible = true;
		}
		
		/**
		 * Scene.END이벤트를 받게도면 호출되는 함수
		 * @param event
		 * 
		 */		
		protected virtual function onEnded(event:Event):void
		{
			this.visible = false;
		}
		
		/**
		 * EnterFrameEvent.ENTER_FRAME이벤트를 받게되면 호출되는 함수 
		 * @param event
		 * 
		 */		
		protected virtual function onUpdate(event:EnterFrameEvent):void
		{
			
		}
		
		/**
		 * 씬을 삭제하는 함수(SceneManager에서 deleteScene을하게되면 호출됩니다)
		 * 
		 */		
		public function destroy():void
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