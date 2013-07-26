package scenes 
{
	import flash.system.Capabilities;
	import linalg.Quaternion;
	import linalg.Vector3;
	
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
	public class AccelerationTest extends Scene
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
		public var worldSprite:Sprite;
		
		public function AccelerationTest()
		{
			worldSprite = new Sprite();
			//worldSprite.x = Constants.CenterX;
			//worldSprite.y = Constants.CenterY;
			worldSprite.pivotX = Constants.GameWidth / 2;
			worldSprite.pivotY = Constants.GameHeight / 2;
			
			addChild(worldSprite);
			
			
			//this.pivotX = Constants.GameWidth / 2;
			//this.pivotY = Constants.GameHeight / 2;
			//this.x = Constants.GameWidth;
			//this.y = Constants.GameHeight;
			
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
			bordersImage.x = 0.0;// Constants.CenterX;
			bordersImage.y = 0.0;//Constants.CenterY;
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
			worldSprite.addChild(myShape1);
			myShape2 = new Shape("Asteroid", "Blue", circle2PixelSize, circle2PixelSize, false);
			worldSprite.addChild(myShape2);
			
			
			
			// make the first circle body
			var circleShape:b2CircleShape = new b2CircleShape(circleWorldRadius);
			var circleBodyDef:b2BodyDef = new b2BodyDef();
			var circleFixtureDef:b2FixtureDef = new b2FixtureDef();
			circleBodyDef.type = b2Body.b2_dynamicBody;
			circleBodyDef.angularDamping = 0.1;
			circleBodyDef.linearDamping = 0.1;
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
			circleBodyDef.angularDamping = 0.1;
			circleBodyDef.linearDamping = 0.1;
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
			wallFixtureDef.isSensor;
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
			
			var accDiff:b2Vec3 = new b2Vec3(aX, aY, aZ);
			accDiff.Subtract(accV3Cache);
			accV3Cache.Set(aX, aY, aZ);
			
			var rotZ:Number = Math.atan2(-aY, aX);
			//var rotZ:Number = Math.atan2(aX, aY);
			//trace("rotZ = " + rotZ);
			// apply rotation
			var gX:Number = gyro.smoothX;
			var gY:Number = gyro.smoothY;
			var gZ:Number = gyro.smoothZ;
			
			var gyroQuat:Quaternion = Quaternion.spawnEulerAngles(gY, gX, gZ);
			var gyroAxis:Vector3 = gyroQuat.getAxis();
			trace(gyroAxis.x + ", " + gyroAxis.y + ", " + gyroAxis.z);
			
			var filterCoeff:Number = 0.75;
			//currentAngle = ( filterCoeff * (currentAngle + gZ * dt)) + ((1.0 - filterCoeff) * accRot);
			var newAngle:Number = -( filterCoeff * (currentAngle + gZ * timeStep)) + ((1.0 - filterCoeff) * rotZ);
			
			var dpi:Number = Capabilities.screenDPI;
			var scaleFactor:Number = Starling.contentScaleFactor;
			var inchesToMeters:Number = 0.0254;
			var metersWide:Number = Starling.current.nativeStage.fullScreenWidth * scaleFactor * inchesToMeters / dpi;
			var metersHigh:Number = Starling.current.nativeStage.fullScreenHeight * scaleFactor * inchesToMeters / dpi;
			var screenSize:b2Vec2 = new b2Vec2(metersWide, metersHigh);
			var realWorldToBoxWorld:Number = (Constants.GameWidth * metersPerPixel / metersWide);
			//linearVelocity.Multiply(-realWorldToBoxWorld);
			
			//boundaryBody.SetLinearVelocity(linearVelocity);
			
			var aFactor:Number = 0.5;
			var targetAngularVelocity:Number = (newAngle - boundaryBody.GetAngle()) / timeStep;
			var angularVel:Number = -(aFactor * gZ ) + ((1 - aFactor) * targetAngularVelocity);
			boundaryBody.SetAngularVelocity(angularVel);
			
			//bordersImage.rotation = newAngle;
			//this.rotation = -newAngle;
			var gravityConstant:Number = 9.81;
			var g3D:Vector3 = new Vector3(aX, aY, aZ);
			var g3DSize:Number = g3D.normalizeAndGetLength();
			var excess:Number = g3DSize - 1.0;
			var shitfuck:Number = 10.0;
			
			var shakeX:Number = -accDiff.x * realWorldToBoxWorld * shitfuck;// -((aX - g3D.x) / g3DSize) * realWorldToBoxWorld;
			var shakeY:Number = -accDiff.y * realWorldToBoxWorld * shitfuck;//-((aY - g3D.y) / g3DSize) * realWorldToBoxWorld;
			//trace(realWorldToBoxWorld);
			var shake:b2Vec2 = new b2Vec2(shakeX, shakeY);
			//trace("shake = " + shake.Length());
			
			///// BEGIN LINEAR SHIZ
			
			//var gravityDirection:b2Vec2 = new b2Vec2(-g3D.x, -g3D.y);// 0.0, -1.0);
			var rotMat:b2Mat22 = new b2Mat22();
			rotMat.Set(newAngle);
			//shake.MulTM(rotMat);
			//gravityDirection.MulTM(rotMat);
			//gravity.Set(0.0, -9.8);
			if (g3DSize != 0.0)
			{
				gravity.Set((g3D.x / g3DSize), (g3D.y / g3DSize));
				gravity.MulM(rotMat);
				gravity.Multiply( -gravityConstant);
				shake.MulM(rotMat);
				//gravity.SetV(shake);
				gravity.Add(shake);
			}
			// apply gravity
			var force:b2Vec2 = gravity.Copy();
			force.Multiply(myShape1.mBody.GetMass());
			myShape1.mBody.ApplyForce(force, myShape1.mBody.GetPosition());
			force.SetV(gravity);
			force.Multiply(myShape2.mBody.GetMass());
			myShape2.mBody.ApplyForce(force, myShape2.mBody.GetPosition());
			
			// step the world forward then clear the forces
			world.Step(timeStep, velocityIterations, positionIterations);
			//world.Step(timeStep, 1, 1);
			world.ClearForces();
			//trace("newAngle = " + newAngle + ",  boundaryAngle = " + boundaryBody.GetAngle());
			// set the border positions and rotation
			bordersImage.x = boundaryBody.GetPosition().x * pixelsPerMeter;
			bordersImage.y = -(boundaryBody.GetPosition().y * pixelsPerMeter);
			//bordersImage.rotation = -boundaryBody.GetAngle();
			worldSprite.rotation = boundaryBody.GetAngle();// newAngle;// -bordersImage.rotation;// + Constants.Pi;
			this.x = Constants.CenterX;
			this.y = Constants.CenterY;
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
					shape.y = Constants.CenterY - (b.GetPosition().y * pixelsPerMeter);
					shape.rotation = -b.GetAngle();
					shape.Update();
				}
			}
		}
	}

}