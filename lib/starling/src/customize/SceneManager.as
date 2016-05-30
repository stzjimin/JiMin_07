package customize
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

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
			_sceneDic = new Dictionary();
			_sceneVector = new Vector.<Scene>();
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
			
			_sceneDic[key].dispatchEvent(new Event(Scene.END));
			_sceneDic[key].destroy();
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
				_currentScene.dispatchEvent(new Event(Scene.END));
				_sceneVector.push(_currentScene);
				removeChild(_currentScene);
			}
			
			var scene:Scene = _sceneDic[key];
			if(data != null)
				scene.data = Copy.clone(data);
			scene.dispatchEvent(new Event(Scene.START));
			addChild(scene);
			_currentScene = scene;
		}
		
		public function outScene(data:Object = null):void
		{
			if(_sceneVector == null || _sceneVector.length == 0)
				return;
			
			var scene:Scene = _sceneVector.pop();
			switchScene(scene.key, data);
		}
		
		public function switchScene(key:String, data:Object = null):void
		{
			if(_sceneDic == null || _sceneDic[key] == null)
				return;
			
			if(_currentScene != null)
			{
				removeChild(_currentScene);
				deleteScene(_currentScene.key);
			}
			
			var scene:Scene = _sceneDic[key];
			if(data != null)
				scene.data = Copy.clone(data);
			scene.dispatchEvent(new Event(Scene.START));
			addChild(scene);
			_currentScene = scene;
		}

		public static function get current():SceneManager
		{
			return _current;
		}

	}
}