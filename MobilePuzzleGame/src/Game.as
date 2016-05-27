package
{
	import flash.display.Bitmap;
	
	import ingame.Field;
	import ingame.blocks.AttributeType;
	import ingame.blocks.BlockData;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Game extends DisplayObjectContainer
	{
		[Embed(source="19.png")]
		private const buttonImage:Class;
		
		[Embed(source="testBackGround.jpg")]
		private const testBackGroundImage:Class;
		
		private var _backGround:Image;
		
		private var _field:Field;
		private var _settingPopup:SettingPopup;
		private var _settingButton:Button;
		
		private var _testButton:Button;
		
		private var _blockDatas:Vector.<BlockData>;
		
		public function Game()
		{
			super();
			
			this.width = 576;
			this.height = 1024;
			
			_backGround = new Image(Texture.fromBitmap(new testBackGroundImage() as Bitmap));
			_backGround.width = 576;
			_backGround.height = 1024;
			addChild(_backGround);
			
			_blockDatas = new Vector.<BlockData>();
			_blockDatas.push(new BlockData(1, 8, AttributeType.BLUE));
			_blockDatas.push(new BlockData(1, 1, AttributeType.GREEN));
			_blockDatas.push(new BlockData(2, 1, AttributeType.GREEN));
			_blockDatas.push(new BlockData(6, 6, AttributeType.GREEN));
			_blockDatas.push(new BlockData(2, 2, AttributeType.PINK));
			_blockDatas.push(new BlockData(4, 3, AttributeType.PINK));
			_blockDatas.push(new BlockData(6, 4, AttributeType.GREEN));
			_blockDatas.push(new BlockData(2, 5, AttributeType.BLUE));
			_blockDatas.push(new BlockData(1, 4, AttributeType.GREEN));
			_blockDatas.push(new BlockData(1, 5, AttributeType.GREEN));
			_blockDatas.push(new BlockData(1, 2, AttributeType.BLUE));
			_blockDatas.push(new BlockData(5, 1, AttributeType.BLUE));
			_blockDatas.push(new BlockData(4, 2, AttributeType.PINK));
			_blockDatas.push(new BlockData(3, 6, AttributeType.PINK));
			_blockDatas.push(new BlockData(10, 10, AttributeType.MONKY));
			_blockDatas.push(new BlockData(10, 3, AttributeType.MONKY));
			_blockDatas.push(new BlockData(7, 10, AttributeType.CAT));
			_blockDatas.push(new BlockData(10, 5, AttributeType.CAT));
			_blockDatas.push(new BlockData(10, 5, AttributeType.CAT));
			_blockDatas.push(new BlockData(10, 1, AttributeType.CAT));
			_blockDatas.push(new BlockData(10, 2, AttributeType.CAT));
			_blockDatas.push(new BlockData(10, 8, AttributeType.CAT));
			_blockDatas.push(new BlockData(8, 5, AttributeType.CAT));
			_blockDatas.push(new BlockData(3, 5, AttributeType.CAT));
			_blockDatas.push(new BlockData(10, 9, AttributeType.CAT));
			_blockDatas.push(new BlockData(9, 3, AttributeType.CAT));
			_blockDatas.push(new BlockData(7, 5, AttributeType.CAT));
			
			_field = new Field();
			_field.x = 18;
			_field.y = 100;
			_field.init();
			addChild(_field);
			
			_settingButton = new Button(Texture.fromBitmap(new buttonImage() as Bitmap));
			_settingButton.x = 536;
			_settingButton.width = 40;
			_settingButton.height = 40;
			_settingButton.addEventListener(Event.TRIGGERED, onClickedSettingButton);
			addChild(_settingButton);
			
			_settingPopup = new SettingPopup(400, 300);
			addChild(_settingPopup);
			
			var blockData:BlockData;
			while(_blockDatas.length != 0)
			{
				blockData = _blockDatas.shift();
				_field.getCell(blockData.row, blockData.colum).createBlock(blockData.type);
			}
			blockData = null;
			
			_field.checkPossibleCell();
			
			trace(flash.display.Screen.mainScreen.bounds);
//			_field.freeCells();
//			_field.getCell(3,3).block.removeFromParent();
//			_field.getCell(3,3).block = null;
			
//			_button = new Button(Texture.fromBitmap(new buttonImage() as Bitmap));
//			_button.x = 10;
//			_button.y = 800;
//			_button.addEventListener(Event.TRIGGERED, onTriggered);
//			addChild(_button);
//			
//			_button = new Button(Texture.fromBitmap(new buttonImage() as Bitmap));
//			_button.x = 300;
//			_button.y = 800;
//			_button.addEventListener(Event.TRIGGERED, onTriggered2);
//			addChild(_button);
			
//			this.alignPivot();
//			
//			this.x = flash.display.Screen.mainScreen.bounds.width / 2;
//			this.y = flash.display.Screen.mainScreen.bounds.height / 2;
//			
//			this.width = flash.display.Screen.mainScreen.bounds.width /11 * 10; 
//			this.height = flash.display.Screen.mainScreen.bounds.height /11 * 10;
		}
		
		private function onClickedSettingButton(event:Event):void
		{
			_settingPopup.visible = !_settingPopup.visible;
		}
		
		private function onTriggered2(event:Event):void
		{
			_field.initPossibleChecker();
		}
		
		private function onTriggered(event:Event):void
		{
			_field.checkPossibleCell();
		}
	}
}