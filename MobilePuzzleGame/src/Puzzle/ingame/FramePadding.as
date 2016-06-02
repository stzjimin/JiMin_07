package Puzzle.ingame
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;

	public class FramePadding extends DisplayObjectContainer
	{	
		private var _topPadding:Image;
		private var _bottomPadding:Image;
		private var _leftPadding:Image;
		private var _rightPadding:Image;
		
		public function FramePadding(paddingSize:Number, contentWidth:Number, contentHeight:Number,
									 topPaddingTexture:Texture, bottomPaddingTexture:Texture,
									 leftPaddingTexture:Texture, rightPaddingTexture:Texture)
		{
			_topPadding = new Image(topPaddingTexture);
			_topPadding.width = (paddingSize*2) + contentWidth;
			_topPadding.height = paddingSize;
			addChild(_topPadding);
			
			_bottomPadding = new Image(bottomPaddingTexture);
			_bottomPadding.y = contentHeight + paddingSize;
			_bottomPadding.width = (paddingSize*2) + contentWidth;
			_bottomPadding.height = paddingSize;
			addChild(_bottomPadding);
			
			_leftPadding = new Image(leftPaddingTexture);
			_leftPadding.width = paddingSize;
			_leftPadding.height = (paddingSize*2) + contentHeight;
			addChild(_leftPadding);
			
			_rightPadding = new Image(rightPaddingTexture);
			_rightPadding.x = contentWidth + paddingSize;
			_rightPadding.width = paddingSize;
			_rightPadding.height = (paddingSize*2) + contentHeight;
			addChild(_rightPadding);
		}
		
		public function destroy():void
		{
			dispose();
			removeChildren(0, numChildren);
		}
	}
}