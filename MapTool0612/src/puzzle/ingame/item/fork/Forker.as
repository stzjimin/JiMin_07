package puzzle.ingame.item.fork
{
	import puzzle.ingame.cell.Cell;
	import puzzle.ingame.cell.blocks.Block;
	
	import starling.events.EventDispatcher;

	public class Forker extends EventDispatcher
	{
		public static const GET_FORK:String = "getForked";
		
		public function Forker()
		{
			
		}
		
		public function fork(selectBlock:Block, cells:Vector.<Cell>):void
		{	
			for(var i:int = 0; i < cells.length; i++)
			{
				if(cells[i].block == null || cells[i].block == selectBlock)
					continue;
				if(cells[i].block.type == selectBlock.type)
				{
					trace(Cell(selectBlock.parent).name);
					trace(cells[i].name);
					var forkEvent:ForkEvent = new ForkEvent(Forker.GET_FORK);
					forkEvent.succeed = true;
					forkEvent.selectedBlock = selectBlock;
					forkEvent.targetBlock = cells[i].block;
					dispatchEvent(forkEvent);
					break;
				}
			}
		}
	}
}