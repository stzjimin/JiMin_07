package
{
	import flash.display.Bitmap;
	
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Block extends Button
	{
		[Embed(source="19.png")]
		private const testImage:Class;
		
		private var _blockTexture:Texture;
		
		public function Block()
		{
			_blockTexture = Texture.fromBitmap(new testImage() as Bitmap);
			super(_blockTexture);
			
			addEventListener(Event.TRIGGERED, onTriggered);
		}
		
		public function distroy():void
		{
			removeEventListener(Event.TRIGGERED, onTriggered);
			dispose();
		}
		
		public function onTriggered():void
		{
			if(this.parent != null)
				this.parent.dispatchEvent(new Event("blockTriggered"));
		}
	}
}