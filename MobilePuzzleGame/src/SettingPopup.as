package
{
	import flash.display.Bitmap;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class SettingPopup extends Popup
	{	
		[Embed(source="popup.png")]
		private const testPopupImage:Class;
		
		[Embed(source="19.png")]
		private const testButtonImage:Class;
		
		[Embed(source="iu3.jpg")]
		private const testButtonImage2:Class;
		
		public static const CLICK_CLOSE:String = "clickedClose"; 
		
		private var _closeButton:Button;
		private var _bgmCheckButton:CheckBox;
		private var _effectCheckButton:CheckBox;
		
		private var _profileImage:Image;
		private var _profileText:TextField;

		public function SettingPopup(width:Number, height:Number)
		{
			super(Texture.fromBitmap(new testPopupImage() as Bitmap), width, height);
			
			_closeButton = new Button(Texture.fromBitmap(new testButtonImage() as Bitmap));
			_closeButton.width = _closeButton.height = 20;
			_closeButton.x = width - _closeButton.width;
			_closeButton.addEventListener(Event.TRIGGERED, onClickedCloseButton);
			addChild(_closeButton);
			
			_bgmCheckButton = new CheckBox(Texture.fromBitmap(new testButtonImage() as Bitmap), Texture.fromBitmap(new testButtonImage2() as Bitmap));
			_bgmCheckButton.width = _bgmCheckButton.height = 20;
			_bgmCheckButton.x = (width / 2);
			_bgmCheckButton.y = (height / 2);
			addChild(_bgmCheckButton);
			
			_effectCheckButton = new CheckBox(Texture.fromBitmap(new testButtonImage() as Bitmap), Texture.fromBitmap(new testButtonImage2() as Bitmap));
			_effectCheckButton.width = _effectCheckButton.height = 20;
			_effectCheckButton.x = (width / 2);
			_effectCheckButton.y = (height / 2) + 30;
			addChild(_effectCheckButton);
		}
		
		public function distroy():void
		{
			_closeButton.removeEventListener(Event.TRIGGERED, onClickedCloseButton);
		}
		
		private function onClickedCloseButton(event:Event):void
		{
			
		}
	}
}