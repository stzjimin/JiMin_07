package puzzle.ingame
{
	import flash.display.Bitmap;
	
	import puzzle.loading.Resources;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class ResultContent extends DisplayObjectContainer
	{
		[Embed(source="resultHead.png")]
		private const headImage:Class;
		
		private var _resources:Resources;
		
		private var _head:Image;
		private var _headText:TextField;
		private var _value:TextField;
		
		public function ResultContent(resources:Resources)
		{
			_resources = resources;
			super();
		}
		
		public function init(width:Number, height:Number, textFormat:TextFormat = null, head:String="", value:String=""):void
		{
			_head = new Image(Texture.fromBitmap(new headImage() as Bitmap));
			_head.width = width * 0.3;
			_head.height = height;
			_head.alignPivot(Align.LEFT);
			_head.y = height / 2;
			addChild(_head);
			
			_headText = new TextField(width * 0.3, height, head, textFormat);
			_headText.alignPivot(Align.LEFT);
			_headText.y = height / 2;
			addChild(_headText);
			
			_value = new TextField(width * 0.7, height, value, textFormat);
			_value.alignPivot(Align.LEFT);
			_value.x = _head.width;
			_value.y = height / 2;
			addChild(_value);
		}
		
		public function destroy():void
		{
			_head.removeFromParent();
			_head.dispose();
			_head = null;
			
			_headText.removeFromParent();
			_headText.dispose();
			_headText = null;
			
			_value.removeFromParent();
			_value.dispose();
			_value = null;
			
			_resources = null;
			
			dispose();
		}
		
		public function setHead(value:String):void
		{
			_headText.text = value;
		}
		
		public function setValue(value:String):void
		{
			_value.text = value;
		}
	}
}