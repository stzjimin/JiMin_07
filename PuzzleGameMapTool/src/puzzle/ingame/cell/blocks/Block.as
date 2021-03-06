package puzzle.ingame.cell.blocks
{	
	import flash.display.Bitmap;
	
	import puzzle.ingame.cell.Cell;
	import puzzle.ingame.util.possibleCheck.PossibleCheckerEventType;
	import puzzle.loading.Resources;
	
	import starling.animation.IAnimatable;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Block extends DisplayObjectContainer implements IAnimatable
	{	
		public static const PADDING_SIZE:Number = 5;
		
		private var _resources:Resources;
		
		private var _blockRightPadding:Image;
		private var _blockBottomPadding:Image;
		private var _blockImage:Image;
		
		private var _blockTexture:Texture;
		private var _type:String;
		private var _skill:String;
		
		private var _distroyed:Boolean = false;
		
		private var _clicked:Boolean;
		private var _originScale:Number;
		
		public function Block(resources:Resources)
		{	
			super();
			
			_resources = resources;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
//			addEventListener(Event.TRIGGERED, onTriggered);
		}
		
		public function init(blockData:BlockData):void
		{
			_clicked = false;
			
			_type = blockData.type;
			this.name = blockData.type;
			_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", _type);
			if(_type == BlockType.WALL)
				this.touchable = false;
			
//			var type:String = blockData.type;
//			if(type == BlockType.PINKY)
//			{
//				_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "pinky");
//				_type = BlockType.PINKY;
//				this.name = BlockType.PINKY;
//			}
//			else if(type == BlockType.BLUE)
//			{
//				_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "blue");
//				_type = BlockType.BLUE;
//				this.name = BlockType.BLUE;
//			}
//			else if(type == BlockType.MICKY)
//			{
//				_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "micky");
//				_type = BlockType.MICKY;
//				this.name = BlockType.MICKY;
//			}
//			else if(type == BlockType.LUCY)
//			{
//				_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "lucy");
//				_type = BlockType.LUCY;
//				this.name = BlockType.LUCY;
//			}
//			else if(type == BlockType.MONGYI)
//			{
//				_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "mongyi");
//				_type = BlockType.MONGYI;
//				this.name = BlockType.MONGYI;
//			}
//			else if(type == BlockType.WALL)
//			{
//				_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "wall");
//				_type = BlockType.WALL;
//				this.name = BlockType.WALL;
//				this.touchable = false;
//			}
			
			_blockImage = new Image(_blockTexture);
			_blockImage.x = -Block.PADDING_SIZE;
			_blockImage.y = -Block.PADDING_SIZE;
			_blockImage.width = Cell.WIDTH_SIZE;
			_blockImage.height = Cell.HEIGHT_SIZE;
			addChild(_blockImage);
			
			_blockRightPadding = new Image(_resources.getSubTexture("FieldSpriteSheet.png", "blockRightPadding"));
			_blockRightPadding.x = Cell.WIDTH_SIZE - Block.PADDING_SIZE;
			_blockRightPadding.width = Block.PADDING_SIZE;
			_blockRightPadding.height = Cell.HEIGHT_SIZE;
			addChild(_blockRightPadding);
			
			_blockBottomPadding = new Image(_resources.getSubTexture("FieldSpriteSheet.png", "blockBottomPadding"));
			_blockBottomPadding.y = Cell.HEIGHT_SIZE - Block.PADDING_SIZE;
			_blockBottomPadding.width = Cell.WIDTH_SIZE;
			_blockBottomPadding.height = Block.PADDING_SIZE;
			addChild(_blockBottomPadding);
//			this.pivotX = this.width/2;
//			this.pivotY = this.height/2;
//			this.x = this.width/2;
//			this.y = this.height/2;
		}
		
		public function destroy():void
		{	
			_blockImage.removeFromParent();
			_blockImage.dispose();
			
			_blockRightPadding.removeFromParent();
			_blockRightPadding.dispose();
			
			_blockBottomPadding.removeFromParent();
			_blockBottomPadding.dispose();
			
			removeEventListener(TouchEvent.TOUCH, onTouch);
			removeFromParent();
			
			removeChildren(0, this.numChildren);
			
			dispose();
		}
		
		public function pullPrev():void
		{
			_clicked = false;
			this.scale = 1.0;
		}
		
		private function selectTexture(type:String):void
		{
			switch(type)
			{
				case BlockType.ARI :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "ari");
					break;
				case BlockType.ARI_CIRCLE :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "ari_circle");
					break;
				case BlockType.ARI_LINE :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "ari_line");
					break;
				case BlockType.BLUE :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "blue");
					break;
				case BlockType.BLUE_CIRCLE :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "blue_circle");
					break;
				case BlockType.BLUE_LINE :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "blue_line");
					break;
				case BlockType.LUCY :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "lucy");
					break;
				case BlockType.LUCY_CIRCLE :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "lucy_circle");
					break;
				case BlockType.LUCY_LINE :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "lucy_line");
					break;
				case BlockType.MICKY :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "micky");
					break;
				case BlockType.MICKY_CIRCLE :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "micky_circle");
					break;
				case BlockType.MICKY_LINE :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "micky_line");
					break;
				case BlockType.MONGYI :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "mongyi");
					break;
				case BlockType.MONGYI_CIRCLE :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "mongyi_circle");
					break;
				case BlockType.MONGYI_LINE :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "mongyi_line");
					break;
				case BlockType.PINKY :
					_blockTexture = _resources.getSubTexture("FieldSpriteSheet.png", "pinky");
					break;	
			}
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if(touch == null)
				return;
			if(touch.phase == TouchPhase.BEGAN)
			{
				this.y -= 10;
//				_originScale = this.scale;
				this.scale = 1.2;
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this.scale = 1.0;
				this.y += 10;
				_clicked = !_clicked;
				if(_clicked)
				{
					this.scale = 0.9;
					parent.dispatchEvent(new Event(PossibleCheckerEventType.ADD_PREV));
				}
				else
				{
					parent.dispatchEvent(new Event(PossibleCheckerEventType.OUT_CHECKER));
				}
			}
		}
		
//		public function onTriggered():void
//		{
////			trace(Cell(Cell(parent).neigbor[NeigborType.TOP]).block.type);
//			_clicked = !_clicked;
//			if(_clicked)
//			{
//				this.scale = 0.9;
//				parent.dispatchEvent(new Event(CheckEvent.ADD_PREV));
//			}
//			else
//			{
//				parent.dispatchEvent(new Event(CheckEvent.OUT_CHECKER));
//			}
//		}
		
		public function advanceTime(time:Number):void
		{
			
		}

		public function get distroyed():Boolean
		{
			return _distroyed;
		}

		public function set distroyed(value:Boolean):void
		{
			_distroyed = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get skill():String
		{
			return _skill;
		}

		public function set skill(value:String):void
		{
			_skill = value;
		}


	}
}