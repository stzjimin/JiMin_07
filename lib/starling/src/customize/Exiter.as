package customize
{
	import flash.desktop.NativeApplication;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;

	public class Exiter
	{
		private static var _instance:Exiter;
		
		private var _exitFunctions:Vector.<Function>;
		
		public function Exiter()
		{
			if (!_instance)
			{
				_instance = this;
				_exitFunctions = new Vector.<Function>();
				NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onExit);
			}
			else
			{
				throw new IllegalOperationError("Exiter가 이미 만들어져있습니다. Exiter는 싱글톤 클래스에요!!");
			}
		}
		
		public static function getInstance():Exiter
		{
			return _instance ? _instance : new Exiter();
		}
		
		public function addExitFunction(exitFunction:Function):void
		{
			_exitFunctions.push(exitFunction);
		}
		
		public function removeExitFunction(exitFunction:Function):void
		{
			_exitFunctions.removeAt(_exitFunctions.indexOf(exitFunction));
		}
		
		private function onExit(event:Event):void
		{
			trace("exit");
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit);
			
			if(!_exitFunctions || _exitFunctions.length == 0)
				return;
			
			var exitFunction:Function;
			for(var i:int = 0; i < _exitFunctions.length; i++)
			{
				exitFunction = _exitFunctions[i];
				exitFunction();
			}
			exitFunction = null;
		}
	}
}