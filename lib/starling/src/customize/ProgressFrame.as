package customize
{
	import flash.errors.IllegalOperationError;
	
	import starling.display.DisplayObjectContainer;
	import starling.textures.Texture;

	public class ProgressFrame extends PopupFrame
	{
		private var _progress:Progress;
		
		public function ProgressFrame(coverWidth:Number, coverHeight:Number, coverFaceTexture:Texture = null)
		{
			super(coverWidth, coverHeight, coverFaceTexture);
		}
		
		public override function destroy():void
		{
			super.destroy();
		}
		
		public override function setContent(progress:DisplayObjectContainer, width:Number=0, height:Number=0):void
		{
			if(!progress is Progress)
				throw new IllegalOperationError("progress에는 Progress형의 변수를 넣어주세요!!");
			
			_progress = progress as Progress;
			
			super.setContent(progress, width, height);
		}
		
		public function startProgress():void
		{
			show();
			_progress.start();
		}
		
		public function stopProgress():void
		{
			hide();
			_progress.stop();
		}
	}
}