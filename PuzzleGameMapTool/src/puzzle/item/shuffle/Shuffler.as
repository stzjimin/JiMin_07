package puzzle.item.shuffle
{
	import puzzle.ingame.cell.Cell;
	import puzzle.ingame.cell.blocks.Block;
	import puzzle.ingame.cell.blocks.BlockType;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class Shuffler extends EventDispatcher
	{
		public static const COMPLETE:String = "completeShuffle";
		
		private var _isBlockCells:Vector.<Cell>;
		private var _blockStack:Vector.<Block>;
		
		public function Shuffler()
		{
			
		}
		
		public function init():void
		{
			if(_isBlockCells != null)
				_isBlockCells.splice(0, _isBlockCells.length);
			
			if(_blockStack != null)
				_blockStack.splice(0, _blockStack.length);
			
			_isBlockCells = new Vector.<Cell>();
			_blockStack = new Vector.<Block>();
		}
		
		public function shuffle(cells:Vector.<Cell>):void
		{
			for(var i:int = 0; i < cells.length; i++)
			{
				if(cells[i].block == null || cells[i].block.type == BlockType.WALL)
					continue;
				
				_isBlockCells.push(cells[i]);
				_blockStack.push(cells[i].block);
				cells[i].block.removeFromParent();
				cells[i].block = null;
			}
			trace(_isBlockCells.length);
			
			var block:Block;
			var cell:Cell;
			var randIndex:int;
			while(_blockStack.length != 0)
			{
				randIndex = ((Math.random() * 100) % _blockStack.length);
				trace(randIndex);
				block = _blockStack.removeAt(randIndex);
				cell = _isBlockCells.shift();
				
				cell.addBlock(block);
			}
			dispatchEvent(new Event(Shuffler.COMPLETE));
		}
	}
}