package puzzle.loading
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import customize.Sound;
	
	import puzzle.loading.loader.SpriteLoader;
	
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Resources extends EventDispatcher
	{	
		public static const SpriteDir:File = File.applicationDirectory.resolvePath("puzzle/resources/spriteSheet");
		public static const SoundDir:File = File.applicationDirectory.resolvePath("puzzle/resources/sound");
		public static const ImageDir:File = File.applicationDirectory.resolvePath("puzzle/resources/image");
		
		private var _spriteSheetDic:Dictionary;
		private var _soundDic:Dictionary;
		private var _imageDic:Dictionary;
		
		private var _spriteName:Vector.<String>;
		private var _soundName:Vector.<String>;
		private var _imageName:Vector.<String>;

		private var _spriteDir:File;
		private var _soundDir:File;
		private var _imageDir:File;
		
		private var _loadedCount:uint;
		
		public function Resources(spriteDirectory:File = null, soundDirectory:File = null, imageDirectory:File = null)
		{
			_spriteSheetDic = new Dictionary();
			_soundDic = new Dictionary();
			_imageDic = new Dictionary();
			
			_spriteName = new Vector.<String>();
			_soundName = new Vector.<String>();
			_imageName = new Vector.<String>();
			
			_loadedCount = 0;
			
			_spriteDir = spriteDirectory;
			_soundDir = soundDirectory;
			_imageDir = imageDirectory;
		}
		
		public function getTotalLoadCount():int
		{
			return (_spriteName.length + _soundName.length + _imageName.length);
		}
		
		public function destroy():void
		{
			if(_spriteSheetDic)
			{
				for(var key:String in _spriteSheetDic)
				{
					delete _spriteSheetDic[key];
				}
				_spriteSheetDic = null;
			}
			
			if(_soundDic)
			{
				for(key in _soundDic)
				{
					delete _soundDic[key];
				}
				_soundDic = null;
			}
			
			if(_imageDic)
			{
				for(key in _imageDic)
				{
					delete _imageDic[key];
				}
				_imageDic = null;
			}
		}
		
		public function loadResource():void
		{
			if (_spriteDir) trace(_spriteDir.url);
			if (_soundDir)	trace(_soundDir.url);
			
			if(_spriteDir != null)
			{
				var spriteLoader:SpriteLoader;
				for(var i:int = 0; i < _spriteName.length; i++)
				{
					spriteLoader = new SpriteLoader(onCompleteSpriteLoad, onFaildSpriteLoad);
					spriteLoader.loadSprite(_spriteDir.resolvePath(_spriteName[i]).url, _spriteName[i]);
				}
				spriteLoader = null;
			}
			
			if(_imageDir != null)
			{
				var imageLoader:Loader;
				var imageURLRequest:URLRequest;
				for(var j:int = 0; j < _imageName.length; j++)
				{
					trace(_imageDir.resolvePath(_imageName[j]).url);
					imageURLRequest = new URLRequest(_imageDir.resolvePath(_imageName[j]).url);
					imageLoader = new Loader();
					imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
					imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadedFailed);
					imageLoader.load(imageURLRequest);
				}
				imageLoader = null;
				imageURLRequest = null;
			}
			
			if(_soundDir != null)
			{
				var sound:Sound;
				var soundURLRequest:URLRequest;
				for(var k:int = 0; k < _soundName.length; k++)
				{
					soundURLRequest = new URLRequest(_soundDir.resolvePath(_soundName[k]).url);
					sound = new Sound();
					sound.addEventListener(Event.COMPLETE, onSoundLoaded);
					sound.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFailed);
					sound.load(soundURLRequest);
				}
				sound = null;
				soundURLRequest = null;
			}
		}
		
		private function onImageLoaded(event:Event):void
		{
			var imageFileName:String = LoaderInfo(event.currentTarget).url.replace(_imageDir.url.toString()+"/", "");
			trace(imageFileName);
			var imageBitmap:Bitmap = LoaderInfo(event.currentTarget).loader.content as Bitmap;
			var imageTexture:Texture = Texture.fromBitmap(imageBitmap);
			_imageDic[imageFileName] = imageTexture;
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onImageLoaded);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadedFailed);
			
			_loadedCount++;
			checkLoadComplete(imageFileName);
		}
		
		private function onImageLoadedFailed(event:IOErrorEvent):void
		{
			LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onImageLoaded);
			LoaderInfo(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadedFailed);
			
			dispatchEvent(new LoadingEvent(LoadingEvent.FAILED, event.text));
		}
		
		private function onSoundLoaded(event:Event):void
		{
			trace(Sound(event.currentTarget).url.replace(_soundDir.url.toString()+"/", ""));
			var soundFileName:String = Sound(event.currentTarget).url.replace(_soundDir.url.toString()+"/", "");
			_soundDic[soundFileName] = event.currentTarget as Sound;
			Sound(event.currentTarget).removeEventListener(Event.COMPLETE, onSoundLoaded);
			Sound(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFailed);
			
//			SoundManager.addSound(soundFileName, _soundDic[soundFileName]);
			
			_loadedCount++;
			checkLoadComplete(soundFileName);
		}
		
		private function onSoundLoadFailed(event:IOErrorEvent):void
		{
			Sound(event.currentTarget).removeEventListener(Event.COMPLETE, onSoundLoaded);
			Sound(event.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadFailed);
			
			dispatchEvent(new LoadingEvent(LoadingEvent.FAILED, event.text));
		}
		
		private function onCompleteSpriteLoad(name:String, spriteBitmap:Bitmap, xml:XML):void
		{
//			var spriteSheet:SpriteSheet = new SpriteSheet(name, spriteBitmap, xml);
			var spriteSheet:TextureAtlas = new TextureAtlas(Texture.fromBitmap(spriteBitmap), xml);
			_spriteSheetDic[name] = spriteSheet;
			_loadedCount++;
			checkLoadComplete(name);
		}
		
		private function onFaildSpriteLoad(message:String):void
		{
			dispatchEvent(new LoadingEvent(LoadingEvent.FAILED, message));
		}
		
		private function checkLoadComplete(fileName:String):void
		{
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, _loadedCount));
			trace("_spriteName.length + _soundName.length + _imageName.length = " + (_spriteName.length + _soundName.length + _imageName.length));
			trace("_loadedCount = " + _loadedCount);
			if(_loadedCount >= (_spriteName.length + _soundName.length + _imageName.length))
			{
				_spriteName.splice(0, _spriteName.length);
				_soundName.splice(0, _soundName.length);
				_imageName.splice(0, _imageName.length);
				
				dispatchEvent(new LoadingEvent(LoadingEvent.COMPLETE));
			}
		}
		
		public function addImageName(imageFileName:String):void
		{
			_imageName.push(imageFileName);
		}
		
		public function addSpriteName(spriteFileName:String):void
		{
			_spriteName.push(spriteFileName);
		}
		
		public function addSoundName(soundFileName:String):void
		{
			_soundName.push(soundFileName);
		}
		
		public function getImageFile(imageFileName:String):Texture
		{
			return (_imageDic[imageFileName] as Texture);
		}
		
		public function getSoundFile(soundFileName:String):Sound
		{
			return (_soundDic[soundFileName] as Sound);
		}
		
		public function getSubTexture(spriteFileName:String, subTextureName:String):Texture
		{
			return (TextureAtlas(_spriteSheetDic[spriteFileName]).getTexture(subTextureName));
		}
		
		public function getSpriteSheet(spriteFileName:String):TextureAtlas
		{
			return (_spriteSheetDic[spriteFileName] as TextureAtlas);
		}
	}
}