package customize
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	public class Sound extends flash.media.Sound
	{
		public static const INFINITE:int = -1;
		public static const NO_LOOP:int = 0;
		
		private var _volum:Number;
		private var _panning:Number;
		private var _isInfinite:Boolean;
		private var _isPlay:Boolean;
		
		private var _channel:SoundChannel;
		
		public function Sound(stream:URLRequest = null, context:SoundLoaderContext = null)
		{
			super(stream, context);
			_isPlay = false;
			_volum = 1;
		}
		
		public function destroy():void
		{
			if(_channel != null)
			{
				if(_isPlay)
					_channel.stop();
				_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				_channel = null;
			}
		}
		
		public override function play(startTime:Number=0, loops:int=0, sndTransform:SoundTransform=null):SoundChannel
		{
			_channel = super.play(startTime, loops, sndTransform);
			_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			return _channel;
		}
		
		public function wake():void
		{
			if(!_channel || !_isPlay)
				return;
			
			trace(_channel.position);
			play(_channel.position, 0, _channel.soundTransform); 
		}
		
		private function onSoundComplete(event:Event):void
		{
			_isPlay = false;
			_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			if(_isInfinite)
			{
				trace("loop");
				this.play(0, 0, _channel.soundTransform);
				_isPlay = true;
			}
		}

		public function get volum():Number
		{
			return _volum;
		}

		public function set volum(value:Number):void
		{
			_volum = value;
		}

//		public function get loops():int
//		{
//			return _loops;
//		}
//
//		public function set loops(value:int):void
//		{
//			_loops = value;
//		}

//		public function get startTime():Number
//		{
//			return _startTime;
//		}
//
//		public function set startTime(value:Number):void
//		{
//			_startTime = value;
//		}

		public function get channel():SoundChannel
		{
			return _channel;
		}

		public function get panning():Number
		{
			return _panning;
		}

		public function set panning(value:Number):void
		{
			_panning = value;
		}

		public function get isPlay():Boolean
		{
			return _isPlay;
		}

		public function set isPlay(value:Boolean):void
		{
			_isPlay = value;
		}

		public function get isInfinite():Boolean
		{
			return _isInfinite;
		}

		public function set isInfinite(value:Boolean):void
		{
			_isInfinite = value;
		}


	}
}