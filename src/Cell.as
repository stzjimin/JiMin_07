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
		
		private var _width:Number;
		private var _height:Number;
		
		private var _swaped:Boolean;
		
		private var _frameCheck:uint;
		
		public function Cell()
		{
			_neigbor = new Dictionary();
			_swaped = false;
		}
		
		public function init():void
		{
			var rand:int = (Math.random()*10)%3;
			_block = new Block(rand);
			_block.width = this.width;
			_block.height = this.height;
			addChild(_block);
			
			addEventListener("blockTriggered", onBlockTriggered);
			addEventListener(SwapType.SWAP_BLOCK, onSwapBlock);
		}

		private function onBlockTriggered(event:Event):void
		{
			checkNeigbor();
//			if(!_block.distroyed)
//				dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, _block));
//			_block = null;
//			dispatchEvent(new Event(SwapType.SWAP_BLOCK));
		}
		
		private function onSwapBlock(event:Event):void
		{
			if(GravityManager.gravity == GravityType.DOWN)
			{
				if(_neigbor[NeigborType.TOP] == null)
				{
					dispatchEvent(new Event(SwapType.COMPLETE_SWAP));
					return;
				}
				
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
				{
					dispatchEvent(new Event(SwapType.COMPLETE_SWAP));
					return;
				}
				
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
				{
					dispatchEvent(new Event(SwapType.COMPLETE_SWAP));
					return;
				}
				
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
				{
					dispatchEvent(new Event(SwapType.COMPLETE_SWAP));
					return;
				}
				
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
			_swaped = true;
//			checkNeigbor();
//			_frameCheck = 0;
//			addEventListener(Event.ENTER_FRAME, onCheckTime);
			cell.dispatchEvent(new Event(SwapType.SWAP_BLOCK));
		}
		
		private function onCheckTime(event:Event):void
		{
//			_frameCheck++;
//			if(_frameCheck >= 60)
//			{
//				checkNeigbor();
//				removeEventListener(Event.ENTER_FRAME, onCheckTime);
//			}
		}
		
		public function checkNeigbor():void
		{
			if(_block == null)
				return;
			
			var neigborTypes:Vector.<int> = NeigborType.TYPES;
			
			var neigbor:Cell;
			var twoNeigbor:Cell;
			var backNeigbor:Cell;
			for(var i:int = 0; i < neigborTypes.length; i++)
			{
				if(_neigbor[neigborTypes[i]] == null || _neigbor[neigborTypes[i]].neigbor[neigborTypes[i]] == null)
					continue;
				
				neigbor = _neigbor[neigborTypes[i]];
				twoNeigbor = _neigbor[neigborTypes[i]].neigbor[neigborTypes[i]];
				
				if(neigbor.block != null && twoNeigbor.block != null)
				{
					if(_block.attribute.type == neigbor.block.attribute.type && _block.attribute.type == twoNeigbor.block.attribute.type)
					{
						if(!_block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, _block));
						if(!neigbor.block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, neigbor.block));
						if(!twoNeigbor.block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, twoNeigbor.block));
						
						if(_neigbor[-neigborTypes[i]] != null && _neigbor[-neigborTypes[i]].block != null)
						{
							backNeigbor = _neigbor[-neigborTypes[i]];
							if(_block.attribute.type == backNeigbor.block.attribute.type)
							{
								if(!backNeigbor.block.distroyed)
									dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, backNeigbor.block));
							}
						}
					}
				}
			}
			neigbor = null;
			twoNeigbor = null;
			backNeigbor = null;
			
			for(var j:int = 0; j < neigborTypes.length; j++)
			{
				if(_neigbor[neigborTypes[j]] == null || _neigbor[-neigborTypes[j]] == null)
					continue;
				neigbor = _neigbor[neigborTypes[j]];
				backNeigbor = _neigbor[-neigborTypes[j]];
				if(neigbor.block != null && backNeigbor.block != null)
				{
					if(_block.attribute.type == neigbor.block.attribute.type && _block.attribute.type == backNeigbor.block.attribute.type)
					{
						if(!_block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, _block));
						if(!neigbor.block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, neigbor.block));
						if(!backNeigbor.block.distroyed)
							dispatchEvent(new Event(Distroyer.ADD_DISTROYER, false, backNeigbor.block));
					}
				}
			}
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

		public function get swaped():Boolean
		{
			return _swaped;
		}

		public function set swaped(value:Boolean):void
		{
			_swaped = value;
		}
	}
}