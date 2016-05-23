package
{	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class Field extends DisplayObjectContainer
	{
		public static const CELL_SIZE:Number = 125;
		public static const ROW_NUM:uint = 7;
		public static const COLUM_NUM:uint = 7;
		
		private var _cells:Array;
		private var _distroyer:Distroyer;
		
		public function Field()
		{
			init();
		}
		
		public function init():void
		{
			_distroyer = new Distroyer();
			_distroyer.addEventListener(Distroyer.COMPLETE_DISTROY, onCompleteDistroy);
			
			_cells = new Array();
			for(var i:int = 0; i < COLUM_NUM; i++)
			{
				var row:Array = new Array();
				_cells.push(row);
				for(var j:int = 0; j < ROW_NUM; j++)
				{
					var cell:Cell = new Cell();
					cell.addEventListener(Distroyer.ADD_DISTROYER, onAddDistroyer);
					cell.addEventListener(SwapType.COMPLETE_SWAP, onCompleteSwap);
					cell.width = cell.height = CELL_SIZE;
					cell.y = i * CELL_SIZE;
					cell.x = j * CELL_SIZE;
					cell.init();
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
			
			addEventListener("testButton", onTriggeredTestButton);
		}
		
		private function onCompleteDistroy(event:Event):void
		{
			
		}
		
		private function onTriggeredTestButton(event:Event):void
		{
			_distroyer.distroy();
		}
		
		private function onCompleteSwap(event:Event):void
		{
			trace("a");
//			_distroyer.distroy();
		}
		
		private function onAddDistroyer(event:Event):void
		{
			_distroyer.add(event.data as Block);
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