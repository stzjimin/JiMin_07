package puzzle.attend
{
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;

	public class Day extends DisplayObjectContainer
	{	
		private var _quad:Quad
		private var _backGround:Image;
		private var _mark:Image;
		
		private var _items:Vector.<Image>;
		
		private var _present:Vector.<String>;
		
		public function Day(width:Number, height:Number)
		{
			_present = new Vector.<String>();
			_items = new Vector.<Image>();
			
			_quad = new Quad(width, height);
			addChild(_quad);
		}
		
		public function destroy():void
		{
			_quad.removeFromParent();
			_quad.dispose();
			_quad = null;
			
			if(_backGround)
			{
				_backGround.removeFromParent();
				_backGround.dispose();
				_backGround = null;
			}
			
			if(_mark)
			{
				_mark.removeFromParent();
				_mark.dispose();
				_mark = null;
			}
			
			for(var i:int = 0; i < _items.length; i++)
			{
				_items[i].removeFromParent();
				_items[i].dispose();
			}
			_items.splice(0, _items.length);
			_items = null;
			
			_present.splice(0, _present.length);
			_present = null;
		}
		
		public function addBackGround(texture:Texture):void
		{
			_backGround = new Image(texture);
			_backGround.width = _quad.width;
			_backGround.height = _quad.height;
			addChild(_backGround);
		}
		
		public function addMark(texture:Texture, alpha:Number = 1.0, scale:Number = 1.0):void
		{
			_mark = new Image(texture);
			_mark.width = _quad.width;
			_mark.height = _quad.height;
			_mark.alignPivot();
			_mark.x = _quad.width / 2;
			_mark.y = _quad.height / 2;
			_mark.alpha = alpha;
			_mark.scale *= scale;
			addChild(_mark);
		}
		
		public function showMarking(texture:Texture):void
		{
			addMark(texture, 0.5, 3.0);
			
			var tween:Tween = new Tween(_mark, 2.0);
			tween.fadeTo(1.0);
			trace("_mark.scale = " + _mark.scale);
			tween.scaleTo(_mark.scale / 3.0);
//			tween.addEventListener(Event.REMOVE_FROM_JUGGLER, onCompleteTween);
			Starling.juggler.add(tween);
		}
		
		public function addItemImage(texture:Texture):void
		{
			var itemImage:Image = new Image(texture);
			itemImage.width = _quad.width * 0.9;
			itemImage.height = _quad.height * 0.9;
			itemImage.alignPivot();
			itemImage.x = _quad.width / 2;
			itemImage.y = _quad.height / 2;
			addChild(itemImage)
		}
		
		public function addPresent(value:String):void
		{
			_present.push(value);
		}
		
		public function getPresentLength():int
		{
			if(!_present)
				return  0;
			
			return _present.length;
		}
		
		public function getPresent(index:int):String
		{
			if(!_present)
				return null;
			
			if(index < 0 || _present.length <= index)
				return null;
			
			return _present[index];
		}
	}
}