package puzzle.ingame
{	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import puzzle.ingame.cell.Cell;
	import puzzle.ingame.cell.NeigborType;
	import puzzle.ingame.cell.blocks.Block;
	import puzzle.ingame.cell.blocks.BlockData;
	import puzzle.ingame.item.fork.ForkEvent;
	import puzzle.ingame.item.fork.Forker;
	import puzzle.ingame.item.shuffle.Shuffler;
	import puzzle.ingame.util.possibleCheck.CheckEvent;
	import puzzle.ingame.util.possibleCheck.Possible;
	import puzzle.ingame.util.possibleCheck.PossibleChecker;
	import puzzle.ingame.util.possibleCheck.PossibleCheckerEventType;
	import puzzle.loading.Resources;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;

	public class Field extends DisplayObjectContainer implements IAnimatable
	{	
		public static const ROW_NUM:uint = 12;
		public static const COLUMN_NUM:uint = 12;
		public static const PADDING:uint = 18;
		
		public static const PANG:String = "pang";
		
		private var _resources:Resources;
		private var _juggler:Juggler;
		
		private var _rowLine:Image;
		private var _rowLine2:Image;
		private var _columnLine:Image;
		private var _columnLine2:Image;
		
		private var _backGround:Image;
		
		private var _padding:FramePadding;
		
		private var _cells:Vector.<Cell>;
		
		private var _possibleChecker:PossibleChecker;
		
		private var _shuffler:Shuffler;
		
		private var _isFork:Boolean;
		private var _forker:Forker;
		
		public function Field(resources:Resources)
		{
			_resources = resources;
		}
		
		public function init():void
		{	
			_juggler = new Juggler();
			
			_possibleChecker = new PossibleChecker();
			_possibleChecker.addEventListener(PossibleCheckerEventType.SAME, onSame);
			
			_shuffler = new Shuffler();
			_shuffler.init();
			_shuffler.addEventListener(Shuffler.COMPLETE, onCompleteShuffle);
			
			_isFork = false;
			_forker = new Forker();
			_forker.addEventListener(Forker.GET_FORK, onSucceedFork);
			
			_padding = new FramePadding(Field.PADDING, (Field.ROW_NUM * Cell.WIDTH_SIZE), (Field.COLUMN_NUM * Cell.HEIGHT_SIZE), 
				_resources.getSubTexture("IngameSprite0.png", "topPadding"), _resources.getSubTexture("IngameSprite0.png", "bottomPadding"),
				_resources.getSubTexture("IngameSprite0.png", "leftPadding"), _resources.getSubTexture("IngameSprite0.png", "rightPadding"));
			addChild(_padding);
			
			_backGround = new Image(_resources.getSubTexture("IngameSprite0.png", "backGround"));
			_backGround.x = Field.PADDING;
			_backGround.y = Field.PADDING;
			_backGround.width = (Field.ROW_NUM * Cell.WIDTH_SIZE);
			_backGround.height = (Field.COLUMN_NUM * Cell.HEIGHT_SIZE);
			addChild(_backGround);
			
			_cells = new Vector.<Cell>();
			var columnNum:int = 0;
			for(var i:int = 0; i < COLUMN_NUM*ROW_NUM; i++)
			{
				var cell:Cell = new Cell();
				var rowNum:int = i%ROW_NUM;
				_cells.push(cell);
				cell.addEventListener(PossibleCheckerEventType.ADD_PREV, onAddPrev);
				cell.addEventListener(PossibleCheckerEventType.OUT_CHECKER, onOutChecker);
				cell.width = Cell.WIDTH_SIZE;
				cell.height = Cell.HEIGHT_SIZE;
				cell.x = Field.PADDING + (rowNum * Cell.WIDTH_SIZE);
				cell.y = Field.PADDING + (columnNum * Cell.HEIGHT_SIZE);
				cell.row = columnNum;
				cell.column = rowNum;
				_cells[i].name = rowNum.toString() + "/" + columnNum.toString();
				cell.init();
				addChild(cell);
//				trace("cell.x = " + cell.x);
//				trace("cell.y = " + cell.y);
//				trace("cell.row = " + cell.row);
//				trace("cell.colum = " + cell.colum);
				if(columnNum != 0)
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
					columnNum++;
			}
			
			_rowLine = new Image(_resources.getSubTexture("IngameSprite0.png", "rowLine"));
			_rowLine.alignPivot();
			_rowLine2 = new Image(_resources.getSubTexture("IngameSprite0.png", "rowLine"));
			_rowLine2.alignPivot();
			_columnLine = new Image(_resources.getSubTexture("IngameSprite0.png", "columLine"));
			_columnLine.alignPivot();
			_columnLine2 = new Image(_resources.getSubTexture("IngameSprite0.png", "columLine"));
			_columnLine2.alignPivot();
			
			_resources = null;
		}
		
		public function shuffle():void
		{
			_shuffler.shuffle(_cells);
		}
		
		public function search():void
		{
			var possible:Possible = _possibleChecker.pickPossible();
			trace(possible.startCell.name);
			trace(possible.destCell.name);
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
			
			trace(_possibleChecker.blockCount);
			trace(_possibleChecker.possibleCount);
			
			trace("경과시간 = " + (currentTime - prevTime));
			
			if(_possibleChecker.blockCount > 0 && _possibleChecker.possibleCount == 0)
				shuffle();
			else
				dispatchEvent(new CheckEvent(CheckEvent.CHECKED_COMPLETE, _possibleChecker.blockCount, _possibleChecker.possibleCount));
		}
		
		/**
		 *Field를 제거하는 함수 
		 * 
		 */		
		public function destroy():void
		{
			for(var i:int = 0; i < _cells.length; i++)
			{
				_cells[i].removeEventListener(PossibleCheckerEventType.ADD_PREV, onAddPrev);
				_cells[i].removeEventListener(PossibleCheckerEventType.OUT_CHECKER, onOutChecker);
				_cells[i].destroy();
				_cells[i].removeFromParent();
				_cells[i] = null;
			}
			_cells.splice(0, _cells.length);
			_cells = null;
			
			_possibleChecker.removeEventListener(PossibleCheckerEventType.SAME, onSame);
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
			
			_columnLine.removeFromParent();
			_columnLine.dispose();
			_columnLine = null;
			
			_columnLine2.removeFromParent();
			_columnLine2.dispose();
			_columnLine2 = null;
			
			_shuffler.init();
			_shuffler.removeEventListener(Shuffler.COMPLETE, onCompleteShuffle);
			
			_forker.removeEventListener(Forker.GET_FORK, onSucceedFork);
			
			_juggler.purge();
			
			dispose();
		}
		
		public function advanceTime(time:Number):void
		{
			_juggler.advanceTime(time);
		}
		
		private function onSucceedFork(event:ForkEvent):void
		{
			var tween1:Tween = new Tween(event.selectedBlock, 0.5);
			var tween2:Tween = new Tween(event.targetBlock, 0.5);
			
			Cell(event.selectedBlock.parent).block = null;
			Cell(event.targetBlock.parent).block = null;
			
			tween1.scaleTo(0);
			tween1.addEventListener(Event.REMOVE_FROM_JUGGLER, onTweenComplete);
			tween2.scaleTo(0);
			tween2.addEventListener(Event.REMOVE_FROM_JUGGLER, onTweenComplete);
			_juggler.add(tween1);
			_juggler.add(tween2);
			
			dispatchEvent(new Event(Forker.GET_FORK));
			dispatchEvent(new Event(Field.PANG));
			
//			checkPossibleCell();
			
			function onTweenComplete(event:Event):void
			{
				Tween(event.currentTarget).removeEventListener(Event.REMOVE_FROM_JUGGLER, onTweenComplete);
				Block(Tween(event.currentTarget).target).destroy();
			}
		}
		
		private function onCompleteShuffle(event:Event):void
		{
			_possibleChecker.checkPossibleCell(_cells);
			if(_possibleChecker.blockCount >= 2 && _possibleChecker.possibleCount == 0)
				shuffle();
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
			
//			checkPossibleCell();
			
			possible.distroy();
			
			dispatchEvent(new Event(Field.PANG));
			
			function onTweenComplete(event:Event):void
			{
				Tween(event.currentTarget).removeEventListener(Event.REMOVE_FROM_JUGGLER, onTweenComplete);
				Block(Tween(event.currentTarget).target).destroy();
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
				line = _columnLine;
				if(this.getChildIndex(line) > 0)
					line = _columnLine2;
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
			if(_isFork)
			{
				_forker.fork(Cell(event.currentTarget).block, _cells);
				_isFork = false;
				return;
			}
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
			var cell:Cell = getCell(blockData.row, blockData.column);
			
			var block:Block = new Block(resources);
			block.init(blockData);
			cell.addBlock(block);
		}

		public function get isFork():Boolean
		{
			return _isFork;
		}

		public function set isFork(value:Boolean):void
		{
			_isFork = value;
		}
	}
}