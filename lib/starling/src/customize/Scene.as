package customize
{
	import starling.display.DisplayObjectContainer;
	import starling.events.EnterFrameEvent;

	public class Scene extends DisplayObjectContainer
	{	
		private var _key:String;
		private var _data:Object;
		
		public function Scene()
		{
			addEventListener(SceneEvent.CREATE, onCreate);
			addEventListener(SceneEvent.START, onStart);
			addEventListener(EnterFrameEvent.ENTER_FRAME, onUpdate);
			addEventListener(SceneEvent.END, onEnded);
			addEventListener(SceneEvent.DESTROY, onDestroy);
			
			addEventListener(SceneEvent.ACTIVATE, onActivate);
			addEventListener(SceneEvent.DEACTIVATE, onDeActivate);
		}
		
		/**
		 * 씬이 메니저에 올라간 후 처음 실행될때 SceneEvent.CREATE이벤트를 받고 호출되는 함수 
		 * @param event
		 * 
		 */		
		protected function onCreate(event:SceneEvent):void
		{
			
		}
		
		/**
		 * SceneEvent.START이벤트를 받게되면 호출되는 함수 
		 * @param event
		 * 
		 */		
		protected function onStart(event:SceneEvent):void
		{
			this.visible = true;
		}
		
		/**
		 * SceneEvent.END이벤트를 받게도면 호출되는 함수
		 * @param event
		 * 
		 */		
		protected function onEnded(event:SceneEvent):void
		{
			this.visible = false;
		}
		
		/**
		 * EnterFrameEvent.ENTER_FRAME이벤트를 받게되면 호출되는 함수 
		 * @param event
		 * 
		 */		
		protected function onUpdate(event:EnterFrameEvent):void
		{
			
		}
		
		/**
		 * 씬이 삭제될때 SceneEvent.DESTROY를 받게되면 호출되는 함수
		 * @param event
		 * 
		 */		
		protected function onDestroy(event:SceneEvent):void
		{
			removeEventListener(SceneEvent.CREATE, onCreate);
			removeEventListener(SceneEvent.START, onStart);
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onUpdate);
			removeEventListener(SceneEvent.END, onEnded);
			removeEventListener(SceneEvent.DESTROY, onDestroy);
			
			removeEventListener(SceneEvent.ACTIVATE, onActivate);
			removeEventListener(SceneEvent.DEACTIVATE, onDeActivate);
			
			dispose();
		}
		
		/**
		 * 게임이 엑티브될때 호출됩니다.
		 * @param event
		 * 
		 */
		protected function onActivate(event:SceneEvent):void
		{
			
		}
		
		/**
		 * 게임이 디엑티브될대 호출됩니다. 
		 * @param event
		 * 
		 */		
		protected function onDeActivate(event:SceneEvent):void
		{
			
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