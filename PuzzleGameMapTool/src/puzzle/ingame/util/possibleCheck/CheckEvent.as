package puzzle.ingame.util.possibleCheck
{
	import starling.events.Event;

	public class CheckEvent extends Event
	{
		public static const CHECKED_COMPLETE:String = "checkedComplete";
		
		private var _blockCount:uint;
		private var _possibleCount:uint;
		
		public function CheckEvent(type:String, blockCount:uint = 0, possibleCount:uint = 0, bubbles:Boolean = false)
		{
			_blockCount = blockCount;
			_possibleCount = possibleCount;
			
			super(type, bubbles);
		}
		
		public function get blockCount():uint
		{
			return _blockCount;
		}

		public function set blockCount(value:uint):void
		{
			_blockCount = value;
		}

		public function get possibleCount():uint
		{
			return _possibleCount;
		}

		public function set possibleCount(value:uint):void
		{
			_possibleCount = value;
		}
	}
}