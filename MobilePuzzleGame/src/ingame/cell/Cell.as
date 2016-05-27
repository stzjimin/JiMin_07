package ingame.cell
{
	import flash.utils.Dictionary;
	
	import ingame.cell.blocks.Block;
	import ingame.cell.blocks.BlockData;
	import ingame.util.possibleCheck.CheckEvent;
	
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
		
		private var _frameCheck:uint;
		
		public function Cell()
		{
			addEventListener(CheckEvent.PULL_PREV, onPullPrev);
		}
		
		public function init():void
		{
			_neigbor = new Dictionary();
			_color = new Quad(this.width, this.height, Color.RED);
			_color.x = 0;
			_color.y = 0;
			_color.visible = false;
			addChild(_color);
			
//			if(cellData.blockData != null)
//			{
//				_block = new Block();
//				_block.width = this.width;
//				_block.height = this.height;
//				_block.init(cellData.blockData);
//				addChild(_block);
//			}
		}
		
		public function showColor():void
		{
			_color.visible = true;
		}
		
		public function offColor():void
		{
			_color.visible = false;
		}
		
//		private function createBlock(blockData):Block
//		{
//			var block:Block = new Block();
//			
//			return block;
//		}
		
		public function createBlock(blockData:BlockData):void
		{
			if(_block != null)
				return;
			
			_block = new Block(blockData);
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
		
		public function distroy():void
		{
			removeEventListener(CheckEvent.PULL_PREV, onPullPrev);
			
			dispose();
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