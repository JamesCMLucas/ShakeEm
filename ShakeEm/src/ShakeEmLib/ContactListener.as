package ShakeEmLib 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	/**
	 * ...
	 * @author James
	 */
	public class ContactListener extends b2ContactListener
	{
		
		
		public function ContactListener() 
		{
			
		}
		
		override public function BeginContact(contact:b2Contact):void
		{
			if ( !contact.IsTouching() )
			{
				return;
			}
			
			
			
			if ( ( contact.GetFixtureA().GetBody() != null ) && ( contact.GetFixtureA().GetBody() != null ) )
			{
				var bodyA:b2Body = contact.GetFixtureA().GetBody();
				var bodyB:b2Body = contact.GetFixtureB().GetBody();
				
				if ( ( bodyA == null ) || ( bodyB == null ) )
				{
					return;
				}
				
				
			}
		}
		
		//override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		//{
			/*
			if ( (contact.GetFixtureA() != null) && (contact.GetFixtureB() != null) )
			{
				var bodyA:b2Body = contact.GetFixtureA().GetBody();
				var bodyB:b2Body = contact.GetFixtureB().GetBody();
				
				if ( (bodyA != null) && (bodyB != null) )
				{
					if (bodyA.GetType() == b2Body.b2_kinematicBody)
					{
						bodyA.SetPositionAndAngle(new b2Vec2(0.0, 0.0), 0.0);
					}
				}
			}
			*/
		//}
		
		override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
		{
			/*
			if ( (contact.GetFixtureA() != null) && (contact.GetFixtureB() != null) )
			{
				var bodyA:b2Body = contact.GetFixtureA().GetBody();
				var bodyB:b2Body = contact.GetFixtureB().GetBody();
				
				if ( (bodyA != null) && (bodyB != null) )
				{
					if (bodyA.GetType() == b2Body.b2_kinematicBody)
					{
						bodyA.SetPositionAndAngle(new b2Vec2(0.0, 0.0), 0.0);
					}
				}
			}
			*/
		}
	}

}