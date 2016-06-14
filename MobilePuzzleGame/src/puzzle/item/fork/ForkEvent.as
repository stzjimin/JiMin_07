package puzzle.item.fork
{
	import puzzle.ingame.cell.blocks.Block;
	
	import starling.events.Event;

	public class ForkEvent extends Event
	{
		private var _succeed:Boolean;
		private var _selectedBlock:Block;
		private var _targetBlock:Block;
		
		public function ForkEvent(type:String, bubbles:Boolean = false)
		{
			super(type, bubbles);
		}

		public function get succeed():Boolean
		{
			return _succeed;
		}

		public function set succeed(value:Boolean):void
		{
			_succeed = value;
		}

		public function get selectedBlock():Block
		{
			return _selectedBlock;
		}

		public function set selectedBlock(value:Block):void
		{
			_selectedBlock = value;
		}

		public function get targetBlock():Block
		{
			return _targetBlock;
		}

		public function set targetBlock(value:Block):void
		{
			_targetBlock = value;
		}


	}
}