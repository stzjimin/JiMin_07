package puzzle.ingame.timer
{
	import flash.display.Bitmap;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class ComboTimer extends Sprite implements IAnimatable
	{
		[Embed(source="fillBar.png")]
		private const fillBarImage:Class;
		
		public static const COMBOED:String = "comboed";
		
		private var _comboTime:Number;
		private var _comboJuggler:Juggler;
		
		private var _comboBar:Image;
		private var _comboBarOriginScaleX:Number;
		private var _comboTween:Tween;
		
		private var _comboCount:uint;
		
		public function ComboTimer()
		{
			_comboJuggler = new Juggler();
		}
		
		public function init(x:Number, y:Number, width:Number, height:Number, comboTime:Number):void
		{	
			_comboTime = comboTime;
			
			this.x = x;
			this.y = y;
			
			_comboBar = new Image(Texture.fromBitmap(new fillBarImage() as Bitmap));
			_comboBar.width = width;
			_comboBar.height = height;
			_comboBar.alignPivot(Align.RIGHT, Align.TOP);
			_comboBarOriginScaleX = _comboBar.scaleX;
			addChild(_comboBar);
			_comboBar.visible = false;
		}
		
		public function destroy():void
		{
			_comboJuggler.purge();
			
			if(_comboTween != null)
			{
				_comboTween.removeEventListener(Event.REMOVE_FROM_JUGGLER, onCompleteTween);
				_comboTween = null;
			}
			
			_comboBar.removeFromParent();
			_comboBar.dispose();
			
			dispose();
		}
		
		public function startNewComboTime():void
		{
			if(_comboTween == null)
			{
				trace("콤보시작");
				_comboCount = 0;
				_comboTween = new Tween(_comboBar, _comboTime);
				_comboTween.scaleXTo(0);
				_comboTween.addEventListener(Event.REMOVE_FROM_JUGGLER, onCompleteTween);
				_comboJuggler.add(_comboTween);
			}
			else
			{
				_comboCount++;
				_comboBar.scaleX = _comboBarOriginScaleX;
				_comboTween.reset(_comboBar, _comboTime);
				_comboTween.scaleXTo(0);
				
				dispatchEvent(new Event(ComboTimer.COMBOED, false, _comboCount));
			}
			_comboBar.visible = true;
		}
		
		public function advanceTime(time:Number):void
		{
			_comboJuggler.advanceTime(time);
		}
		
		private function onCompleteTween(event:Event):void
		{
			trace("콤보끝");
			_comboTween.removeEventListener(Event.REMOVE_FROM_JUGGLER, onCompleteTween);
			_comboTween = null;
			_comboBar.visible = false;
		}
	}
}