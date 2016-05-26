package
{
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class Cell extends DisplayObjectContainer
	{
		public static const CELL_WIDTH_SIZE:Number = 55;
		public static const CELL_HEIGHT_SIZE:Number = 72;
		
		private var _neigbor:Dictionary;
		private var _block:Block;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _row:int;
		private var _colum:int;
		
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