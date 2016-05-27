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
		
		private static var _sROW_NUM:uint;
		private static var _sCOLUM_NUM:uint;
		
		private var _backGround:Image;
		
		private var _cells:Vector.<Cell>;
		private var _distroyer:Distroyer;
		
		private var _possibleChecker:PossibleChecker;
		
		public function Field(rowNum:uint = 12, columNum:uint = 12)
		{
			_sROW_NUM = rowNum;
			_sCOLUM_NUM = columNum;
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
			var columNum:int = 0;
			for(var i:int = 0; i < COLUM_NUM*ROW_NUM; i++)
			{
				var cell:Cell = new Cell();
				var rowNum:int = i%ROW_NUM;
				_cells.push(cell);
				cell.addEventListener(CheckEvent.ADD_PREV, onAddPrev);
				cell.addEventListener(CheckEvent.OUT_CHECKER, onOutChecker);
				cell.width = Cell.CELL_WIDTH_SIZE;
				cell.height = Cell.CELL_HEIGHT_SIZE;
				cell.x = columNum * Cell.CELL_WIDTH_SIZE;
				cell.y = rowNum * Cell.CELL_HEIGHT_SIZE;
				cell.row = rowNum;
				cell.colum = columNum;
				_cells[i].name = rowNum.toString() + "/" + columNum.toString();
				cell.init();
				addChild(cell);
				if(columNum != 0)
				{
					_cells[i].neigbor[NeigborType.LEFT] = _cells[i-ROW_NUM];
					_cells[i-ROW_NUM].neigbor[NeigborType.RIGHT] = _cells[i];
				}
				if(rowNum != 0)
				{
					_cells[i].neigbor[NeigborType.TOP] = _cells[i-1];
					_cells[i-1].neigbor[NeigborType.BOTTOM] = _cells[i];
				}
				if(rowNum == (ROW_NUM-1))
					columNum++;
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
			
			var line:Vector.<Cell>;
			for(var i:int = 0; i < possible.path.length-1; i++)
			{
				trace("possible.path[i].name = " + possible.path[i].name);
				trace("possible.path[i+1].name = " + possible.path[i+1].name);
				line = getLine(possible.path[i], possible.path[i+1]);
				fullPath = fullPath.concat(line);
			}
			
			var cell:Cell;
			var prev:Cell;
			var neigborTypes:Vector.<int> = NeigborType.TYPES;
			var direction:int;
			trace("fullPath.length = " + fullPath.length);
			while(fullPath.length != 0)
			{
				cell = fullPath.shift();
				if(prev == cell)
				{
					for(i = 0; i < neigborTypes.length; i++)
					{
						if(cell.neigbor[neigborTypes[i]] == fullPath[0])
						{
							direction = neigborTypes[i];
							break;
						}
					}
					
					trace(direction + "으로 꺾임");
				}
				cell.showColor();
				prev = cell;
			}
			cell = null;
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
					result.push(searchCell);
					searchCell = cell1.neigbor[NeigborType.LEFT];
					result.push(searchCell);
					while(searchCell != cell2)
					{
						trace(searchCell.name);
//						result.push(searchCell);
						searchCell = searchCell.neigbor[NeigborType.LEFT];
						result.push(searchCell);
					}
				}
				else
				{
					result.push(searchCell);
					searchCell = cell1.neigbor[NeigborType.RIGHT];
					result.push(searchCell);
					while(searchCell != cell2)
					{
						trace(searchCell.name);
//						result.push(searchCell);
						searchCell = searchCell.neigbor[NeigborType.RIGHT];
						result.push(searchCell);
					}
				}
			}
			else if(cell1.colum == cell2.colum)
			{
				if(cell1.row > cell2.row)
				{
					result.push(searchCell);
					searchCell = cell1.neigbor[NeigborType.TOP];
					result.push(searchCell);
					while(searchCell != cell2)
					{
						trace(searchCell.name);
//						result.push(searchCell);
						searchCell = searchCell.neigbor[NeigborType.TOP];
						result.push(searchCell);
					}
				}
				else
				{
					result.push(searchCell);
					searchCell = cell1.neigbor[NeigborType.BOTTOM];
					result.push(searchCell);
					while(searchCell != cell2)
					{
						trace(searchCell.name);
//						result.push(searchCell);
						searchCell = searchCell.neigbor[NeigborType.BOTTOM];
						result.push(searchCell);
					}
				}
			}
			
			trace("result.length = " + result.length)
			
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

		public static function get ROW_NUM():uint
		{
			return _sROW_NUM;
		}

		public static function get COLUM_NUM():uint
		{
			return _sCOLUM_NUM;
		}


	}
}