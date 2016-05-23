package
{
	import starling.display.DisplayObjectContainer;

	public class Field extends DisplayObjectContainer
	{
		public static const CELL_SIZE:Number = 95;
		public static const ROW_NUM:uint = 9;
		public static const COLUM_NUM:uint = 9;
		
		private var _cells:Array;
		
		public function Field()
		{
			_cells = new Array();
			for(var i:int = 0; i < COLUM_NUM; i++)
			{
				var row:Array = new Array();
				_cells.push(row);
				for(var j:int = 0; j < ROW_NUM; j++)
				{
					var cell:Cell = new Cell();
					cell.width = cell.height = CELL_SIZE;
					cell.y = i * CELL_SIZE;
					cell.x = j * CELL_SIZE;
					addChild(cell);
					row.push(cell);
					if(i != 0)
					{
						_cells[i][j].neigbor[NeigborType.TOP] = _cells[i-1][j];
						_cells[i-1][j].neigbor[NeigborType.BOTTOM] = _cells[i][j];
					}
					if(j != 0)
					{
						_cells[i][j].neigbor[NeigborType.LEFT] = _cells[i][j-1];
						_cells[i][j-1].neigbor[NeigborType.RIGHT] = _cells[i][j];
					}
				}
			}
		}
		
//		public function get cells():Array
//		{
//			return _cells;
//		}
//
//		public function set cells(value:Array):void
//		{
//			_cells = value;
//		}

		public function getCell(colum:uint, row:uint):Cell
		{
			return _cells[colum][row];
		}
	}
}