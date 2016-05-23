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
		
		public function Game()
		{
			GravityManager.gravity = GravityType.DOWN;
			
			_field = new Field();
			addChild(_field);
//			_field.getCell(5,5).block.removeFromParent();
//			_field.getCell(5,5).block = null;
			
			_button = new Button(Texture.fromBitmap(new buttonImage() as Bitmap));
			_button.x = 10;
			_button.y = 900;
			_button.addEventListener(Event.TRIGGERED, onTriggered);
			addChild(_button);
		}
		
		private function onTriggered(event:Event):void
		{
			_field.dispatchEvent(new Event("testButton"));
		}
	}
}