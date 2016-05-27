package
{
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;

	public class CheckBox extends Button
	{
		public static const SWAP_EMPTY:String = "swapEmpty";
		public static const SWAP_CHECK:String = "swapCheck";
		
		private var _emptyTexture:Texture;
		private var _checkTexture:Texture;
		
		private var _checked:Boolean;
		
		public function CheckBox(emptyTexture:Texture, checkTexture:Texture)
		{
			_emptyTexture = emptyTexture;
			_checkTexture = checkTexture;
			_checked = false;
			
			addEventListener(Event.TRIGGERED, onTriggered);
			
			super(emptyTexture);
		}
		
		private function onTriggered(event:Event):void
		{
			_checked = !_checked;
			if(_checked)
			{
				super.upState = _checkTexture;
				dispatchEvent(new Event(CheckBox.SWAP_CHECK));
			}
			else
			{
				super.upState = _emptyTexture;
				dispatchEvent(new Event(CheckBox.SWAP_EMPTY));
			}
		}
		
		public function distroy():void
		{
			removeEventListener(Event.TRIGGERED, onTriggered);
		}
	}
}