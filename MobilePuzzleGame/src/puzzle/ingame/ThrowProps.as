package puzzle.ingame
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.animation.Juggler;
	import starling.display.Canvas;
	import starling.display.DisplayObjectContainer;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ThrowProps extends DisplayObjectContainer
	{
		public static const TYPE_SHIFT:String = "throwShift";
		public static const TYPE_DOWN:String = "throwDown";
		
		private var _type:String;
		
		private var _mask:Canvas;
		
		private var _bound:Rectangle;
		private var _object:DisplayObjectContainer;
		
		private var _beganLocation:Point;
		private var _prevLocation:Point;
		private var _currentLocation:Point;
		private var _slashFlag:Boolean;
		
		private var _juggler:Juggler;
		
		public function ThrowProps(boundWidth:Number, boundHeight:Number, padding:Number)
		{
			super();
			_bound = new Rectangle();
			setBound(boundWidth, boundHeight);
			_mask = new Canvas();
			_juggler = new Juggler();
			_slashFlag = false;
			_type = ThrowProps.TYPE_DOWN;
			
			_mask.drawRectangle(padding, padding, _bound.width-(padding*2), _bound.height-(padding*2));
			addChild(_mask);
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		public function destroy():void
		{
			if(_object)
			{
				_object.removeEventListener(TouchEvent.TOUCH, onTouchObejct);
				_object.removeFromParent();
				_object.dispose();
				_object = null;
			}
			
			_mask.dispose();
			_mask = null;
			
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			
			dispose();
		}
		
		public function setBound(boundWidth:Number, boundHeight:Number):void
		{
			_bound.width = boundWidth;
			_bound.height = boundHeight
		}
		
		public function setObject(object:DisplayObjectContainer):void
		{
			if(_object != null)
			{
				_object.removeEventListener(TouchEvent.TOUCH, onTouchObejct);
				_object.removeFromParent();
			}
			
			_object = object;
			
			_object.addEventListener(TouchEvent.TOUCH, onTouchObejct);
			
			_object.mask = _mask;
			addChild(_object);
		}
		
		private function onEnterFrame(event:EnterFrameEvent):void
		{
			_juggler.advanceTime(event.passedTime);
		}
		
		private function onTouchObejct(event:TouchEvent):void
		{
			var distanceX:Number;
			var distanceY:Number;
			var objectBound:Rectangle;
			var targetPoint:Point;
			var vers:Number;
			
			var touch:Touch = event.getTouch(_object);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.BEGAN)
			{
				_prevLocation = globalToLocal(touch.getLocation(stage));
				_beganLocation = globalToLocal(touch.getLocation(stage));
				trace("_prevLocation = " + _prevLocation)
				trace("_prevLocation.global = " +  globalToLocal(_prevLocation));
				_juggler.delayCall(onFaildSlash, 0.3);
				_slashFlag = true;
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
//				TweenMax.killAll();
				_currentLocation = globalToLocal(touch.getLocation(stage));
				
				distanceX = _currentLocation.x - _prevLocation.x;
				distanceY = _currentLocation.y - _prevLocation.y;
				
				objectBound = _object.getBounds(_object.parent);
				
				if(_type == ThrowProps.TYPE_SHIFT)
					targetPoint = new Point(_object.x + distanceX, _object.y);
				else if(_type == ThrowProps.TYPE_DOWN)
					targetPoint = new Point(_object.x, _object.y + distanceY);
				_object.x = targetPoint.x;
				_object.y = targetPoint.y;
//				TweenMax.to(_object, 0.3, {x:targetPoint.x, y:targetPoint.y});
				
				_prevLocation = _currentLocation.clone();
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				TweenMax.killAll();
				_currentLocation = globalToLocal(touch.getLocation(stage));
				
				trace("_currentLocation = " + _currentLocation)
				trace("_currentLocation.global = " +  globalToLocal(_currentLocation));
				
				if(_slashFlag)
				{
					distanceX = _currentLocation.x - _beganLocation.x;
					distanceY = _currentLocation.y - _beganLocation.y;
				}
				else
				{
					distanceX = _currentLocation.x - _prevLocation.x;
					distanceY = _currentLocation.y - _prevLocation.y;
				}
				
				objectBound = _object.getBounds(_object.parent);
				
				if(_type == ThrowProps.TYPE_SHIFT)
				{
					if(objectBound.left + distanceX > _bound.left)
					{
						targetPoint = new Point(_bound.left, _object.y);
						TweenMax.to(_object, 0.5, {x:targetPoint.x, y:targetPoint.y, ease:Back.easeOut});
					}
					else if(objectBound.right + distanceX < _bound.right)
					{
						vers = _bound.right - objectBound.right;
						
						targetPoint = new Point(_object.x + vers, _object.y);
						TweenMax.to(_object, 0.5, {x:targetPoint.x, y:targetPoint.y, ease:Back.easeOut});
					}
					else
					{
						targetPoint = new Point(_object.x + distanceX, _object.y);
						TweenMax.to(_object, 0.5, {x:targetPoint.x, y:targetPoint.y});
					}
				}
				else if(_type == ThrowProps.TYPE_DOWN)
				{
					if(objectBound.top + distanceY > _bound.top)
					{
						targetPoint = new Point(_object.x,_bound.top);
						TweenMax.to(_object, 0.5, {x:targetPoint.x, y:targetPoint.y, ease:Back.easeOut});
					}
					else if(objectBound.bottom + distanceY < _bound.bottom)
					{
						vers = _bound.bottom - objectBound.bottom;
						
						targetPoint = new Point(_object.x, _object.y + vers);
						TweenMax.to(_object, 0.5, {x:targetPoint.x, y:targetPoint.y, ease:Back.easeOut});
					}
					else
					{
						targetPoint = new Point(_object.x, _object.y + distanceY);
						TweenMax.to(_object, 0.5, {x:targetPoint.x, y:targetPoint.y});
					}
				}
			}
			
			function onFaildSlash():void
			{
				_slashFlag = false;
			}
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

	}
}