package scenes 
{
	import flash.system.Capabilities;
	
	import ShakeEmLib.sensors.SmoothAccelerometer;
	import ShakeEmLib.sensors.SmoothGyroscope;
	import ShakeEmLib.cBoundary;
	import ShakeEmLib.Shape;
	import ShakeEmLib.ContactListener;
	
	import starling.core.Starling;
	import starling.display.Image;
    import starling.textures.Texture;
	import starling.events.EnterFrameEvent;
	import starling.display.Sprite;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;
	import Box2D.Common.b2Settings;
	
	/**
	 * ...
	 * @author James
	 */
	public class Box2DWithRotationTest extends Scene
	{
		public var accV3Cache:b2Vec3;
		public var acc:SmoothAccelerometer;
		public var gyro:SmoothGyroscope;
		
		public var world:b2World;
		public var boundaryBody:b2Body;
		public var velocityIterations:int = 5;
		public var positionIterations:int = 5;
		public var timeStep:Number = 1.0 / 30.0;
		
		public var pixelsPerMeter:Number = 50;
		public var metersPerPixel:Number = 1 / pixelsPerMeter;
		public var myContactListener:ContactListener;
		
		public var myShape1:Shape;
		public var myShape2:Shape;
		public var bordersImage:Image;
		public var currentAngle:Number = 0.0;
		public var gravity:b2Vec2;
		//public var arena:Sprite;
		//public var boundary:cBoundary;
		
		public function Box2DWithRotationTest() 
		{
			gravity = new b2Vec2();
			accV3Cache = new b2Vec3();
			
			// create the smooth gyroscope
			gyro = new SmoothGyroscope(3);
			// create the smooth accelerometer
			acc = new SmoothAccelerometer(3);
			// per-frame update
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateFrame);
			
			// world sizing
			var worldHalfWidth:Number = Constants.GameWidth * metersPerPixel / 2;
			var worldHalfHeight:Number = Constants.GameHeight * metersPerPixel / 2;
			
			
			// set some gravity - (we apply it manually per frame step)
			var zeroGravity:b2Vec2 = new b2Vec2(0.0, 0.0);
			// allow bodies to sleep
			var bAllowBodiesToSleep:Boolean = true;
			
			// make the world
			world = new b2World(zeroGravity, bAllowBodiesToSleep);
			// set the contact listener
			myContactListener = new ContactListener();
			world.SetContactListener( myContactListener );
			
			
			bordersImage = new Image(Assets.getTexture("RedBorders"));
			bordersImage.pivotX = bordersImage.width / 2;
			bordersImage.pivotY = bordersImage.height / 2;
			bordersImage.width = Constants.GameWidth;
			bordersImage.height = Constants.GameHeight;
			bordersImage.x = Constants.CenterX;
			bordersImage.y = Constants.CenterY;
			//boundary = new cBoundary(bordersImage);
			//arena.addChild(boundary);
			this.addChild(bordersImage);
			
			
			// scales for the two bouncing asteroids
			var circleWorldRadius:Number = 0.4;
			var circle2WorldRadius:Number = 0.3;
			var circlePixelSize:Number = circleWorldRadius * 2 * pixelsPerMeter;
			var circle2PixelSize:Number = circle2WorldRadius * 2 * pixelsPerMeter;
			
			// images of the asteroids
			myShape1 = new Shape("Asteroid", "Blue", circlePixelSize, circlePixelSize, false);
			addChild(myShape1);
			myShape2 = new Shape("Asteroid", "Blue", circle2PixelSize, circle2PixelSize, false);
			addChild(myShape2);
			
			
			
			// make the first circle body
			var circleShape:b2CircleShape = new b2CircleShape(circleWorldRadius);
			var circleBodyDef:b2BodyDef = new b2BodyDef();
			var circleFixtureDef:b2FixtureDef = new b2FixtureDef();
			circleBodyDef.type = b2Body.b2_dynamicBody;
			circleBodyDef.position.Set(0, 0);
			circleFixtureDef.shape = circleShape;
			circleFixtureDef.friction = 0.02;
			circleFixtureDef.density = 10.0;
			circleFixtureDef.restitution = 0.3;
			circleBodyDef.userData = myShape1;
			myShape1.mBody = world.CreateBody(circleBodyDef);
			myShape1.mBody.CreateFixture(circleFixtureDef);
			
			// make the second circle body
			circleShape = new b2CircleShape(circle2WorldRadius);
			circleBodyDef = new b2BodyDef();
			circleFixtureDef = new b2FixtureDef();
			circleBodyDef.type = b2Body.b2_dynamicBody;
			circleBodyDef.position.Set(worldHalfWidth*0.5, worldHalfHeight*0.5);
			circleFixtureDef.shape = circleShape;
			circleBodyDef.userData = myShape2;
			myShape2.mBody = world.CreateBody(circleBodyDef);
			myShape2.mBody.CreateFixture(circleFixtureDef);
			
			// make the bordering walls
			
			
			
			
			// the body
			// depth of the wall boundaries
			var wallDepthInPixels:Number = 25;  // to match the image
			var wallDepthInMetres:Number = wallDepthInPixels * metersPerPixel;
			// inner width and height (heights & widths for boxes)
			var innerWidth:Number = Constants.GameWidth - ( 2 * wallDepthInMetres );
			var innerHeight:Number = Constants.GameHeight - ( 2 * wallDepthInMetres );
			
			
			var wall:b2PolygonShape = new b2PolygonShape();
			var wallFixtureDef:b2FixtureDef = new b2FixtureDef();
			wallFixtureDef.density = 100.0;  // only necessary if dynamic...dunno yet if this should be the case
			wallFixtureDef.shape = wall;  // set the shape
			wallFixtureDef.restitution = 0.3; // add some bounce
			var wallBodyDef:b2BodyDef = new b2BodyDef();
			wallBodyDef.type = b2Body.b2_kinematicBody;  // defaults to b2_staticBody
			wallBodyDef.position.Set( 0, 0 );
			boundaryBody = world.CreateBody(wallBodyDef);
			
			
			// for centre positions of the boxes (world scale)
			var cx:Number;
			var cy:Number;
			// for half-widths and half-heights of the boxes (world scale)
			var hW:Number;
			var hH:Number;
			
			
			// left
			hW = wallDepthInMetres / 2;
			hH = innerHeight / 2;
			cx = -worldHalfWidth + hW;
			cy = 0.0;
			wall.SetAsOrientedBox(hW, hH, new b2Vec2(cx, cy), 0.0 );
			boundaryBody.CreateFixture(wallFixtureDef);
			
			// right
			cx = worldHalfWidth - hW;
			wall.SetAsOrientedBox(hW, hH, new b2Vec2(cx, cy), 0.0 );
			boundaryBody.CreateFixture(wallFixtureDef);
			
			// top
			hW = innerWidth / 2;
			hH = wallDepthInMetres / 2;
			cx = 0.0;
			cy = worldHalfHeight - hH;
			wall.SetAsOrientedBox(hW, hH, new b2Vec2(cx, cy), 0.0 );
			boundaryBody.CreateFixture(wallFixtureDef);
			
			// bottom
			cy = -worldHalfHeight + hH;
			wall.SetAsOrientedBox(hW, hH, new b2Vec2(cx, cy), 0.0 );
			boundaryBody.CreateFixture(wallFixtureDef);
		}
		
		public function updateFrame(e:EnterFrameEvent):void
		{
			var dt:Number = e.passedTime;
			
			acc.updatePerFrame();
			gyro.updatePerFrame();
			
			//calculate the angle from the accelerometer
			var aX:Number = acc.smoothX;
			var aY:Number = acc.smoothY;
			var aZ:Number = acc.smoothZ;
			var rotZ:Number = Math.atan2(aX, aY);
			
			// apply rotation
			//var gX:Number = gyro.smoothX;
			//var gY:Number = gyro.smoothY;
			var gZ:Number = gyro.smoothZ;
			
			var filterCoeff:Number = 0.75;
			//currentAngle = ( filterCoeff * (currentAngle + gZ * dt)) + ((1.0 - filterCoeff) * accRot);
			var newAngle:Number = ( filterCoeff * (currentAngle + gZ * dt)) + ((1.0 - filterCoeff) * rotZ);
			
			var gravityConstant:Number = 9.81;
			var gravityDirection:b2Vec2 = new b2Vec2(0.0, 1.0);
			var rotMat:b2Mat22 = new b2Mat22();
			rotMat.Set(newAngle);
			currentAngle = newAngle;
			
			//var stepsForward:Number = 1.0;
			//newAngle += gZ * stepsForward * dt;
			//rotMat.Set(newAngle);
			gravityDirection.MulM(rotMat);
			
			
			var newGravity:b2Vec2 = new b2Vec2();
			newGravity.SetV(gravityDirection);
			var gravitySize:Number = Math.sqrt(aX * aX + aY * aY + aZ * aZ);// - Math.abs(aZ);
			//var linAccSize:Number = 0.0;
			if (gravitySize != 0.0)
			{
				gravitySize = Math.sqrt(aX * aX + aY * aY) / gravitySize;
				//gravitySize = gravityConstant;
				//linAccSize = gravitySize - gravityConstant;
			}
			
			//var linearFactor:Number = Math.sqrt(aX * aX + aY * aY) / gravityConstant;
			//newGravity.Multiply(linearFactor);
			newGravity.Multiply(gravitySize*gravityConstant);
			
			
			var alpha:Number = 0.8;
			gravity.Multiply(alpha);
			gravity.Add ( new b2Vec2(newGravity.x * (1.0 - alpha), newGravity.y * (1.0 - alpha)) );
			
			var linearAcceleration:b2Vec2 = new b2Vec2(newGravity.x - gravity.x, newGravity.y - gravity.y);
			gravity.SetV(newGravity);
			
			
			var linearVelocity:b2Vec2 = new b2Vec2();
			linearVelocity.SetV(linearAcceleration);
			linearVelocity.Multiply(timeStep);
			
			var dpi:Number = Capabilities.screenDPI;
			var scaleFactor:Number = Starling.contentScaleFactor;
			var inchesToMeters:Number = 0.0254;
			var metersWide:Number = Starling.current.nativeStage.fullScreenWidth * scaleFactor * inchesToMeters / dpi;
			var metersHigh:Number = Starling.current.nativeStage.fullScreenHeight * scaleFactor * inchesToMeters / dpi;
			var screenSize:b2Vec2 = new b2Vec2(metersWide, metersHigh);
			var realWorldToBoxWorld:Number = (Constants.GameWidth * metersPerPixel / metersWide);
			linearVelocity.Multiply(-realWorldToBoxWorld);
			//trace("linearVelocity = ( " + linearVelocity.x + ", " + linearVelocity.y + " )");
			//var beta:Number = 0.9;
			//var pos:b2Vec2 = boundaryBody.GetPosition();
			//linearVelocity.Multiply(beta);
			//linearVelocity.Add( new b2Vec2( -pos.x * (1.0 - beta) / timeStep, -pos.y * (1.0 - beta) / timeStep) );
			
			boundaryBody.SetLinearVelocity(linearVelocity);
			
			var aFactor:Number = 0.2;
			var targetAngle:Number = boundaryBody.GetAngle();
			var angularVel:Number = -(aFactor * gZ ) - ((1 - aFactor) * targetAngle / timeStep);
			boundaryBody.SetAngularVelocity(angularVel);
			
			
			///// BEGIN LINEAR SHIZ
			
			
			// apply gravity
			myShape1.mBody.ApplyForce(gravity, myShape1.mBody.GetPosition());
			myShape2.mBody.ApplyForce(gravity, myShape2.mBody.GetPosition());
			
			// step the world forward then clear the forces
			//world.Step(timeStep, velocityIterations, positionIterations);
			world.Step(timeStep, 1, 1);
			world.ClearForces();
			
			// set the border positions and rotation
			bordersImage.x = Constants.CenterX + (boundaryBody.GetPosition().x * pixelsPerMeter);
			bordersImage.y = Constants.CenterY + (boundaryBody.GetPosition().y * pixelsPerMeter);
			bordersImage.rotation = boundaryBody.GetAngle();
			
			// set the bodies' positions and rotations
			for (var b:b2Body = world.GetBodyList(); b; b = b.GetNext())
			{
				if (b.GetUserData() == null)
				{
					continue;
				}
				if (b.GetUserData() is Shape)
				{
					var shape:Shape = b.GetUserData() as Shape;
					
					shape.x = Constants.CenterX + (b.GetPosition().x * pixelsPerMeter);
					shape.y = Constants.CenterY + (b.GetPosition().y * pixelsPerMeter);
					shape.rotation = b.GetAngle();
					shape.Update();
				}
			}
		}
	}

}