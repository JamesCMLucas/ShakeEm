package ShakeEmLib
{
	import Box2D.Dynamics.b2Body;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author James
	 */ /*! cEntity
	 * has a physical component (ie. a box2d body - b2Body)
	 *
	 */
	public class cEntity extends Sprite
	{
		public var mBody:b2Body;
		private var mbAlive:Boolean = true;
		
		public function cEntity()
		{
			super();
			
			//addEventListener(Event.ADDED, OnAddedToParent);
			//addEventListener(Event.REMOVED, OnRemovedFromParent);
			//addEventListener(EnterFrameEvent.ENTER_FRAME, OnFrameUpdate);
		}
		
		public function IsAlive():Boolean
		{
			return mbAlive;
		}
		
		public function Die():void
		{
			mbAlive = false;
		}
		
		
		private function OnFrameUpdate(e:EnterFrameEvent):void
		{
		
		}
	}

}