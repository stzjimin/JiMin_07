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
			addEventListener("swapBlock", onRemoveBlock);
		}

		private function onBlockTriggered(event:Event):void
		{
			_block.removeFromParent();
			_block.distroy();
			_block = null;
			dispatchEvent(new Event("swapBlock"));
		}
		
		private function onRemoveBlock(event:Event):void
		{
			if(GravityManager.gravity == GravityType.DOWN)
			{
				if(_neigbor[NeigborType.TOP] == null)
					return;
				
				if(_neigbor[NeigborType.TOP].block != null)
				{
					swapBlock(_neigbor[NeigborType.TOP]);
//					swapTopBlock();
				}
				else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT].block != null)
				{
					swapBlock(_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT]);
//					swapTopLeftBlock();
				}
				else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT].block != null)
				{
					swapBlock(_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT]);
//					swapTopRightBlock();
				}
			}
			else if(GravityManager.gravity == GravityType.UP)
			{
				
			}
			else if(GravityManager.gravity == GravityType.LEFT)
			{
				
			}
			else if(GravityManager.gravity == GravityType.RIGHT)
			{
				
			}
		}
		
		private function swapBlock(cell:Cell):void
		{
			var block:Block = cell.block;
			block.removeFromParent();
			cell.block = _block;
			addChild(block);
			_block = block;
			cell.dispatchEvent(new Event("swapBlock"));
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