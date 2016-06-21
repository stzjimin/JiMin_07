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
		
		/**
		 * 콤보를 했을 때 나타나는 타이머 입니다.
		 * @param resources
		 * 
		 */		
		public function ComboTimer(resources:Resources)
		{
			_resources = resources;
			_comboJuggler = new Juggler();
			
			super();
		}
		
		/**
		 * 콤보타이머의 길이와 높이를 인자로 받아오며 콤보 유지시간을 결정합니다. 
		 * @param width
		 * @param height
		 * @param comboTime
		 * 
		 */		
		public function init(width:Number, height:Number, comboTime:Number):void
		{	
			_comboTime = comboTime;
			
//			this.x = x;
//			this.y = y;
			
			_comboBar = new Image(_resources.getSubTexture("IngameSpriteSheet.png", "fillBar"));
			_comboBar.width = width;
			_comboBar.height = height;
			_comboBar.alignPivot(Align.RIGHT, Align.TOP);
			_comboBarOriginScaleX = _comboBar.scaleX;
			addChild(_comboBar);
			_comboBar.visible = false;
		}
		
		/**
		 *콤보타이머를 제거하며 할당된 메모리를 해제하는 함수입니다. 
		 * 
		 */		
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
		
		/**
		 * 콤보여부를 체크하는 함수입니다. 
		 * @return 
		 * 
		 */		
		public function checkCombo():Boolean
		{
			return startNewComboTime();
		}
		
		/**
		 * 콤보여부를 체크하는 함수입니다.
		 * _comboTween변수가 null이 아니라면 현제 진행되고있는 콤보타이머가 있다는 것 이므로 콤보시간이 갱신되며 콤보가 이어집니다. 
		 * @return 
		 * 
		 */		
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
		
		/**
		 * 콤보 타이머가 종료된경우(콤보를 이어가지못한 경우)호출되는 함수입니다. 
		 * @param event
		 * 
		 */		
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