package scenes 
{
	import de.patrickkulling.air.mobile.extensions.orientation.Orientation;
	import de.patrickkulling.air.mobile.extensions.orientation.event.*;
	import ShakeEmLib.sensors.SmoothAccelerometer;
	
	import de.patrickkulling.air.mobile.extensions.gravity.Gravity;
	import de.patrickkulling.air.mobile.extensions.gravity.event.*;
	
	import linalg.Matrix3x3;
	import linalg.Quaternion;
	import linalg.Vector3;
	
	import ShakeEmLib.Shape;
	
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
	public class KullingTest extends Scene
	{
		private var accelerometer:SmoothAccelerometer;
		
		private var orientation:Orientation;
		private var o:Quaternion;
		
		private var gravity:Gravity;
		private var g:Vector3;
		
		public var world:b2World;
		public var boundaryBody:b2Body;
		public var velocityIterations:int = 5;
		public var positionIterations:int = 5;
		public var timeStep:Number = 1.0 / 30.0;
		
		public var pixelsPerMeter:Number = 50;
		public var metersPerPixel:Number = 1 / pixelsPerMeter;
		
		public var myShape1:Shape;
		public var myShape2:Shape;
		public var bordersImage:Image;
		
		public var arrow:Image;
		
		public var worldSprite:Sprite;
		
		public function KullingTest() 
		{
			accelerometer = new SmoothAccelerometer(3);
			
			orientation = new Orientation();
			orientation.setRequestedUpdateInterval(0);
			orientation.addEventListener(OrientationEvent.UPDATE, updateOrientation);
			
			o = new Quaternion();
			
			
			gravity = new Gravity();
			gravity.setRequestedUpdateInterval(0);
			gravity.addEventListener(GravityEvent.UPDATE, updateGravity);
			
			g = new Vector3();
			
			createTestWorld();
			
			arrow = new Image(Assets.getTexture("NorthArrow"));
			var arrowSize:Number = Constants.GameWidth / 4;
			arrow.pivotX = arrow.width / 2;
			arrow.pivotY = arrow.height / 2;
			arrow.width = arrowSize;
			arrow.height = arrowSize;
			arrow.x = 0.0;// Constants.CenterX;
			arrow.y = 0.0;// Constants.CenterY;
			
			addChild(arrow);
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateFrame);
		}
		
		
		public function updateOrientation(e:OrientationEvent):void
		{
			var o_roll:Number = -e.roll * Constants.Pi / 180.0;;
			var o_azimuth:Number = -e.azimuth * Constants.Pi / 180.0;;
			var o_pitch:Number = -e.pitch * Constants.Pi / 180.0;;
			
			var q:Quaternion = Quaternion.spawnEulerAngles(o_roll, o_pitch, o_azimuth);
			o.setQ(q);
		}
		
		public function updateGravity(e:GravityEvent):void
		{
			g.set(e.x, e.y, e.z);
		}
		
		public function updateFrame(e:EnterFrameEvent):void
		{
			var dt:Number = e.passedTime;
			
			accelerometer.updatePerFrame();
			
			
			var xAxis:Vector3 = o.getLocalXAxis();
			var yAxis:Vector3 = o.getLocalYAxis();
			var zAxis:Vector3 = o.getLocalZAxis();
			//trace("xAxis = (" + xAxis.x + ", " + xAxis.y + ", " + xAxis.z + ")");
			//trace("yAxis = (" + yAxis.x + ", " + yAxis.y + ", " + yAxis.z + ")");
			//trace("zAxis = (" + zAxis.x + ", " + zAxis.y + ", " + zAxis.z + ")");
			//trace("g = (" + g.x + ", " + g.y + ", " + g.z + ")   len = " + g.length());
			var currentAngle:Number = Math.atan2(xAxis.z, yAxis.z);
			
			// this is supposed to prevent jumping around when
			// there's too little xy data to use
			var maxThresh:Number = 0.01;
			var minThresh:Number = 0.001;
			var absOneMinusZ:Number = 1.0 - Math.abs(zAxis.z);
			if (absOneMinusZ < minThresh)
			{
				currentAngle = 0.0;
			}
			else if(absOneMinusZ < maxThresh)
			{
				currentAngle *= (absOneMinusZ - minThresh) / (maxThresh - minThresh);
			}
			
			//trace("currentAngle = " + currentAngle);
			arrow.rotation = currentAngle;
			
			
			// set the acceleration due to gravity
			var acc_gravity:b2Vec2 = new b2Vec2(xAxis.z, yAxis.z);
			
			
			// set the acceleration due to shaking
			var acc_shake:b2Vec2 = new b2Vec2(accelerometer.smoothX, accelerometer.smoothY);
			acc_shake.Subtract(acc_gravity);
			trace("shake = (" + acc_shake.x + ", " + acc_shake.y + ")");
			
			// scale the gravity after calculating shake
			var gravityConstant:Number = -9.81;
			acc_gravity.Multiply(gravityConstant);
			
			// set the overall linear acceleration
			var acc_applied:b2Vec2 = new b2Vec2();
			acc_applied.SetV(acc_gravity);
			
			
			// apply the acceleration to the bodies
			var force:b2Vec2 = acc_applied.Copy();
			force.Multiply(myShape1.mBody.GetMass());
			myShape1.mBody.ApplyForce(force, myShape1.mBody.GetPosition());
			force.SetV(acc_applied);
			force.Multiply(myShape2.mBody.GetMass());
			myShape2.mBody.ApplyForce(force, myShape2.mBody.GetPosition());
			
			updateTestWorldPhysics();
			updateTestWorldGraphics();
		}
		
		public function calculatePhonePhysics():void
		{
			var dpi:Number = Capabilities.screenDPI;
			var scaleFactor:Number = Starling.contentScaleFactor;
			var inchesToMeters:Number = 0.0254;
			var metersWide:Number = Starling.current.nativeStage.fullScreenWidth * scaleFactor * inchesToMeters / dpi;
			var metersHigh:Number = Starling.current.nativeStage.fullScreenHeight * scaleFactor * inchesToMeters / dpi;
			var screenSize:b2Vec2 = new b2Vec2(metersWide, metersHigh);
			var realWorldToBoxWorld:Number = (Constants.GameWidth * metersPerPixel / metersWide);
		}
		
		public function updateTestWorldPhysics():void
		{
			world.Step(timeStep, velocityIterations, positionIterations);
			//world.Step(timeStep, 1, 1);
			world.ClearForces();
		}
		
		public function updateTestWorldGraphics():void
		{
			bordersImage.x = boundaryBody.GetPosition().x * pixelsPerMeter;
			bordersImage.y = -(boundaryBody.GetPosition().y * pixelsPerMeter);
			
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
		
		public function createTestWorld():void
		{
			// non-inertial frame
			worldSprite = new Sprite();
			worldSprite.pivotX = Constants.GameWidth / 2;
			worldSprite.pivotY = Constants.GameHeight / 2;
			addChild(worldSprite);
			
			this.x = Constants.CenterX;
			this.y = Constants.CenterY;
			
			// world sizing
			var worldHalfWidth:Number = Constants.GameWidth * metersPerPixel / 2;
			var worldHalfHeight:Number = Constants.GameHeight * metersPerPixel / 2;
			
			
			// set some gravity - (we apply it manually per frame step)
			var zeroGravity:b2Vec2 = new b2Vec2(0.0, 0.0);
			// allow bodies to sleep
			var bAllowBodiesToSleep:Boolean = true;
			
			// make the world
			world = new b2World(zeroGravity, bAllowBodiesToSleep);
			
			
			bordersImage = new Image(Assets.getTexture("RedBorders"));
			bordersImage.pivotX = bordersImage.width / 2;
			bordersImage.pivotY = bordersImage.height / 2;
			bordersImage.width = Constants.GameWidth;
			bordersImage.height = Constants.GameHeight;
			bordersImage.x = 0.0;
			bordersImage.y = 0.0;
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
		
	}

}