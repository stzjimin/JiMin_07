package puzzle.stageSelect
{
	import customize.CheckBox;
	
	import puzzle.loading.Resources;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.utils.Align;

	public class SettingPopup extends DisplayObjectContainer
	{
		public static const CLICK_CLOSE:String = "clickClose";
		
		private var _backGround:Image;
		
		private var _closeButton:Button;
		
		private var _bgm:SettingContent;
		private var _effect:SettingContent;
		
		private var _resources:Resources;
		
		public function SettingPopup(resources:Resources)
		{
			_resources = resources;
			
			super();
		}
		
		public function init(width:Number, height:Number):void
		{
			_backGround = new Image(_resources.getSubTexture("stageSelectSceneSprite0.png", "settingPopup"));
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			_closeButton = new Button(_resources.getSubTexture("stageSelectSceneSprite0.png", "settingPopupCloseButton2"));
			_closeButton.width = width * 0.15;
			_closeButton.height = height * 0.2;
			_closeButton.alignPivot(Align.RIGHT, Align.TOP);
			_closeButton.x = _backGround.width;
			_closeButton.y = (height * 0.01);
			_closeButton.addEventListener(Event.TRIGGERED, onClickedCloseButton);
			addChild(_closeButton);
			
			_bgm = new SettingContent(_resources);
			_bgm.init(width * 0.4, height * 0.2, "BGM");
			_bgm.x = (width * 0.5);
			_bgm.y = (height * 0.35);
			_bgm.addEventListener(CheckBox.SWAP_CHECK, onCheckBGM);
			_bgm.addEventListener(CheckBox.SWAP_EMPTY, onEmptyBGM);
			addChild(_bgm);
			
			_effect = new SettingContent(_resources);
			_effect.init(width * 0.4, height * 0.2, "EFFECT");
			_effect.x = (width * 0.5);
			_effect.y = (height * 0.65);
			_effect.addEventListener(CheckBox.SWAP_CHECK, onCheckEffect);
			_effect.addEventListener(CheckBox.SWAP_EMPTY, onEmptyEffect);
			addChild(_effect);
			
			_resources = null;
		}
		
		private function onEmptyEffect(event:Event):void
		{
			trace("effectEmpty");
		}
		
		private function onCheckEffect(event:Event):void
		{
			trace("effectCheck");
		}
		
		private function onEmptyBGM(event:Event):void
		{
			trace("BGMEmpty");
		}
		
		private function onCheckBGM(event:Event):void
		{
			trace("BGMCheck");
		}
		
		public function destroy():void
		{
			_closeButton.removeEventListener(Event.TRIGGERED, onClickedCloseButton);
			_closeButton.removeFromParent();
			_closeButton.dispose();
			_closeButton = null;
			
			_bgm.removeEventListener(CheckBox.SWAP_CHECK, onCheckBGM);
			_bgm.removeEventListener(CheckBox.SWAP_EMPTY, onEmptyBGM);
			_bgm.removeFromParent();
			_bgm.destroy();
			_bgm = null;
			
			_effect.removeEventListener(CheckBox.SWAP_CHECK, onCheckBGM);
			_effect.removeEventListener(CheckBox.SWAP_EMPTY, onEmptyBGM);
			_effect.removeFromParent();
			_effect.destroy();
			_effect = null;
		}
		
		private function onClickedCloseButton(event:Event):void
		{
			dispatchEvent(new Event(SettingPopup.CLICK_CLOSE));
		}
	}
}