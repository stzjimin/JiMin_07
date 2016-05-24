package
{
	public class FillManager
	{
		public static const BLOCK_NULL:String = "blockNull";
		public static const CELL_NULL:String = "cellNull";
		public static const SUCCES_SWAP:String = "succesSwap";
		
		private var _blankedCells:Vector.<Cell>;
		
		public function FillManager()
		{
			
		}
		
		public function init():void
		{
			_blankedCells = new Vector.<Cell>();
		}
		
		public function addCell(cell:Cell):void
		{
			_blankedCells.push(cell);
		}
		
		public function fill():void
		{
			var cell:Cell;
			var result:String;
			while(_blankedCells.length != 0)
			{
				cell = _blankedCells.shift();
				result = cell.fillBlock();
				if(result == FillManager.CELL_NULL)
				{
					trace("a");
				}
				else if(result == FillManager.SUCCES_SWAP)
				{
					trace("b");
					_blankedCells.push(cell.neigbor[NeigborType.TOP]);
				}
				else if(result == FillManager.BLOCK_NULL)
				{
					trace("c");
					_blankedCells.push(cell);
				}
			}
		}
	}
}