package ShakeEmLib 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author James
	 */
	public class cBoundary extends Sprite
	{
		/*! The image
		 */
		public var image:Image;
		
		public function cBoundary(im:Image)
		{
			super();
			image = im;
			this.addChild(image);
			//addEventListener(Event.ADDED, onAddedToParent);
			//addEventListener(Event.REMOVED, onRemovedFromParent);
			
		}
		
		private function onAddedToParent(e:Event):void
		{
			this.addChild(image);
		}
		
		private function onRemovedFromParent(e:Event):void
		{
			this.removeChild(image);
		}
	}

}