package ingame.cell.blocks
{
	import flash.display.Bitmap;
	
	import ingame.cell.Cell;
	import ingame.util.possibleCheck.CheckEvent;
	
	import starling.animation.IAnimatable;
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Block extends Button implements IAnimatable
	{
		[Embed(source="pinky.png")]
		private const testImage0:Class;
		
		[Embed(source="blue.png")]
		private const testImage1:Class;
		
		[Embed(source="micky.png")]
		private const testImage2:Class;
		
		[Embed(source="lucy.png")]
		private const testImage3:Class;
		
		[Embed(source="mongyi.png")]
		private const testImage4:Class;
		
		private var _blockTexture:Texture;
		private var _type:String;
		private var _skill:String;
		
		private var _distroyed:Boolean = false;
		
		private var _clicked:Boolean;
		
		public function Block(blockData:BlockData)
		{
			_clicked = false;
			
			var type:String = blockData.type;
			if(type == BlockType.PINKY)
			{
				_blockTexture = Texture.fromBitmap(new testImage0() as Bitmap);
				_type = BlockType.PINKY;
				this.name = "pink";
			}
			else if(type == BlockType.BLUE)
			{
				_blockTexture = Texture.fromBitmap(new testImage1() as Bitmap);
				_type = BlockType.BLUE;
				this.name = "blue";
			}
			else if(type == BlockType.MICKY)
			{
				_blockTexture = Texture.fromBitmap(new testImage2() as Bitmap);
				_type = BlockType.MICKY;
				this.name = "green";
			}			
			else if(type == BlockType.LUCY)
			{
				_blockTexture = Texture.fromBitmap(new testImage3() as Bitmap);
				_type = BlockType.LUCY;
				this.name = "cat";
			}
			else if(type == BlockType.MONGYI)
			{
				_blockTexture = Texture.fromBitmap(new testImage4() as Bitmap);
				_type = BlockType.MONGYI;
				this.name = "monky";
			}
			
			super(_blockTexture);
			
			addEventListener(Event.TRIGGERED, onTriggered);
		}
		
		public function init():void
		{	
			this.pivotX = this.width/2;
			this.pivotY = this.height/2;
			this.x = this.width/2;
			this.y = this.height/2;
		}
		
		public function onTriggered():void
		{
//			trace(Cell(Cell(parent).neigbor[NeigborType.TOP]).block.type);
			_clicked = !_clicked;
			if(_clicked)
			{
				this.scale = 0.9;
				parent.dispatchEvent(new Event(CheckEvent.ADD_PREV));
			}
			else
			{
				parent.dispatchEvent(new Event(CheckEvent.OUT_CHECKER));
			}
		}
		
		public function pullPrev():void
		{
			_clicked = false;
			this.scale = 1.0;
		}
		
		public function distroy():void
		{
//			var parent:Cell = Cell(this.parent);
//			parent.block = null;
			removeFromParent(true);
			
			dispose();
		}
		
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