package puzzle.shop
{
	import flash.display.Bitmap;
	
	import puzzle.item.ItemType;
	import puzzle.loading.Resources;
	import puzzle.user.User;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class Shop extends DisplayObjectContainer
	{
		public static const CLICKED_BUY:String = "buyClicked";
		public static const CLICKED_CLOSE:String = "closeClicked";
		
		private var _backGround:Image;
		private var _title:Image;
		private var _titleMessage:TextField;
		
		private var _item:Image;
		private var _buyButton:Button;
		private var _closeButton:Button;
		
		private var _itemType:String;
		
		private var _resources:Resources;
		
		public function Shop(resources:Resources)
		{
			_resources = resources;
			
			super();
		}
		
		public function init(width:Number, height:Number):void
		{
			_backGround = new Image(_resources.getSubTexture("ShopSpriteSheet.png", "PopupBackGround"));
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
			
			_title = new Image(_resources.getSubTexture("ShopSpriteSheet.png", "popupTitle"));
			_title.width = width * 0.9;
			_title.height = height * 0.1;
			_title.alignPivot(Align.CENTER, Align.TOP);
			_title.x = width / 2;
			_title.y = height * 0.05;
			addChild(_title);
			
			_titleMessage = new TextField(width * 0.9, height * 0.1, "구입");
			_titleMessage.format.bold = true;
			_titleMessage.format.size = 20;
			_titleMessage.alignPivot(Align.CENTER, Align.TOP);
			_titleMessage.x = width / 2;
			_titleMessage.y = height * 0.05;
			addChild(_titleMessage);
			
			_item = new Image(_resources.getSubTexture("ShopSpriteSheet.png", "PopupBackGround"));
			_item.width = width * 0.6;
			_item.height = height * 0.5;
			_item.alignPivot(Align.CENTER, Align.TOP);
			_item.x = width / 2;
			_item.y = _title.y + _title.height + (height * 0.05);
			addChild(_item);
			
			_buyButton = new Button(_resources.getSubTexture("ShopSpriteSheet.png", "popupTitle"), "구매");
			_buyButton.width = width * 0.4;
			_buyButton.height = height * 0.2;
			_buyButton.alignPivot(Align.LEFT, Align.TOP);
			_buyButton.x = width * 0.05;
			_buyButton.y = _item.y + _item.height + (height * 0.05);
			_buyButton.addEventListener(Event.TRIGGERED, onClickedBuyButton);
			addChild(_buyButton);
			
			_closeButton = new Button(_resources.getSubTexture("ShopSpriteSheet.png", "popupTitle"), "닫기");
			_closeButton.width = width * 0.4;
			_closeButton.height = height * 0.2;
			_closeButton.alignPivot(Align.LEFT, Align.TOP);
			_closeButton.x = _buyButton.x + _buyButton.width + (width * 0.1);
			_closeButton.y = _buyButton.y;
			_closeButton.addEventListener(Event.TRIGGERED, onClickedCloseButton);
			addChild(_closeButton);
		}
		
		public function destroy():void
		{
			_backGround.removeFromParent();
			_backGround.dispose();
			_backGround = null;
			
			_title.removeFromParent();
			_title.dispose();
			_title = null;
			
			_titleMessage.removeFromParent();
			_titleMessage.dispose();
			_titleMessage = null;
			
			_item.removeFromParent();
			_item.dispose();
			_item = null;
			
			_buyButton.removeEventListener(Event.TRIGGERED, onClickedBuyButton);
			_buyButton.removeFromParent();
			_buyButton.dispose();
			_buyButton = null;
			
			_closeButton.removeEventListener(Event.TRIGGERED, onClickedCloseButton);
			_closeButton.removeFromParent();
			_closeButton.dispose();
			_closeButton = null;
			
			dispose();
		}
		
		public function setItem(itemType:String):void
		{
			_itemType = itemType;
			
			switch(_itemType)
			{
				case ItemType.FORK :
					_item.texture = _resources.getSubTexture("UserInfoSpriteSheet.png", "fork");
					break;
				case ItemType.SEARCH :
					_item.texture = _resources.getSubTexture("UserInfoSpriteSheet.png", "search");
					break;
				case ItemType.SHUFFLE :
					_item.texture = _resources.getSubTexture("UserInfoSpriteSheet.png", "shuffle");
					break;
				case ItemType.HEART :
					_item.texture = _resources.getSubTexture("UserInfoSpriteSheet.png", "heartImage");
					break;
			}
		}
		
		private function onClickedBuyButton(event:Event):void
		{
			switch(_itemType)
			{
				case ItemType.FORK :
					User.getInstance().fork += 1;
					break;
				case ItemType.SEARCH :
					User.getInstance().search += 1;
					break;
				case ItemType.SHUFFLE :
					User.getInstance().shuffle += 1;
					break;
				case ItemType.HEART :
					User.getInstance().heart += 1;
					break;
			}
			
			dispatchEvent(new Event(Shop.CLICKED_BUY, false, _itemType));
		}
		
		private function onClickedCloseButton(event:Event):void
		{
			dispatchEvent(new Event(Shop.CLICKED_CLOSE, false));
		}
	}
}