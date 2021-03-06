package customize
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObjectContainer;

	public class SceneManager extends DisplayObjectContainer
	{
		private static var _current:SceneManager;
		
		private var _sceneDic:Dictionary;
		private var _sceneVector:Vector.<Scene>;
		private var _currentScene:Scene;
		
		public function SceneManager()
		{
			if(_current != null)
				throw new IllegalOperationError("SceneManager는 Starling생성자를 통해서만 생성해주세요!!");
			_current = this;
		}
		
		public function init():void
		{
			trace("sceneManager init");
			_sceneDic = new Dictionary();
			_sceneVector = new Vector.<Scene>();
			
			addEventListener(SceneEvent.ACTIVATE, onActivate);
			addEventListener(SceneEvent.DEACTIVATE, onDeActivate);
		}
		
		public function destroy():void
		{
			for(var key:String in _sceneDic)
				delete _sceneDic[key];
			_sceneDic = null;
			
			for(var i:int = 0; i < _sceneVector.length; i++)
			{
				Scene(_sceneVector[i]).dispatchEvent(new SceneEvent(SceneEvent.END));
				Scene(_sceneVector[i]).dispatchEvent(new SceneEvent(SceneEvent.DESTROY));
			}
			_sceneVector.splice(0, _sceneVector.length);
			
			if(_currentScene)
			{
				_currentScene.dispatchEvent(new SceneEvent(SceneEvent.END));
				_currentScene.dispatchEvent(new SceneEvent(SceneEvent.DESTROY));
			}
			
			removeEventListener(SceneEvent.ACTIVATE, onActivate);
			removeEventListener(SceneEvent.DEACTIVATE, onDeActivate);
			
			_current = null;
		}
		
		public function addScene(sceneClass:Class, key:String):void
		{
			if(key == null)
				return;
			
			if(_sceneDic == null)
				_sceneDic = new Dictionary();
			
			var scene:Scene = new sceneClass() as Scene;
			scene.key = key;
			_sceneDic[key] = scene;
		}
		
		public function deleteScene(key:String):void
		{
			if(_sceneDic == null || _sceneDic[key] == null)
				return;
			
			_sceneDic[key].dispatchEvent(new SceneEvent(SceneEvent.DESTROY));
			delete _sceneDic[key];
		}
		
		public function goScene(key:String, data:Object = null):void
		{
			if(_sceneDic == null || _sceneDic[key] == null)
				return;
			
			if(_sceneVector == null)
				_sceneVector = new Vector.<Scene>();
			
			if(_currentScene != null)
			{
				_currentScene.dispatchEvent(new SceneEvent(SceneEvent.END));
				_sceneVector.push(_currentScene);
				removeChild(_currentScene);
			}
			
			var scene:Scene = _sceneDic[key];
			if(data != null)
				scene.data = Copy.clone(data);
			scene.dispatchEvent(new SceneEvent(SceneEvent.CREATE));
			addChild(scene);
			_currentScene = scene;
		}
		
		public function outScene(data:Object = null):void
		{
			if(_sceneVector == null || _sceneVector.length == 0)
				return;
			
			var scene:Scene = _sceneVector.pop();
			
			if(_sceneDic == null || _sceneDic[scene.key] == null)
				return;
			
			if(_currentScene != null)
			{
				removeChild(_currentScene);
				_currentScene.dispatchEvent(new SceneEvent(SceneEvent.END));
				deleteScene(_currentScene.key);
			}
			
			if(data != null)
				scene.data = Copy.clone(data);
			addChild(scene);
			_currentScene = scene;
			scene.dispatchEvent(new SceneEvent(SceneEvent.START));
		}
		
		public function switchScene(key:String, data:Object = null):void
		{
			if(_sceneDic == null || _sceneDic[key] == null)
				return;
			
			if(_currentScene != null)
			{
				removeChild(_currentScene);
				_currentScene.dispatchEvent(new SceneEvent(SceneEvent.END));
				deleteScene(_currentScene.key);
			}
			
			var scene:Scene = _sceneDic[key];
			if(data != null)
				scene.data = Copy.clone(data);
			scene.dispatchEvent(new SceneEvent(SceneEvent.CREATE));
			addChild(scene);
			_currentScene = scene;
		}
		
		private function onActivate(event:SceneEvent):void
		{
			trace("activate");
			trace("_currentScene.name = " + _currentScene.name);
			_currentScene.dispatchEvent(new SceneEvent(SceneEvent.ACTIVATE));
//			if(getChildIndex(_currentScene) < 0)
//				addChild(_currentScene);
		}
		
		private function onDeActivate(event:SceneEvent):void
		{
			trace("deactivate");
			trace("_currentScene.name = " + _currentScene.name);
			_currentScene.dispatchEvent(new SceneEvent(SceneEvent.DEACTIVATE));
//			if(getChildIndex(_currentScene) >= 0)
//				removeChild(_currentScene);
		}

		public static function get current():SceneManager
		{
			return _current;
		}
	}
}