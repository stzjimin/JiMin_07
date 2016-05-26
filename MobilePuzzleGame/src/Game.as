package
{
	import flash.display.Bitmap;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Game extends DisplayObjectContainer
	{
		[Embed(source="19.png")]
		private const buttonImage:Class;
		
		private var _field:Field;
		private var _button:Button;
		
		private var _blockDatas:Vector.<BlockData>;
		
		public function Game()
		{
			_blockDatas = new Vector.<BlockData>();
			_blockDatas.push(new BlockData(1, 9, AttributeType.BLUE));
			_blockDatas.push(new BlockData(1, 1, AttributeType.GREEN));
			_blockDatas.push(new BlockData(2, 1, AttributeType.GREEN));
			_blockDatas.push(new BlockData(6, 6, AttributeType.GREEN));
			_blockDatas.push(new BlockData(2, 2, AttributeType.RED));
			_blockDatas.push(new BlockData(4, 3, AttributeType.RED));
			_blockDatas.push(new BlockData(6, 4, AttributeType.GREEN));
			_blockDatas.push(new BlockData(2, 5, AttributeType.BLUE));
			_blockDatas.push(new BlockData(1, 4, AttributeType.GREEN));
			_blockDatas.push(new BlockData(1, 5, AttributeType.GREEN));
			_blockDatas.push(new BlockData(1, 2, AttributeType.BLUE));
			_blockDatas.push(new BlockData(5, 1, AttributeType.BLUE));
			_blockDatas.push(new BlockData(4, 2, AttributeType.RED));
			_blockDatas.push(new BlockData(3, 6, AttributeType.RED));
			
			_field = new Field();
			addChild(_field);
			
			var blockData:BlockData;
			while(_blockDatas.length != 0)
			{
				blockData = _blockDatas.shift();
				_field.getCell(blockData.row, blockData.colum).createBlock(blockData.type);
			}
			blockData = null;
			
//			_field.checkPossibleCell();
//			_field.freeCells();
//			_field.getCell(3,3).block.removeFromParent();
//			_field.getCell(3,3).block = null;
			
			_button = new Button(Texture.fromBitmap(new buttonImage() as Bitmap));
			_button.x = 10;
			_button.y = 800;
			_button.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_button);
		}
		
		private function onTriggered(event:Event):void
		{
			_field.checkPossibleCell();
		}
	}
}