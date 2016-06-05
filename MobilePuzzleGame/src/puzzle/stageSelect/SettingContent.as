package puzzle.stageSelect
{
	import flash.display.Bitmap;
	
	import customize.CheckBox;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class SettingContent extends DisplayObjectContainer
	{
		[Embed(source="settingPopupFrame.png")]
		private const popupFrameImage:Class;
		
		[Embed(source="CheckBoxON.png")]
		private const buttonOnImage:Class;
		
		[Embed(source="CheckBoxOFF.png")]
		private const buttonOffImage:Class;
		
		private var _text:TextField;
		
		private var _backGround:Image;
		
		private var _checkBox:CheckBox;
		
		public function SettingContent()
		{
			super();
		}
		
		public function init(width:Number, height:Number, contentName:String):void
		{	
			_backGround = new Image(Texture.fromBitmap(new popupFrameImage() as Bitmap));
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			_text = new TextField(width * 0.3, height * 0.8, contentName);
			_text.width = width * 0.5;
			_text.height = height * 0.8;
			_text.alignPivot();
			_text.x = width * 0.3;
			_text.y = (height / 2);
			_text.format.bold = true;
			_text.format.size = height * 0.3;
			addChild(_text);
			
			_checkBox = new CheckBox(Texture.fromBitmap(new buttonOffImage() as Bitmap), Texture.fromBitmap(new buttonOnImage() as Bitmap));
			_checkBox.width = width * 0.2;
			_checkBox.height = _checkBox.width;
			_checkBox.alignPivot();
			_checkBox.x = (width * 0.85);
			_checkBox.y = (height / 2);
			_checkBox.addEventListener(CheckBox.SWAP_CHECK, onSwapCheck);
			_checkBox.addEventListener(CheckBox.SWAP_EMPTY, onSwapEmpty);
			addChild(_checkBox);
		}
		
		public function destroy():void
		{
			_checkBox.removeEventListener(CheckBox.SWAP_CHECK, onSwapCheck);
			_checkBox.removeEventListener(CheckBox.SWAP_EMPTY, onSwapEmpty);
			_checkBox.destroy();
			
			_backGround.removeFromParent();
			_backGround.dispose();
			
			_text.removeFromParent();
			_text.dispose();
			
			dispose();
		}
		
		private function onSwapCheck(event:Event):void
		{
			dispatchEvent(new Event(CheckBox.SWAP_CHECK));
		}
		
		private function onSwapEmpty(event:Event):void
		{
			dispatchEvent(new Event(CheckBox.SWAP_EMPTY));
		}
	}
}