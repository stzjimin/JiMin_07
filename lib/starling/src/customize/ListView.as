package customize
{
	import puzzle.ingame.ThrowProps;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ListView extends DisplayObjectContainer
	{
		public static const TYPE_SHIFT:String = "listViewShift";
		public static const TYPE_DOWN:String = "listViewDown";
		
		private var _isFill:Boolean;
		private var _contentHeight:Number;
		private var _contentWidth:Number;
		private var _type:String;
		private var _padding:Number;
		
		private var _backGround:Image;
		private var _contents:Vector.<ListViewContent>;
		
		private var _contentContainer:Sprite;
		private var _throwProps:ThrowProps;
		
		public function ListView()
		{
			super();
		}
		
		public function init(backGround:Image, width:Number, height:Number, padding:Number):void
		{
			_throwProps = new ThrowProps(width, height, padding);
			_throwProps.type = ThrowProps.TYPE_DOWN;
			_contentContainer = new Sprite();
			_contents = new Vector.<ListViewContent>();
			_isFill = true;
			_contentHeight = 0;
			_contentWidth = 0;
			_type = ListView.TYPE_DOWN;
			_padding = padding;
			
			if(backGround == null)
				return;
			_backGround = backGround;
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			addChild(_throwProps);
//			addChild(_contentContainer);
		}
		
		public function destroy():void
		{
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			if(_contents)
			{
				for(var i:int = 0; i < _contents.length; i++)
					_contents[i].destroy();
				_contents.splice(0, _contents.length);
			}
			
			dispose();
		}
		
		public function addContent(content:ListViewContent):void
		{
			if(content == null)
				return;
			if(_contents == null)
				_contents = new Vector.<ListViewContent>();
			
			addContentAt(content, _contents.length);
		}
		
		public function addContentAt(content:ListViewContent, index:int):void
		{
			if(_contents.length < index)
				return;
			_contents.insertAt(index, content);
			content.addEventListener(ListViewContent.CLICKED, onClickedContent);
			_contentContainer.addChild(content);
			setListView();
		}
		
		public function deleteContent(content:ListViewContent):void
		{
			if(content == null || _contents == null)
				return;
			if(_contents.indexOf(content) < 0)
				return;
			
			deleteContentAt(_contents.indexOf(content));
		}
		
		public function deleteContentAt(index:int):void
		{
			if(index < 0 || _contents.length <= index)
				return;
			
			_contents.removeAt(index).removeFromParent();		
			setListView();
		}
		
		private function setListView():void
		{
			var contentHeight:Number;
			contentHeight = _backGround.height / _contents.length;
			if(!isFill && _contentHeight != 0)
				contentHeight = _contentHeight;
			
			var contentWidth:Number;
			contentWidth = _backGround.width / _contents.length;
			if(!isFill && _contentWidth != 0)
				contentWidth = _contentWidth;
			
			for(var i:int = 0; i < _contents.length; i++)
			{
				if(_type == ListView.TYPE_SHIFT)
				{
					_contents[i].height = _backGround.height - (_padding*2);
					_contents[i].y = _padding;
					_contents[i].width = contentWidth;
					_contents[i].x = i*contentWidth;
				}
				else
				{
					_contents[i].width = _backGround.width - (_padding*2);
					_contents[i].x = _padding;
					_contents[i].height = contentHeight;
					_contents[i].y = i*contentHeight;
				}
			}
			_throwProps.setObject(_contentContainer);
		}
		
		private function onClickedContent(event:Event):void
		{
			var content:ListViewContent = event.currentTarget as ListViewContent;
			
			trace(content.name);
		}

		public function get isFill():Boolean
		{
			return _isFill;
		}

		public function set isFill(value:Boolean):void
		{
			_isFill = value;
		}

		public function get contentHeight():Number
		{
			return _contentHeight;
		}

		public function set contentHeight(value:Number):void
		{
			_contentHeight = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
			if(_type == ListView.TYPE_SHIFT)
			{
				_throwProps.type = ThrowProps.TYPE_SHIFT;
			}
			else
			{
				_throwProps.type = ThrowProps.TYPE_DOWN;
			}
		}

		public function get contentWidth():Number
		{
			return _contentWidth;
		}

		public function set contentWidth(value:Number):void
		{
			_contentWidth = value;
		}
	}
}