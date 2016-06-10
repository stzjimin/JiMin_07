package puzzle.stageSelect
{
	import customize.CheckBox;
	
	import puzzle.loading.Resources;
	import puzzle.user.User;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class SettingPopup extends DisplayObjectContainer
	{
		public static const CLICK_CLOSE:String = "clickClose";
		public static const BGM_SWAP_EMPTY:String = "bgmSwapEmpty";
		public static const BGM_SWAP_CHECK:String = "bgmSwapCheck";
		public static const EFFECT_SWAP_EMPTY:String = "effectSwapEmpty";
		public static const EFFECT_SWAP_CHECK:String = "effectSwapCheck";
		
		private var _backGround:Image;
		
		private var _closeButton:Button;
		
		private var _userPicture:Image;
		private var _userName:TextField;
		
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
			
			_userPicture = new Image(Texture.fromBitmap(User.getInstance().picture));
			_userPicture.width = width * 0.3;
			_userPicture.height = _userPicture.width;
			_userPicture.alignPivot();
			_userPicture.y = _backGround.height * 0.55;
			_userPicture.x = _backGround.width * 0.23;
			addChild(_userPicture);
			
			_userName = new TextField(_userPicture.width, height * 0.15, User.getInstance().name);
			_userName.format.bold = true;
			_userName.format.size = 20;
			_userName.alignPivot();
			_userName.x = _userPicture.x;
			_userName.y = _userPicture.y + (_userPicture.height/2) + (_userName.height/2);
			addChild(_userName);
			
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
			
			if(User.getInstance().bgmActive)
				_bgm.swapState();
			if(User.getInstance().soundEffectActive)
				_effect.swapState();
			
			_resources = null;
		}
		
		private function onEmptyEffect(event:Event):void
		{
			trace("effectEmpty");
			dispatchEvent(new Event(SettingPopup.EFFECT_SWAP_EMPTY));
		}
		
		private function onCheckEffect(event:Event):void
		{
			trace("effectCheck");
			dispatchEvent(new Event(SettingPopup.EFFECT_SWAP_CHECK));
		}
		
		private function onEmptyBGM(event:Event):void
		{
			trace("BGMEmpty");
			dispatchEvent(new Event(SettingPopup.BGM_SWAP_EMPTY));
		}
		
		private function onCheckBGM(event:Event):void
		{
			trace("BGMCheck");
			dispatchEvent(new Event(SettingPopup.BGM_SWAP_CHECK));
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