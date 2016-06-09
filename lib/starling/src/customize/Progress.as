package customize
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;

	public class Progress extends DisplayObjectContainer
	{
		[Embed(source="progressCircle.png")]
		private const defaultImage:Class;
		
		private var _circle:Image;
		
		public function Progress()
		{
			super();	
		}
		
		public function init(width:Number, height:Number, circleTexture:Texture = null):void
		{
			var texture:Texture;
			if(circleTexture == null)
				texture = Texture.fromBitmap(new defaultImage() as Bitmap);
			else
				texture = circleTexture;
			
			_circle = new Image(texture);
			_circle.width;
			_circle.height;
			_circle.alignPivot();
			addChild(_circle);
		}
		
		public function destroy():void
		{
			_circle.removeFromParent();
			_circle.dispose();
			_circle = null;
			
			dispose();
		}
		
		public function start():void
		{
			rotate();
		}
		
		public function stop():void
		{
			TweenMax.killAll();
		}
		
		private function rotate():void
		{
			trace("aa");
			TweenMax.to(_circle, 1, {rotation:360, onComplete:rotate});
		}
	}
}