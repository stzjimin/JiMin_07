package
{
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class Distroyer extends EventDispatcher
	{
		public static const ADD_DISTROYER:String = "addDistroyer";
		public static const DISTROY:String = "distroy";
		public static const COMPLETE_DISTROY:String = "completeDistroy";
		
		private var _blocks:Vector.<Block>;
		
		public function Distroyer()
		{
			init();
		}
		
		public function init():void
		{
			if(_blocks != null)
				_blocks.splice(0, _blocks.length);
			_blocks = new Vector.<Block>();
		}
		
		public function add(block:Block):void
		{
			_blocks.push(block);
			block.distroyed = true;
		}
		
		public function distroy():void
		{
			var block:Block;
			for(var i:int = 0; i < _blocks.length; i++)
			{
				block = _blocks[i];
				block.distroy();
			}
			init();
			dispatchEvent(new Event(Distroyer.COMPLETE_DISTROY));
		}
	}
}