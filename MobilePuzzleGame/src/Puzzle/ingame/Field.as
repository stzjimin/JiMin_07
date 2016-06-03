package puzzle.ingame
{	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import puzzle.loader.Resources;
	import puzzle.ingame.cell.Cell;
	import puzzle.ingame.cell.NeigborType;
	import puzzle.ingame.cell.blocks.Block;
	import puzzle.ingame.cell.blocks.BlockData;
	import puzzle.ingame.util.possibleCheck.CheckEvent;
	import puzzle.ingame.util.possibleCheck.Possible;
	import puzzle.ingame.util.possibleCheck.PossibleChecker;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;

	public class Field extends DisplayObjectContainer implements IAnimatable
	{	
		private static var _sROW_NUM:uint;
		private static var _sCOLUM_NUM:uint;
		private static var _sPADDING:uint;
		
		private var _resources:Resources;
		private var _juggler:Juggler;
		
		private var _rowLine:Image;
		private var _rowLine2:Image;
		private var _columLine:Image;
		private var _columLine2:Image;
		
		private var _backGround:Image;
		
		private var _padding:FramePadding;
		
		private var _cells:Vector.<Cell>;
		
		private var _possibleChecker:PossibleChecker;
		private var _shuffle:Shuffle;
		
		public function Field(rowNum:uint = 12, columNum:uint = 12, padding:uint = 18)
		{
			_sROW_NUM = rowNum;
			_sCOLUM_NUM = columNum;
			_sPADDING = padding;
		}
		
		public function init(resources:Resources):void
		{	
			_resources = resources;
			
			_juggler = new Juggler();
			
			_possibleChecker = new PossibleChecker();
			_possibleChecker.addEventListener(CheckEvent.SAME, onSame);
			_shuffle = new Shuffle();
			_shuffle.init();
			_shuffle.addEventListener(Shuffle.COMPLETE, onCompleteShuffle);
//			_distroyer.addEventListener(Distroyer.COMPLETE_DISTROY, onCompleteDistroy);
			
			_padding = new FramePadding(Field.PADDING, (Field.ROW_NUM * Cell.WIDTH_SIZE), (Field.COLUM_NUM * Cell.HEIGHT_SIZE), 
				_resources.getSubTexture("IngameSprite0.png", "topPadding"), _resources.getSubTexture("IngameSprite0.png", "bottomPadding"),
				_resources.getSubTexture("IngameSprite0.png", "leftPadding"), _resources.getSubTexture("IngameSprite0.png", "rightPadding"));
			addChild(_padding);
			
			_backGround = new Image(_resources.getSubTexture("IngameSprite0.png", "backGround"));
			_backGround.x = Field.PADDING;
			_backGround.y = Field.PADDING;
			_backGround.width = (Field.ROW_NUM * Cell.WIDTH_SIZE);
			_backGround.height = (Field.COLUM_NUM * Cell.HEIGHT_SIZE);
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
				cell.width = Cell.WIDTH_SIZE;
				cell.height = Cell.HEIGHT_SIZE;
				cell.x = Field.PADDING + (rowNum * Cell.WIDTH_SIZE);
				cell.y = Field.PADDING + (columNum * Cell.HEIGHT_SIZE);
				cell.row = columNum;
				cell.colum = rowNum;
				_cells[i].name = rowNum.toString() + "/" + columNum.toString();
				cell.init();
				addChild(cell);
//				trace("cell.x = " + cell.x);
//				trace("cell.y = " + cell.y);
//				trace("cell.row = " + cell.row);
//				trace("cell.colum = " + cell.colum);
				if(columNum != 0)
				{
					_cells[i].neigbor[NeigborType.TOP] = _cells[i-ROW_NUM];
					_cells[i-ROW_NUM].neigbor[NeigborType.BOTTOM] = _cells[i];
//					_cells[i].y -= Block.PADDING_SIZE;
				}
				if(rowNum != 0)
				{
					_cells[i].neigbor[NeigborType.LEFT] = _cells[i-1];
					_cells[i-1].neigbor[NeigborType.RIGHT] = _cells[i];
//					_cells[i].x -= Block.PADDING_SIZE;
				}
				if(rowNum == (ROW_NUM-1))
					columNum++;
			}
			
			_rowLine = new Image(_resources.getSubTexture("IngameSprite0.png", "rowLine"));
			_rowLine.alignPivot();
			_rowLine2 = new Image(_resources.getSubTexture("IngameSprite0.png", "rowLine"));
			_rowLine2.alignPivot();
			_columLine = new Image(_resources.getSubTexture("IngameSprite0.png", "columLine"));
			_columLine.alignPivot();
			_columLine2 = new Image(_resources.getSubTexture("IngameSprite0.png", "columLine"));
			_columLine2.alignPivot();
			
			addEventListener("shuffle", onShuffle);
			_resources = null;
		}
		
		private function onShuffle(event:Event):void
		{
			_shuffle.shuffle(_cells);
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
		public function destroy():void
		{
			for(var i:int = 0; i < _cells.length; i++)
			{
				_cells[i].removeEventListener(CheckEvent.ADD_PREV, onAddPrev);
				_cells[i].removeEventListener(CheckEvent.OUT_CHECKER, onOutChecker);
				_cells[i].destroy();
				_cells[i].removeFromParent();
				_cells[i] = null;
			}
			_cells.splice(0, _cells.length);
			_cells = null;
			_possibleChecker.removeEventListener(CheckEvent.SAME, onSame);
			_possibleChecker.destroy();
			_possibleChecker = null;
			
			_padding.destroy();
			
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_rowLine.removeFromParent();
			_rowLine.dispose();
			_rowLine = null;
			
			_rowLine2.removeFromParent();
			_rowLine2.dispose();
			_rowLine2 = null;
			
			_columLine.removeFromParent();
			_columLine.dispose();
			_columLine = null;
			
			_columLine2.removeFromParent();
			_columLine2.dispose();
			_columLine2 = null;
			
			_shuffle.removeEventListener(Shuffle.COMPLETE, onCompleteShuffle);
			
			_juggler.purge();
			
			dispose();
		}
		
		public function advanceTime(time:Number):void
		{
			_juggler.advanceTime(time);
		}
		
		private function onCompleteShuffle(event:Event):void
		{
			_possibleChecker.checkPossibleCell(_cells);
			if(_possibleChecker.blockCount >= 2 && _possibleChecker.possibleCount == 0)
				_shuffle.shuffle(_cells);
			else
			{
				trace(_possibleChecker.blockCount);
				trace(_possibleChecker.possibleCount);
			}
		}
		
		private function onSame(event:Event):void
		{
			var possible:Possible = event.data as Possible;
			var tween1:Tween = new Tween(possible.startCell.block, 0.5);
			var tween2:Tween = new Tween(possible.destCell.block, 0.5);
			
			possible.startCell.block = null;
			possible.destCell.block = null;
			showPath(possible);
			
			tween1.fadeTo(0.0);
			tween1.addEventListener(Event.REMOVE_FROM_JUGGLER, onTweenComplete);
			tween2.fadeTo(0.0);
			tween2.addEventListener(Event.REMOVE_FROM_JUGGLER, onTweenComplete);
			_juggler.add(tween1);
			_juggler.add(tween2);
			
			checkPossibleCell();
			
			possible.distroy();
			
			function onTweenComplete(event:Event):void
			{
				Tween(event.currentTarget).removeEventListener(Event.REMOVE_FROM_JUGGLER, onTweenComplete);
				Tween(event.currentTarget).target.destroy();
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
				line = _columLine;
				if(this.getChildIndex(line) > 0)
					line = _columLine2;
				line.width = 40;
				line.height = Math.abs(start.y - dest.y);
				line.x = start.x;
				line.y = (start.y < dest.y) ? start.y : dest.y;
				line.y += (line.height/2);
			}
			else
			{
				line = _rowLine;
				if(this.getChildIndex(line) > 0)
					line = _rowLine2;
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
				line.removeFromParent();
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
		
		public function createBlock(blockData:BlockData, resources:Resources):void
		{
			var cell:Cell = getCell(blockData.row, blockData.colum);
			
			var block:Block = new Block(resources);
			block.init(blockData);
			cell.addBlock(block);
		}

		public static function get ROW_NUM():uint
		{
			return _sROW_NUM;
		}

		public static function get COLUM_NUM():uint
		{
			return _sCOLUM_NUM;
		}

		public static function get PADDING():uint
		{
			return _sPADDING;
		}


	}
}