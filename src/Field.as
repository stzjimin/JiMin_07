package
{	
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class Field extends DisplayObjectContainer
	{
		public static const CELL_SIZE:Number = 125;
		public static const ROW_NUM:uint = 7;
		public static const COLUM_NUM:uint = 7;
		
		private var _cells:Array;
		private var _distroyer:Distroyer;
		
		private var _fillManager:FillManager;
		
		private var _finAniQueue:Array = new Array();
		private var _moveBlock:uint = 0;
		private var _movedBlock:uint = 0;
		
		public function Field()
		{
			init();
		}
		
		public function init():void
		{
			_distroyer = new Distroyer();
			_distroyer.addEventListener(Distroyer.COMPLETE_DISTROY, onCompleteDistroy);
			
			_fillManager = new FillManager();
			_fillManager.init();
			
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
					_cells[i][j].name = i.toString() + "/" + j.toString();
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
		
//		public function swapBlock(trigger:Cell, target:Cell):void
//		{	
//			var thisBounds:Rectangle = trigger.bounds;
//			var targetBounds:Rectangle = target.bounds;
//			
//			var blockMoveX:Number = 1;
//			var blockMoveY:Number = 1;
//			
//			var blockXdest:Number = thisBounds.x - targetBounds.x;
//			var blockYdest:Number = thisBounds.y - targetBounds.y;
//			
//			if(blockXdest > 0)
//				blockMoveX = -blockMoveX;
//			if(blockYdest > 0)
//				blockMoveY = -blockMoveY;
//			
//			var block1:Block = trigger.block;
//			var block2:Block = target.block;
//			_moveBlock++;
//			addEventListener(Event.ENTER_FRAME, onEnterFrameBlockMove);
//			
//			function onEnterFrameBlockMove(event:Event):void
//			{
//				if(block2.x != blockXdest)
//				{
//					if(block1 != null)
//						block1.x += blockMoveX;
//					block2.x -= blockMoveX;
//				}
//				if(block2.y != blockYdest)
//				{
//					if(block1 != null)
//						block1.y += blockMoveY;
//					block2.y -= blockMoveY;
//				}
//				
//				if((block2.x == blockXdest) && (block2.y == blockYdest))
//				{
//					removeEventListener(Event.ENTER_FRAME, onEnterFrameBlockMove);
//					var array:Array = new Array();
//					array.push(trigger);
//					array.push(target);
//					_finAniQueue.push(array);
//					checkAnimation();
//				}
//			}
//		}
		
//		private function checkAnimation():void
//		{
//			_movedBlock++;
//			trace("_movedBlock = " + _movedBlock);
//			trace("_moveBlock = " + _moveBlock);
//			if(_movedBlock >= _moveBlock)
//			{
//				var array:Array;
//				while(_finAniQueue.length != 0)
//				{
//					array = _finAniQueue.shift();
//					array[0].dispatchEvent(new Event(SwapType.END_ANIMATION, false, array[1]));
//				}
//				array = null;
//			}
//		}
		
		private function onCompleteDistroy(event:Event):void
		{
			checkBlankedCell();
//			fill();
//			checkSwapedCell();
		}
		
		private function fill():void
		{
			_fillManager.fill();
		}
		
		private function checkBlankedCell():void
		{
			for(var i:int = 0; i < COLUM_NUM; i++)
			{
				for(var j:int = 0; j < ROW_NUM; j++)
				{
					if(_cells[i][j].blanked)
					{
						_fillManager.addCell(_cells[i][j]);
//						_cells[i][j].swaped = false;
//						_cells[i][j].checkNeigbor();
					}
				}
			}
		}
		
		private function checkSwapedCell():void
		{
			for(var i:int = 0; i < COLUM_NUM; i++)
			{
				for(var j:int = 0; j < ROW_NUM; j++)
				{
					if(_cells[i][j].swaped)
					{
						_cells[i][j].swaped = false;
						_cells[i][j].checkNeigbor();
					}
				}
			}
		}
		
		private function onTriggeredTestButton(event:Event):void
		{
			_distroyer.distroy();
		}
		
		private function onCompleteSwap(event:Event):void
		{
//			trace("a");
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