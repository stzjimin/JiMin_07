package ingame
{	
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import ingame.cell.Cell;
	import ingame.cell.NeigborType;
	import ingame.cell.blocks.BlockData;
	import ingame.util.possibleCheck.CheckEvent;
	import ingame.util.possibleCheck.Possible;
	import ingame.util.possibleCheck.PossibleChecker;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Field extends Sprite implements IAnimatable
	{	
		[Embed(source="testBackGroundImage2.jpg")]
		private const testBackGroundImage:Class;
		
		[Embed(source="rowLine.png")]
		private const rowLineImage:Class;
		
		[Embed(source="columLine.png")]
		private const columLineImage:Class;
		
		private static var _sROW_NUM:uint;
		private static var _sCOLUM_NUM:uint;
		
		private var _juggler:Juggler;
		
		private var _backGround:Image;
		
		private var _cells:Vector.<Cell>;
		
		private var _possibleChecker:PossibleChecker;
		
		public function Field(rowNum:uint = 12, columNum:uint = 12)
		{
			_sROW_NUM = rowNum;
			_sCOLUM_NUM = columNum;
		}
		
		public function init():void
		{	
			_juggler = new Juggler();
			
			_possibleChecker = new PossibleChecker();
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
			_possibleChecker.init();
			var prevTime:Number = getTimer() / 1000;
			_possibleChecker.checkPossibleCell(_cells);
			var currentTime:Number = getTimer() / 1000;
			trace("경과시간 = " + (currentTime - prevTime));
			trace("가능 개수 = " + _possibleChecker.possibleCount);
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
				_cells[i].removeFromParent();
				_cells[i] = null;
			}
			_cells.splice(0, _cells.length);
			_cells = null;
			_possibleChecker.removeEventListener(CheckEvent.SAME, onSame);
			_possibleChecker.distroy();
			_possibleChecker = null;
			
			_backGround.removeFromParent();
			_backGround = null;
			
			dispose();
		}
		
		public function advanceTime(time:Number):void
		{
			_juggler.advanceTime(time);
		}
		
		private function onSame(event:Event):void
		{
			var possible:Possible = event.data as Possible;
			var tween1:Tween = new Tween(possible.startCell.block, 0.5);
			var tween2:Tween = new Tween(possible.destCell.block, 0.5);
			
			possible.startCell.block = null;
			possible.destCell.block = null;
			showPath(possible);
			checkPossibleCell();
			
			tween1.fadeTo(0.0);
			tween1.addEventListener(Event.REMOVE_FROM_JUGGLER, onTweenComplete);
			tween2.fadeTo(0.0);
			tween2.addEventListener(Event.REMOVE_FROM_JUGGLER, onTweenComplete);
			_juggler.add(tween1);
			_juggler.add(tween2);
			
			possible.distroy();
			
			function onTweenComplete(event:Event):void
			{
				Tween(event.currentTarget).removeEventListener(Event.REMOVE_FROM_JUGGLER, onTweenComplete);
				Tween(event.currentTarget).target.distroy();
			}
		}
		
		private function showPath(possible:Possible):void
		{
			var fullPath:Vector.<Cell> = new Vector.<Cell>();
			
			possible.path.insertAt(0, possible.startCell);
			possible.path.push(possible.destCell);
			
			var points:Vector.<Point> = getPoints(possible.path);
			for(var i:int = 0; i < points.length-1; i++)
				drawLine(points[i], points[i+1]);
		}
		
		private function drawLine(start:Point, dest:Point):void
		{
			var line:Image;
			if(start.x == dest.x)
			{
				line = new Image(Texture.fromBitmap(new columLineImage() as Bitmap));
				line.alignPivot();
				line.width = 40;
				line.height = Math.abs(start.y - dest.y);
				line.x = start.x;
				line.y = (start.y < dest.y) ? start.y : dest.y;
				line.y += (line.height/2);
			}
			else
			{
				line = new Image(Texture.fromBitmap(new rowLineImage() as Bitmap));
				line.alignPivot();
				line.width = Math.abs(start.x - dest.x);
				line.height = 40;
				line.x = (start.x < dest.x) ? start.x : dest.x;
				line.x += (line.width/2);
				line.y = start.y;
			}
			
			addChild(line);
			_juggler.delayCall(removeLine, 0.3);
			
			function removeLine():void
			{
				line.removeFromParent(true);
			}
		}
		
		private function getPoints(path:Vector.<Cell>):Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>();
			var bound:Rectangle;
			var center:Point;
			for(var i:int = 0; i < path.length; i++)
			{
				bound = path[i].getBounds(this);
				center = Point.interpolate(bound.topLeft, bound.bottomRight,0.5);
				points.push(center);
			}
			
			return points;
		}
		
		private function onAddPrev(event:Event):void
		{
//			trace(Cell(event.currentTarget).row);
//			trace(Cell(event.currentTarget).block.type);
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
		
		public function createBlock(blockData:BlockData):void
		{
			var cell:Cell = getCell(blockData.row, blockData.colum);
			cell.createBlock(blockData);
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