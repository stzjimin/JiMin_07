package customize
{
	import starling.events.Event;

	public class SceneEvent extends Event
	{
		public static const START:String = "sceneStart";
		public static const END:String = "sceneEnd";
		public static const CREATE:String = "sceneCreate";
		public static const DESTROY:String = "sceneDestroy";
		
		public static const ACTIVATE:String = "gameActivate";
		public static const DEACTIVATE:String = "gameDeActivate";
		
		public function SceneEvent(type:String)
		{
			super(type);
		}
	}
}