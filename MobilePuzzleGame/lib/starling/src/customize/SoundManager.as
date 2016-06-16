package customize
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	public class SoundManager
	{
		private var _sounds:Dictionary;
		private var _bgm:Sound;
		private var _isBgmActive:Boolean;
		private var _isEffectActive:Boolean;
		
		private var _isStopAll:Boolean;
		
		public function SoundManager()
		{
			_sounds = new Dictionary();
		}
		
		public function destroy():void
		{
			if(_sounds)
			{
				for(var key:String in _sounds)
				{
					_sounds[key].destroy();
					_sounds[key] = null;
					delete _sounds[key];
				}
				_sounds = null;
			}
			
			_bgm = null;
		}
		
		public function addSound(name:String, sound:Sound):void
		{
			if(!name || !sound || !_sounds)
				return;
			
			if(_sounds[name] != null)
				return;
			
			_sounds[name] = sound;
		}
		
		public function removeSound(name:String):void
		{
			if(!_sounds || !name || !_sounds[name])
				return;
			
			var sound:Sound = _sounds[name];
			sound.destroy();
			_sounds[name] = null;
			delete _sounds[name];
		}
		
		public function getSound(name:String):Sound
		{
			if(!_sounds)
				return null;
			
			return _sounds[name];
		}
		
		public function play(name:String, loop:int = 0, isActive:Boolean = false):void
		{
			if(name == "White.mp3")
				trace(name);
			trace(_isBgmActive);
			
			if(!_sounds || !_sounds[name])
				return;
			
			var sound:Sound = _sounds[name];
			var channel:SoundChannel;
			var soundTransForm:SoundTransform = new SoundTransform(sound.volum);
			
			if(loop == Sound.INFINITE)
			{
				if(_bgm)
				{
					//bgmStop
					_bgm.channel.stop();
				}
				
				loop = 0;
				sound.isInfinite = true;
				if(!_isBgmActive)
					soundTransForm.volume = 0;
				if(isActive)
					soundTransForm.volume = 1;
				sound.play(0, loop, soundTransForm);
				_bgm = sound;
			}
			else
			{
				if(!_isEffectActive)
					soundTransForm.volume = 0;
				if(isActive)
					soundTransForm.volume = 1;
				sound.play(0, loop, soundTransForm);
			}
			sound.isPlay = true;
			trace(sound.url);
		}
		
		public function stopAll():void
		{
			if(_isStopAll)
				return;
			
//			SoundMixer.stopAll();
			
			var sound:Sound;
			for(var key:String in _sounds)
			{
				sound = _sounds[key];
				if(sound.isPlay)
				{
					trace(sound.channel.position);
					sound.channel.stop();
				}
			}
			_isStopAll = true;
		}
		
		public function wakeAll():void
		{
			if(!_isStopAll)
				return;
			
			var sound:Sound;
			for(var key:String in _sounds)
			{
				sound = _sounds[key];
				if(sound.isPlay)
					sound.wake();
			}
			
			_isStopAll = false;
		}

		public function get isBgmActive():Boolean
		{
			return _isBgmActive;
		}

		public function set isBgmActive(value:Boolean):void
		{
			_isBgmActive = value;
			if(!_bgm || !_bgm.channel)
				return;
			
			var soundTransform:SoundTransform;
			if(!_isBgmActive)
			{
				soundTransform = new SoundTransform(0, _bgm.channel.soundTransform.pan);
				_bgm.channel.soundTransform = soundTransform;
			}
			else
			{
				soundTransform = new SoundTransform(1, _bgm.channel.soundTransform.pan);
				_bgm.channel.soundTransform = soundTransform;
			}
		}

		public function get isEffectActive():Boolean
		{
			return _isEffectActive;
		}

		public function set isEffectActive(value:Boolean):void
		{
			_isEffectActive = value;
			var sound:Sound;
			for(var key:String in _sounds)
			{
				sound = _sounds[key];
				if(sound == _bgm)
					continue;
				if(!sound || !sound.channel)
					continue;
				
				var soundTransform:SoundTransform;
				if(!_isEffectActive)
				{
					soundTransform = new SoundTransform(0, sound.channel.soundTransform.pan);
					sound.channel.soundTransform = soundTransform;
				}
				else
				{
					soundTransform = new SoundTransform(1, sound.channel.soundTransform.pan);
					sound.channel.soundTransform = soundTransform;
				}
			}
		}
	}
}