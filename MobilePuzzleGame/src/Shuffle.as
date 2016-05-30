package
{
	import ingame.cell.Cell;
	import ingame.cell.blocks.Block;
	
	import starling.events.EventDispatcher;

	public class Shuffle extends EventDispatcher
	{
		private var _isBlockCells:Vector.<Cell>;
		private var _blockStack:Vector.<Block>;
		
		public function Shuffle()
		{
			
		}
		
		public function init():void
		{
			if(_isBlockCells != null)
				_isBlockCells.splice(0, _isBlockCells.length);
			
			_isBlockCells = new Vector.<Cell>();
		}
		
		public function shuffle(cells:Vector.<Cell>):void
		{
			
		}
	}
}