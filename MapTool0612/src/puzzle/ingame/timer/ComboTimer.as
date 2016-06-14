package puzzle.ingame.timer
{
	import puzzle.loading.Resources;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Align;

	public class ComboTimer extends Sprite implements IAnimatable
	{
		private var _comboTime:Number;
		private var _comboJuggler:Juggler;
		
		private var _comboBar:Image;
		private var _comboBarOriginScaleX:Number;
		private var _comboTween:Tween;
		
		private var _comboCount:uint;
		
		private var _resources:Resources;
		
		public function ComboTimer(resources:Resources)
		{
			_resources = resources;
			_comboJuggler = new Juggler();
			
			super();
		}
		
		public function init(x:Number, y:Number, width:Number, height:Number, comboTime:Number):void
		{	
			_comboTime = comboTime;
			
			this.x = x;
			this.y = y;
			
			_comboBar = new Image(_resources.getSubTexture("IngameSpriteSheet.png", "fillBar"));
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
			
			_resources = null;
			
			dispose();
		}
		
		public function checkCombo():Boolean
		{
			return startNewComboTime();
		}
		
		private function startNewComboTime():Boolean
		{
			var combo:Boolean = false;
			if(_comboTween == null)
			{
//				trace("콤보시작");
				_comboCount = 0;
				_comboTween = new Tween(_comboBar, _comboTime);
				_comboTween.scaleXTo(0);
				_comboTween.addEventListener(Event.REMOVE_FROM_JUGGLER, onCompleteTween);
				_comboJuggler.add(_comboTween);
				combo = false;
			}
			else
			{
				_comboCount++;
				_comboBar.scaleX = _comboBarOriginScaleX;
				_comboTween.reset(_comboBar, _comboTime);
				_comboTween.scaleXTo(0);
				
				combo = true;
//				dispatchEvent(new Event(ComboTimer.COMBOED, false, _comboCount));
			}
			_comboBar.visible = true;
			return combo;
		}
		
		public function advanceTime(time:Number):void
		{
			_comboJuggler.advanceTime(time);
		}
		
		private function onCompleteTween(event:Event):void
		{
//			trace("콤보끝");
			_comboTween.removeEventListener(Event.REMOVE_FROM_JUGGLER, onCompleteTween);
			_comboTween = null;
			_comboCount = 0;
			_comboBar.visible = false;
		}

		public function get comboCount():uint
		{
			return _comboCount;
		}

		public function set comboCount(value:uint):void
		{
			_comboCount = value;
		}

	}
}