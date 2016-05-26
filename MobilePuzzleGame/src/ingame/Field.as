package ingame
{	
	import flash.display.Bitmap;
	import flash.utils.getTimer;
	
	import ingame.cell.Cell;
	import ingame.cell.NeigborType;
	import ingame.util.Distroyer;
	import ingame.util.possibleCheck.CheckEvent;
	import ingame.util.possibleCheck.Possible;
	import ingame.util.possibleCheck.PossibleChecker;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Field extends DisplayObjectContainer
	{
		[Embed(source="testBackGroundImage2.jpg")]
		private const testBackGroundImage:Class;
		
		public static const ROW_NUM:uint = 12;
		public static const COLUM_NUM:uint = 12;
		
		private var _backGround:Image;
		
		private var _cells:Vector.<Cell>;
		private var _distroyer:Distroyer;
		
		private var _possibleChecker:PossibleChecker;
		
		public function Field()
		{
//			init();
		}
		
		public function init():void
		{	
			_distroyer = new Distroyer();
			_possibleChecker = new PossibleChecker();
			_possibleChecker.init();
			_possibleChecker.addEventListener(CheckEvent.SAME, onSame);
//			_distroyer.addEventListener(Distroyer.COMPLETE_DISTROY, onCompleteDistroy);
			
			_backGround = new Image(Texture.fromBitmap(new testBackGroundImage() as Bitmap));
			_backGround.width = Field.ROW_NUM * Cell.CELL_WIDTH_SIZE;
			_backGround.height = Field.COLUM_NUM * Cell.CELL_HEIGHT_SIZE;
			addChild(_backGround);
			
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
				cell.row = colum;
				cell.colum = row;
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
		}
		
		/**
		 *_cells안에서 연결가능한 블록들을 찾아내는 함수 
		 * 
		 */		
		public function checkPossibleCell():void
		{
			var prevTime:Number = getTimer() / 1000;
			_possibleChecker.checkPossibleCell(_cells);
			var currentTime:Number = getTimer() / 1000;
			trace("경과시간 = " + (currentTime - prevTime));
			trace("가능 개수 = " + _possibleChecker.possibleCount);
		}
			
		public function initPossibleChecker():void
		{
			_possibleChecker.init();
		}
		
		/**
		 *Field를 제거하는 함수 
		 * 
		 */		
		public function distroy():void
		{
			for(var i:int = 0; i < _cells.length; i++)
			{
				_cells[i].removeEventListener(CheckEvent.ADD_PREV, onAddPrev);
				_cells[i].removeEventListener(CheckEvent.OUT_CHECKER, onOutChecker);
				_cells[i].distroy();
				_cells[i].removeFromParent(true);
				_cells[i] = null;
			}
			_cells.splice(0, _cells.length);
			_cells = null;
			_possibleChecker.removeEventListener(CheckEvent.SAME, onSame);
			_possibleChecker.distroy();
			_possibleChecker = null;
			_backGround.removeFromParent(true);
			_backGround = null;
		}
		
		private function onSame(event:Event):void
		{
			var possible:Possible = event.data as Possible;
			_distroyer.add(possible.startCell.block);
			_distroyer.add(possible.destCell.block);
			var path:Vector.<Cell> = possible.path;
			
			showPath(possible);
			possible.distroy();
			
			_distroyer.distroy();
			_possibleChecker.init();
			checkPossibleCell();
//			_pathChecker.checkPossibleCell(_cells);
		}
		
		private function showPath(possible:Possible):void
		{
			var fullPath:Vector.<Cell> = new Vector.<Cell>();
			
			possible.path.insertAt(0, possible.startCell);
			possible.path.push(possible.destCell);
			
			for(var i:int = 0; i < possible.path.length-1; i++)
				fullPath.concat(getLine(possible.path[i], possible.path[i+1]));
			
			var cell:Cell;
			trace("fullPath.length = " + fullPath.length);
			while(fullPath.length != 0)
			{
				cell = fullPath.shift();
				cell.showColor();
			}
		}
		
		private function getLine(cell1:Cell, cell2:Cell):Vector.<Cell>
		{
			var result:Vector.<Cell> = new Vector.<Cell>();
			
			var searchCell:Cell = cell1;
			if(cell1.row == cell2.row)
			{
				if(cell1.colum > cell2.colum)
				{
					trace("cell1.colum = " + cell1.colum)
					trace("cell2.colum = " + cell2.colum)
					searchCell = cell1.neigbor[NeigborType.TOP];
					while(searchCell != cell2)
					{
//						trace("a");
						searchCell = cell1.neigbor[NeigborType.TOP];
						result.push(searchCell);
					}
				}
				else
				{
					searchCell = cell1.neigbor[NeigborType.BOTTOM];
					while(searchCell != cell2)
					{
						trace("b");
						searchCell = cell1.neigbor[NeigborType.BOTTOM];
						result.push(searchCell);
					}
				}
			}
			else if(cell1.colum == cell2.colum)
			{
				if(cell1.row > cell2.row)
				{
					searchCell = cell1.neigbor[NeigborType.RIGHT];
					while(searchCell != cell2)
					{
						trace("c");
						searchCell = cell1.neigbor[NeigborType.RIGHT];
						result.push(searchCell);
					}
				}
				else
				{
					searchCell = cell1.neigbor[NeigborType.LEFT];
					while(searchCell != cell2)
					{
						trace("d");
						searchCell = cell1.neigbor[NeigborType.LEFT];
						result.push(searchCell);
					}
				}
			}
			
			return result;
		}
		
		private function onAddPrev(event:Event):void
		{
			trace(Cell(event.currentTarget).row);
			trace(Cell(event.currentTarget).block.attribute.type);
			_possibleChecker.setPrev(event.currentTarget as Cell);
		}
		
		private function onOutChecker(event:Event):void
		{
			_possibleChecker.outChecker(event.currentTarget as Cell);
		}
		
		public function getCell(row:uint, colum:uint):Cell
		{
			return _cells[colum+(ROW_NUM*row)];
		}
	}
}