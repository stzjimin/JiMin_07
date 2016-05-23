package
{
	import flash.system.System;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class Cell extends DisplayObjectContainer
	{
		private var _neigbor:Dictionary;
		private var _block:Block;
		
		public function Cell()
		{
			_neigbor = new Dictionary();
			_block = new Block();
			addChild(_block);
			
			addEventListener("blockTriggered", onBlockTriggered);
			addEventListener("removeBlock", onRemoveBlock);
		}

		private function onBlockTriggered(event:Event):void
		{
			_block.removeFromParent();
			_block.distroy();
			_block = null;
			dispatchEvent(new Event("removeBlock"));
		}
		
		private function onRemoveBlock(event:Event):void
		{
			if(_neigbor[NeigborType.TOP] == null)
				return;
			
			if(_neigbor[NeigborType.TOP].block != null)
			{
				swapTopBlock();
			}
			else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT].block != null)
			{
				swapTopLeftBlock();
			}
			else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT].block != null)
			{
				swapTopRightBlock();
			}
		}
		
		private function swapTopLeftBlock():void
		{
			var block:Block = _neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT].block;
			block.removeFromParent();
			_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT].block = null;
			addChild(block);
			_block = block;
			_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT].dispatchEvent(new Event("removeBlock"));
		}
		
		private function swapTopRightBlock():void
		{
			var block:Block = _neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT].block;
			block.removeFromParent();
			_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT].block = null;
			addChild(block);
			_block = block;
			_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT].dispatchEvent(new Event("removeBlock"));
		}
		
		private function swapTopBlock():void
		{
			var block:Block = _neigbor[NeigborType.TOP].block;
			block.removeFromParent();
			_neigbor[NeigborType.TOP].block = null;
			addChild(block);
			_block = block;
			_neigbor[NeigborType.TOP].dispatchEvent(new Event("removeBlock"));
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
	}
}