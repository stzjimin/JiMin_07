package ingame.cell
{
	import flash.utils.Dictionary;
	
	import ingame.blocks.Block;
	import ingame.util.possibleCheck.CheckEvent;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.Color;

	public class Cell extends DisplayObjectContainer
	{
		public static const CELL_WIDTH_SIZE:Number = 45;
		public static const CELL_HEIGHT_SIZE:Number = 60;
		
		private var _neigbor:Dictionary;
		private var _block:Block;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _row:int;
		private var _colum:int;
		
		private var _color:Quad;
		
		private var _possibleCell:Vector.<Cell>;
		
		private var _frameCheck:uint;
		
		public function Cell()
		{
			addEventListener(CheckEvent.PULL_PREV, onPullPrev);
		}
		
		public function init():void
		{
			_neigbor = new Dictionary();
			_possibleCell = new Vector.<Cell>();
			_color = new Quad(this.width, this.height, Color.RED);
			_color.x = 0;
			_color.y = 0;
			_color.visible = false;
			addChild(_color);
		}
		
		public function showColor():void
		{
			_color.visible = true;
			Starling.juggler.delayCall(offColor, 0.3);
//			var frameCount:uint = 0;
//			addEventListener(Event.ENTER_FRAME, onShowTime);
//			function onShowTime(event:Event):void
//			{
//				frameCount++;
//				if(frameCount > 10)
//				{
//					frameCount = 0;
//					_color.visible = false;
//					removeEventListener(Event.ENTER_FRAME, onShowTime);
//				}
//			}
		}
		
		private function offColor():void
		{
			_color.visible = false;
		}
		
		public function createBlock(type:String):void
		{
			if(_block != null)
				return;
			
			_block = new Block(type);
			_block.width = this.width;
			_block.height = this.height;
			_block.init();
			addChild(_block);
		}
		
		private function onPullPrev(event:Event):void
		{
			if(_block == null)
				return;
			_block.pullPrev();
		}
		
		public function addPossibleCell(cell:Cell):void
		{
			_possibleCell.push(cell);
		}
		
		public function checkPossibleCell(cell:Cell):Boolean
		{
			if(_possibleCell == null || _possibleCell.length == 0)
				return false;
			
			for(var i:int = 0; i < _possibleCell.length; i++)
			{
				if(cell == _possibleCell[i])
					return true;
			}
			return false;
		}
		
		public function distroy():void
		{
			removeEventListener(CheckEvent.PULL_PREV, onPullPrev);
		}
		
		private function onEnterFrame(event:Event):void
		{
			
		}

		public function get neigbor():Dictionary
		{
			return _neigbor;
		}

		public function set neigbor(value:Dictionary):void
		{
			_neigbor = value;
		}
		
		public function get block():Block
		{
			return _block;
		}
		
		public function set block(value:Block):void
		{
			_block = value;
		}

		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
			_width = value;
			super.width = _width;
		}

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
			_height = value;
			super.height = _height;
		}

		public function get row():int
		{
			return _row;
		}

		public function set row(value:int):void
		{
			_row = value;
		}

		public function get colum():int
		{
			return _colum;
		}

		public function set colum(value:int):void
		{
			_colum = value;
		}
	}
}