package
{
	import flash.display.Bitmap;
	
	import ingame.Field;
	import ingame.cell.blocks.AttributeType;
	import ingame.cell.blocks.BlockData;
	import ingame.cell.blocks.BlockType;
	
	import starling.animation.Juggler;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Game extends DisplayObjectContainer
	{
		[Embed(source="19.png")]
		private const buttonImage:Class;
		
		[Embed(source="testBackGround.jpg")]
		private const testBackGroundImage:Class;
		
		private var _backGround:Image;
		
		private var _paused:Boolean;
		private var _timer:Timer;
		
		private var _field:Field;
		private var _settingPopup:SettingPopup;
		private var _settingButton:Button;
		
		private var _testButton:Button;
		
		private var _blockDatas:Vector.<BlockData>;
		
		public function Game()
		{
			super();
			
			_paused = false;
			
			this.width = 576;
			this.height = 1024;
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			
			_backGround = new Image(Texture.fromBitmap(new testBackGroundImage() as Bitmap));
			_backGround.width = 576;
			_backGround.height = 1024;
			addChild(_backGround);
			
			_timer = new Timer();
			
			_blockDatas = new Vector.<BlockData>();
			_blockDatas.push(new BlockData(1, 8, BlockType.BLUE));
			_blockDatas.push(new BlockData(1, 1, BlockType.GREEN));
			_blockDatas.push(new BlockData(2, 1, BlockType.GREEN));
			_blockDatas.push(new BlockData(6, 6, BlockType.GREEN));
			_blockDatas.push(new BlockData(2, 2, BlockType.PINK));
			_blockDatas.push(new BlockData(4, 3, BlockType.PINK));
			_blockDatas.push(new BlockData(6, 4, BlockType.GREEN));
			_blockDatas.push(new BlockData(2, 5, BlockType.BLUE));
			_blockDatas.push(new BlockData(1, 4, BlockType.GREEN));
			_blockDatas.push(new BlockData(1, 5, BlockType.GREEN));
			_blockDatas.push(new BlockData(1, 2, BlockType.BLUE));
			_blockDatas.push(new BlockData(5, 1, BlockType.BLUE));
			_blockDatas.push(new BlockData(4, 2, BlockType.PINK));
			_blockDatas.push(new BlockData(3, 6, BlockType.PINK));
			_blockDatas.push(new BlockData(10, 10, BlockType.MONKY));
			_blockDatas.push(new BlockData(10, 3, BlockType.MONKY));
			_blockDatas.push(new BlockData(7, 10, BlockType.CAT));
			_blockDatas.push(new BlockData(10, 5, BlockType.CAT));
			_blockDatas.push(new BlockData(10, 5, BlockType.CAT));
			_blockDatas.push(new BlockData(10, 1, BlockType.CAT));
			_blockDatas.push(new BlockData(10, 2, BlockType.CAT));
			_blockDatas.push(new BlockData(10, 8, BlockType.CAT));
			_blockDatas.push(new BlockData(8, 5, BlockType.CAT));
			_blockDatas.push(new BlockData(3, 5, BlockType.CAT));
			_blockDatas.push(new BlockData(10, 9, BlockType.CAT));
			_blockDatas.push(new BlockData(9, 3, BlockType.CAT));
			_blockDatas.push(new BlockData(7, 5, BlockType.CAT));
			
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
				_field.createBlock(blockData);
			}
			blockData = null;
			
			_field.checkPossibleCell();
			
			trace(flash.display.Screen.mainScreen.bounds);
//			_field.freeCells();
//			_field.getCell(3,3).block.removeFromParent();
//			_field.getCell(3,3).block = null;
			
			_testButton = new Button(Texture.fromBitmap(new buttonImage() as Bitmap));
			_testButton.x = 10;
			_testButton.y = 800;
			_testButton.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_testButton);
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
		
		public function distroy():void
		{
			_settingButton.removeEventListener(Event.TRIGGERED, onClickedSettingButton);
			
			dispose();
		}
		
		private function onEnterFrame(event:EnterFrameEvent):void
		{
			if(!_paused)
			{
				_timer.advanceTime(event.passedTime);
				_field.advanceTime(event.passedTime);
			}
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
			_paused = !_paused;
			if(_paused)
				_field.touchable = false;
			else
				_field.touchable = true;
//			_field.checkPossibleCell();
		}
	}
}