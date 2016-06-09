package customize
{	
	import flash.display.Bitmap;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Progress extends DisplayObjectContainer implements IAnimatable
	{
		[Embed(source="defaultProgress.png")]
		private const defaultImage:Class;
		
		[Embed(source="defaultProgress.xml", mimeType="application/octet-stream")]
		private const defaultXML:Class;
		
		private var _juggler:Juggler;
		private var _started:Boolean;
		
		private var _texturAtlas:TextureAtlas;
		private var _progress:MovieClip;
		
		public function Progress()
		{
			_juggler = new Juggler();
			_started = false;
			super();	
		}
		
		public function init(width:Number, height:Number, progress:MovieClip = null):void
		{
			if(progress == null)
			{
				var xml:XML = XML(new defaultXML());
				_texturAtlas = new TextureAtlas(Texture.fromBitmap(new defaultImage() as Bitmap), xml);
				var frames:Vector.<Texture> = _texturAtlas.getTextures("frame_");
				_progress = new MovieClip(frames, 10);
			}
			else
				_progress = progress;
			
			_progress.width = width;
			_progress.height = height;
			_progress.alignPivot();
			addChild(_progress);
			_juggler.add(_progress);
		}
		
		public function destroy():void
		{
			_juggler.purge();
			
			_progress.removeFromParent();
			_progress.dispose();
			_progress = null;
			
			dispose();
		}
		
		public function advanceTime(time:Number):void
		{
			if(_started)
				_juggler.advanceTime(time);
		}
		
		public function start():void
		{
			_started = true;
		}
		
		public function stop():void
		{
			_started = false;
		}
	}
}