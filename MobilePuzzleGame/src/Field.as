package
{	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class Field extends DisplayObjectContainer
	{
		public static const ROW_NUM:uint = 10;
		public static const COLUM_NUM:uint = 10;
		
		private var _cells:Vector.<Cell>;
		private var _arrayCells:Array;
		private var _distroyer:Distroyer;
		
		private var _finAniQueue:Array = new Array();
		private var _moveBlock:uint = 0;
		private var _movedBlock:uint = 0;
		
		private var _pathChecker:PathChecker;
		
		public function Field()
		{
			init();
		}
		
		public function init():void
		{
			_distroyer = new Distroyer();
			_pathChecker = new PathChecker();
			_pathChecker.addEventListener(CheckEvent.SAME, onSame);
//			_distroyer.addEventListener(Distroyer.COMPLETE_DISTROY, onCompleteDistroy);
			
			_cells = new Vector.<Cell>();
			var colum:int = 0;
			for(var i:int = 0; i < COLUM_NUM*ROW_NUM; i++)
			{
				var cell:Cell = new Cell();
				var row:int = i%ROW_NUM;
				_cells.push(cell);
				cell.addEventListener(CheckEvent.ADD_PREV, onAddPrev);
				cell.addEventListener(CheckEvent.OUT_CHECKER, onOutChecker);
				cell.width = Cell.CELL_WIDTH_SIZE;
				cell.height = Cell.CELL_HEIGHT_SIZE;
				cell.x = colum * Cell.CELL_WIDTH_SIZE;
				cell.y = row * Cell.CELL_HEIGHT_SIZE;
				cell.row = row;
				cell.colum = colum;
				_cells[i].name = row.toString() + "/" + colum.toString();
				cell.init();
				addChild(cell);
				if(colum != 0)
				{
					_cells[i].neigbor[NeigborType.TOP] = _cells[i-ROW_NUM];
					_cells[i-ROW_NUM].neigbor[NeigborType.BOTTOM] = _cells[i];
				}
				if(row != 0)
				{
					_cells[i].neigbor[NeigborType.LEFT] = _cells[i-1];
					_cells[i-1].neigbor[NeigborType.RIGHT] = _cells[i];
				}
				if(row == (ROW_NUM-1))
					colum++;
			}
			
//			_arrayCells = new Array();
//			for(var i:int = 0; i < COLUM_NUM; i++)
//			{
//				var row:Array = new Array();
//				_cells.push(row);
//				for(var j:int = 0; j < ROW_NUM; j++)
//				{
//					var cell:Cell = new Cell();
//					cell.addEventListener(CheckEvent.ADD_PREV, onAddPrev);
//					cell.addEventListener(CheckEvent.OUT_CHECKER, onOutChecker);
//					cell.width = Cell.CELL_WIDTH_SIZE;
//					cell.height = Cell.CELL_HEIGHT_SIZE;
//					cell.x = j * Cell.CELL_WIDTH_SIZE;
//					cell.y = i * Cell.CELL_HEIGHT_SIZE;
//					cell.colum = i;
//					cell.row = j;
//					cell.init();
//					addChild(cell);
//					row.push(cell);
//					_cells[i][j].name = j.toString() + "/" + i.toString();
//					if(i != 0)
//					{
//						_cells[i][j].neigbor[NeigborType.TOP] = _cells[i-1][j];
//						_cells[i-1][j].neigbor[NeigborType.BOTTOM] = _cells[i][j];
//					}
//					if(j != 0)
//					{
//						_cells[i][j].neigbor[NeigborType.LEFT] = _cells[i][j-1];
//						_cells[i][j-1].neigbor[NeigborType.RIGHT] = _cells[i][j];
//					}
//				}
//			}
		}
		
		public function checkPossibleCell():void
		{
			_pathChecker.checkPossibleCell(_cells);
		}
		
		public function freeCells():void
		{
			for(var i:int = 0; i < _cells.length; i++)
			{
				_cells[i].splice(0, ROW_NUM);
			}
			_cells.splice(0, _cells.length);
		}
		
		public function distroy():void
		{
			for(var i:int = 0; i < _cells.length; i++)
			{
				_cells[i].removeEventListener(CheckEvent.ADD_PREV, onAddPrev);
				_cells[i].removeEventListener(CheckEvent.OUT_CHECKER, onOutChecker);
				_cells[i].distroy();
			}
		}
		
		private function onSame(event:Event):void
		{
			var array:Array = event.data as Array;
			_distroyer.add(array.shift().block);
			_distroyer.add(array.shift().block);
			_distroyer.distroy();
		}
		
		private function onAddPrev(event:Event):void
		{
			trace(Cell(event.currentTarget).row);
			trace(Cell(event.currentTarget).block.attribute.type);
			_pathChecker.setPrev(event.currentTarget as Cell);
		}
		
		private function onOutChecker(event:Event):void
		{
			_pathChecker.outChecker(event.currentTarget as Cell);
		}
		
		public function getCell(row:uint, colum:uint):Cell
		{
			return _cells[colum+(ROW_NUM*row)];
		}
	}
}