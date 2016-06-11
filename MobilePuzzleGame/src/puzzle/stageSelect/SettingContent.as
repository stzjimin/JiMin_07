package puzzle.stageSelect
{
	import customize.CheckBox;
	
	import puzzle.loading.Resources;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class SettingContent extends DisplayObjectContainer
	{	
		private var _resources:Resources;
		
		private var _text:TextField;
		private var _backGround:Image;
		private var _checkBox:CheckBox;
		
		public function SettingContent(resources:Resources)
		{
			_resources = resources;
			
			super();
		}
		
		public function init(width:Number, height:Number, contentName:String):void
		{	
			_backGround = new Image(_resources.getSubTexture("stageSelectSceneSprite0.png", "settingPopupFrame"));
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
			
			_checkBox = new CheckBox(_resources.getSubTexture("stageSelectSceneSprite0.png", "CheckBoxOFF"), _resources.getSubTexture("stageSelectSceneSprite0.png", "CheckBoxON"));
			_checkBox.width = width * 0.2;
			_checkBox.height = _checkBox.width;
			_checkBox.alignPivot();
			_checkBox.x = (width * 0.85);
			_checkBox.y = (height / 2);
			_checkBox.addEventListener(CheckBox.SWAP_CHECK, onSwapCheck);
			_checkBox.addEventListener(CheckBox.SWAP_EMPTY, onSwapEmpty);
			addChild(_checkBox);
			
			_resources = null;
		}
		
		public function destroy():void
		{
			_checkBox.removeEventListener(CheckBox.SWAP_CHECK, onSwapCheck);
			_checkBox.removeEventListener(CheckBox.SWAP_EMPTY, onSwapEmpty);
			_checkBox.destroy();
			_checkBox = null;
			
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_text.removeFromParent();
			_text.dispose();
			_text = null;
			
			dispose();
		}
		
		public function swapState():void
		{
			_checkBox.dispatchEvent(new Event(Event.TRIGGERED));
		}
		
		private function onSwapCheck(event:Event):void
		{
			trace("check");
			dispatchEvent(new Event(CheckBox.SWAP_CHECK));
		}
		
		private function onSwapEmpty(event:Event):void
		{
			trace("empty");
			dispatchEvent(new Event(CheckBox.SWAP_EMPTY));
		}
	}
}