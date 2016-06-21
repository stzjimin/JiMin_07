package puzzle.ingame.cell
{
	import flash.utils.Dictionary;
	
	import puzzle.ingame.cell.blocks.Block;
	import puzzle.ingame.util.possibleCheck.PossibleCheckerEventType;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;

	public class Cell extends DisplayObjectContainer
	{
		public static const WIDTH_SIZE:Number = 45;
		public static const HEIGHT_SIZE:Number = 60;
		
		private var _neigbor:Dictionary;
		private var _block:Block;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _row:int;
		private var _column:int;
		
		private var _color:Quad;
		
		/**
		 * 블럭이 들어갈 수 있는 타일 또는 공간입니다. 
		 * 
		 */		
		public function Cell()
		{
//			addEventListener(PossibleCheckerEventType.PULL_PREV, onPullPrev);
		}
		
		/**
		 * 클래스를 초기화하는 함수입니다. 이때 크기를 지정한 크기로 정하기위해 내부에 쿼드를 하나 추가시킵니다.
		 * 
		 */		
		public function init():void
		{
			_neigbor = new Dictionary();
			_color = new Quad(this.width, this.height, 0x0);
			_color.x = 0;
			_color.y = 0;
			_color.visible = false;
			addChild(_color);
		}
		
		/**
		 * 셀을 제거하고 할당된 메모리를 해제하는 함수입니다.
		 * 
		 */		
		public function destroy():void
		{
//			removeEventListener(PossibleCheckerEventType.PULL_PREV, onPullPrev);
			
			for(var key:String in _neigbor)
				delete _neigbor[key];
			
			if(_block != null)
			{
				_block.destroy();
				_block = null
			}
			
			_color.removeFromParent();
			_color.dispose();
			
			dispose();
		}
		
//		public function createBlock(blockData:BlockData):void
//		{
////			if(_block != null)
////				return;
//			
////			_block = new Block();
////			_block.width = _width;
////			_block.height = _height;
////			_block.init(blockData);
//			
////			addChild(_block);
//		}
		
		/**
		 * 해당 영역에 인자로 받은 블럭을 추가시키는 함수입니다. 
		 * @param block
		 * 
		 */		
		public function addBlock(block:Block):void
		{
			if(_block != null)
				return;
			
			_block = block;
//			_block.width = 100;
			_block.alignPivot();
			_block.x = this.width/2;
			_block.y = this.height/2;
			addChild(_block);
		}
		
		public function onPullPrev():void
		{
			if(_block == null)
				return;
			_block.pullPrev();
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

		public function get column():int
		{
			return _column;
		}

		public function set column(value:int):void
		{
			_column = value;
		}
	}
}