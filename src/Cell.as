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
			addEventListener(SwapType.SWAP_BLOCK, onSwapBlock);
		}

		private function onBlockTriggered(event:Event):void
		{
			dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, _block));
			_block = null;
			dispatchEvent(new Event(SwapType.SWAP_BLOCK));
			dispatchEvent(new Event(SwapType.COMPLETE_SWAP));
		}
		
		private function onSwapBlock(event:Event):void
		{
			if(GravityManager.gravity == GravityType.DOWN)
			{
				if(_neigbor[NeigborType.TOP] == null)
					return;
				
				if(_neigbor[NeigborType.TOP].block != null)
					swapBlock(_neigbor[NeigborType.TOP]);
				else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT].block != null)
					swapBlock(_neigbor[NeigborType.TOP].neigbor[NeigborType.LEFT]);
				else if(_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT] != null && _neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT].block != null)
					swapBlock(_neigbor[NeigborType.TOP].neigbor[NeigborType.RIGHT]);
			}
			else if(GravityManager.gravity == GravityType.UP)
			{
				if(_neigbor[NeigborType.BOTTOM] == null)
					return;
				
				if(_neigbor[NeigborType.BOTTOM].block != null)
					swapBlock(_neigbor[NeigborType.BOTTOM]);
				else if(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT] != null && _neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT].block != null)
					swapBlock(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.RIGHT]);
				else if(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT] != null && _neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT].block != null)
					swapBlock(_neigbor[NeigborType.BOTTOM].neigbor[NeigborType.LEFT]);
			}
			else if(GravityManager.gravity == GravityType.LEFT)
			{
				if(_neigbor[NeigborType.RIGHT] == null)
					return;
				
				if(_neigbor[NeigborType.RIGHT].block != null)
					swapBlock(_neigbor[NeigborType.RIGHT]);
				else if(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP] != null && _neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP].block != null)
					swapBlock(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.TOP]);
				else if(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM] != null && _neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM].block != null)
					swapBlock(_neigbor[NeigborType.RIGHT].neigbor[NeigborType.BOTTOM]);
			}
			else if(GravityManager.gravity == GravityType.RIGHT)
			{
				if(_neigbor[NeigborType.LEFT] == null)
					return;
				
				if(_neigbor[NeigborType.LEFT].block != null)
					swapBlock(_neigbor[NeigborType.LEFT]);
				else if(_neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM] != null && _neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM].block != null)
					swapBlock(_neigbor[NeigborType.LEFT].neigbor[NeigborType.BOTTOM]);
				else if(_neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP] != null && _neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP].block != null)
					swapBlock(_neigbor[NeigborType.LEFT].neigbor[NeigborType.TOP]);
			}
		}
		
		private function swapBlock(cell:Cell):void
		{
			var block:Block = cell.block;
			block.removeFromParent();
			cell.block = _block;
			addChild(block);
			_block = block;
			cell.dispatchEvent(new Event(SwapType.SWAP_BLOCK));
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