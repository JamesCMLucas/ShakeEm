package scenes 
{
	import flash.system.Capabilities;
	import linalg.Matrix3x3;
	import linalg.Quaternion;
	import linalg.Vector3;
	
	import de.patrickkulling.air.mobile.extensions.orientation.Orientation;
	import de.patrickkulling.air.mobile.extensions.orientation.event.*;
	
	import ShakeEmLib.sensors.SmoothMagnetometer;
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
		private var orientation:Orientation;
		private var o_azimuth:Number = 0.0;
		private var o_roll:Number = 0.0;
		private var o_pitch:Number = 0.0;
		
		
		private var beta:Number = Math.sqrt(3.0 / 4.0) * Constants.Pi_Div_6;
		private var zeta:Number = beta / 60;
		private var b_x:Number = 1;
		private var b_z:Number = 0;
		// estimated gyroscope bias error
		private var w_bx:Number = 0.0;
		private var w_by:Number = 0.0;
		private var w_bz:Number = 0.0;
		
		
		public var accV3Cache:b2Vec3;
		public var acc:SmoothAccelerometer;
		public var gyro:SmoothGyroscope;
		public var mag:SmoothMagnetometer;
		
		public var quat:Quaternion;
		
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
			quat = new Quaternion();
			gravity = new b2Vec2();
			accV3Cache = new b2Vec3();
			
			mag = new SmoothMagnetometer(3);
			// create the smooth gyroscope
			gyro = new SmoothGyroscope(3);
			// create the smooth accelerometer
			acc = new SmoothAccelerometer(3);
			// per-frame update
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateFrame);
			//addEventListener(OrientationEvent.UPDATE, updateOrientation);
			//addEventListener(EnterFrameEvent.ENTER_FRAME, updateFrameWithMag);
			orientation = new Orientation();
			orientation.setRequestedUpdateInterval(0);
			orientation.addEventListener(OrientationEvent.UPDATE, updateOrientation);
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
			//bordersImage.
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
		
		public function updateOrientation(e:OrientationEvent):void
		{
			o_roll = e.roll;
			o_azimuth = e.azimuth;
			o_pitch = e.pitch;
		}
		
		public function updateFrameWithMag(e:EnterFrameEvent):void
		{
			function traceVector(v:Vector3):void
			{
				trace(v + " = (" + v.x + ", " + v.y + ", " + v.z + ")");
			}
			
			var dt:Number = e.passedTime;
			
			acc.updatePerFrame();
			gyro.updatePerFrame();
			mag.updatePerFrame();
			
			var aX:Number = acc.smoothX;
			var aY:Number = acc.smoothY;
			var aZ:Number = acc.smoothZ;
			
			var gX:Number = gyro.smoothX;
			var gY:Number = gyro.smoothY;
			var gZ:Number = gyro.smoothZ;
			
			var mX:Number = mag.smoothX;
			var mY:Number = mag.smoothY;
			var mZ:Number = mag.smoothZ;
			
			
			this.ahrsUpdate(dt, gX, gY, gZ, aX, aY, aZ, mX, mY, mZ);
			//this.filterUpdate(dt, gX, gY, gZ, aX, aY, aZ, mX, mY, mZ);
			//trace(this.w_bx + ", " + this.w_by + ", " + this.w_bz);
			//var quatInv:Quaternion = quat.clone();
			//var mat:Matrix3x3 = quat.getRotationMatrix();
			//var xAxis:Vector3 = mat.GetRow1();
			var xAxis:Vector3 = quat.getLocalXAxis();
			traceVector(xAxis);
			//quatInv.invert();
			//var xAxis:Vector3 = quatInv.getLocalXAxis();
			//traceVector(xAxis);
			//var yAxis:Vector3 = quatInv.getLocalYAxis();
			//var zAxis:Vector3 = quatInv.getLocalZAxis();
			//trace("(" + xAxis.length() + ", " + yAxis.length() + ", " + zAxis.length() + ")");
			//var right:Vector3 = new Vector3(1.0, 0.0, 0.0);
			//quatInv.applyToVector(right);
			//trace("right = (" + right.x + ", " + right.y + ", " + right.z + ")");
			
			//quat.applyToVector(xAxis);
			//var axis:Vector3 = quatInv.getAxis();
			//var angle:Number = quatInv.getAngle();
			//var down:Vector3 = new Vector3(0.0, 0.0, -1.0);
			//quatInv.applyToVector(down);
			//trace("angle = " + angle + ",  axis = (" + axis.x + ", " + axis.y + ", " + axis.z + ")");
			
			
			/*
			var a:Vector3 = new Vector3(aX, aY, aZ);
			var g:Vector3 = new Vector3(gX, gY, gZ);
			var m:Vector3 = new Vector3(mX, mY, mZ);
			
			a.normalize();
			m.normalize();
			traceVector(m);
			var AcrossM:Vector3 = a.cross(m);
			
			var angle:Number = Math.atan2(m.y, m.x);
			bordersImage.rotation = angle;
			*/
		}
		
		private function filterUpdate(deltat:Number, w_x:Number, w_y:Number, w_z:Number, a_x:Number, a_y:Number, a_z:Number, m_x:Number, m_y:Number, m_z:Number):void
		{
			// local system variables
            var norm:Number;                                                            // vector norm
            var SEqDot_omega_w:Number; var SEqDot_omega_x:Number; var SEqDot_omega_y:Number; var SEqDot_omega_z:Number;  // quaternion rate from gyroscopes elements
            var f_1:Number; var f_2:Number; var f_3:Number; var f_4:Number; var f_5:Number; var f_6:Number;                                    // objective function elements
            var J_11or24:Number; var J_12or23:Number; var J_13or22:Number; var J_14or21:Number; var J_32:Number; var J_33:Number;              // objective function Jacobian elements
            var J_41:Number; var J_42:Number; var J_43:Number; var J_44:Number; var J_51:Number; var J_52:Number; var J_53:Number; var J_54:Number; var J_61:Number; var J_62:Number; var J_63:Number; var J_64:Number; //
            var SEqHatDot_w:Number; var SEqHatDot_x:Number; var SEqHatDot_y:Number; var SEqHatDot_z:Number;              // estimated direction of the gyroscope error (quaternion derrivative)
            var w_err_x:Number; var w_err_y:Number; var w_err_z:Number;                                       // estimated direction of the gyroscope error (angular)
            var h_x:Number; var h_y:Number; var h_z:Number;                                                   // computed flux in the earth frame
			
			var SEq_x:Number = quat.x; var SEq_y:Number = quat.y; var SEq_z:Number = quat.z; var SEq_w:Number = quat.w;
			
            // axulirary variables to avoid reapeated calcualtions
            var halfSEq_w:Number = 0.5 * SEq_w;
            var halfSEq_x:Number = 0.5 * SEq_x;
            var halfSEq_y:Number = 0.5 * SEq_y;
            var halfSEq_z:Number = 0.5 * SEq_z;
            var twoSEq_w:Number = 2.0 * SEq_w;
            var twoSEq_x:Number = 2.0 * SEq_x;
            var twoSEq_y:Number = 2.0 * SEq_y;
            var twoSEq_z:Number = 2.0 * SEq_z;
            var twob_x:Number = 2 * b_x;
            var twob_z:Number = 2 * b_z;
            var twob_xSEq_w:Number = 2 * b_x * SEq_w;
            var twob_xSEq_x:Number = 2 * b_x * SEq_x;
            var twob_xSEq_y:Number = 2 * b_x * SEq_y;
            var twob_xSEq_z:Number = 2 * b_x * SEq_z;
            var twob_zSEq_w:Number = 2 * b_z * SEq_w;
            var twob_zSEq_x:Number = 2 * b_z * SEq_x;
            var twob_zSEq_y:Number = 2 * b_z * SEq_y;
            var twob_zSEq_z:Number = 2 * b_z * SEq_z;
            var SEq_wSEq_x:Number;
            var SEq_wSEq_y:Number = SEq_w * SEq_y;
            var SEq_wSEq_z:Number;
            var SEq_xSEq_y:Number;
            var SEq_xSEq_z:Number = SEq_x * SEq_z;
            var SEq_ySEq_z:Number;
            var twom_x:Number = 2 * m_x;
            var twom_y:Number = 2 * m_y;
            var twom_z:Number = 2 * m_z;

            // normalise the accelerometer measurement
            norm = Math.sqrt(a_x * a_x + a_y * a_y + a_z * a_z);
            a_x /= norm;
            a_y /= norm;
            a_z /= norm;

            // normalise the magnetometer measurement
            norm = Math.sqrt(m_x * m_x + m_y * m_y + m_z * m_z);
            m_x /= norm;
            m_y /= norm;
            m_z /= norm;

            // compute the objective function and Jacobian
            f_1 = twoSEq_x * SEq_z - twoSEq_w * SEq_y - a_x;
            f_2 = twoSEq_w * SEq_x + twoSEq_y * SEq_z - a_y;
            f_3 = 1.0 - twoSEq_x * SEq_x - twoSEq_y * SEq_y - a_z;
            f_4 = twob_x * (0.5 - SEq_y * SEq_y - SEq_z * SEq_z) + twob_z * (SEq_xSEq_z - SEq_wSEq_y) - m_x;
            f_5 = twob_x * (SEq_x * SEq_y - SEq_w * SEq_z) + twob_z * (SEq_w * SEq_x + SEq_y * SEq_z) - m_y;
            f_6 = twob_x * (SEq_wSEq_y + SEq_xSEq_z) + twob_z * (0.5 - SEq_x * SEq_x - SEq_y * SEq_y) - m_z;
            J_11or24 = twoSEq_y;                                                    // J_11 negated in matrix multiplication
            J_12or23 = 2 * SEq_z;
            J_13or22 = twoSEq_w;                                                    // J_12 negated in matrix multiplication
            J_14or21 = twoSEq_x;
            J_32 = 2 * J_14or21;                                                    // negated in matrix multiplication
            J_33 = 2 * J_11or24;                                                    // negated in matrix multiplication
            J_41 = twob_zSEq_y;                                                     // negated in matrix multiplication
            J_42 = twob_zSEq_z;
            J_43 = 2 * twob_xSEq_y + twob_zSEq_w;                                   // negated in matrix multiplication
            J_44 = 2 * twob_xSEq_z - twob_zSEq_x;                                   // negated in matrix multiplication
            J_51 = twob_xSEq_z - twob_zSEq_x;                                       // negated in matrix multiplication
            J_52 = twob_xSEq_y + twob_zSEq_w;
            J_53 = twob_xSEq_x + twob_zSEq_z;
            J_54 = twob_xSEq_w - twob_zSEq_y;                                       // negated in matrix multiplication
            J_61 = twob_xSEq_y;
            J_62 = twob_xSEq_z - 2 * twob_zSEq_x;
            J_63 = twob_xSEq_w - 2 * twob_zSEq_y;
            J_64 = twob_xSEq_x;

            // compute the gradient (matrix multiplication)
            SEqHatDot_w = J_14or21 * f_2 - J_11or24 * f_1 - J_41 * f_4 - J_51 * f_5 + J_61 * f_6;
            SEqHatDot_x = J_12or23 * f_1 + J_13or22 * f_2 - J_32 * f_3 + J_42 * f_4 + J_52 * f_5 + J_62 * f_6;
            SEqHatDot_y = J_12or23 * f_2 - J_33 * f_3 - J_13or22 * f_1 - J_43 * f_4 + J_53 * f_5 + J_63 * f_6;
            SEqHatDot_z = J_14or21 * f_1 + J_11or24 * f_2 - J_44 * f_4 - J_54 * f_5 + J_64 * f_6;

            // normalise the gradient to estimate direction of the gyroscope error
            norm = Math.sqrt(SEqHatDot_w * SEqHatDot_w + SEqHatDot_x * SEqHatDot_x + SEqHatDot_y * SEqHatDot_y + SEqHatDot_z * SEqHatDot_z);
            SEqHatDot_w = SEqHatDot_w / norm;
            SEqHatDot_x = SEqHatDot_x / norm;
            SEqHatDot_y = SEqHatDot_y / norm;
            SEqHatDot_z = SEqHatDot_z / norm;

            // compute angular estimated direction of the gyroscope error
            w_err_x = twoSEq_w * SEqHatDot_x - twoSEq_x * SEqHatDot_w - twoSEq_y * SEqHatDot_z + twoSEq_z * SEqHatDot_y;
            w_err_y = twoSEq_w * SEqHatDot_y + twoSEq_x * SEqHatDot_z - twoSEq_y * SEqHatDot_w - twoSEq_z * SEqHatDot_x;
            w_err_z = twoSEq_w * SEqHatDot_z - twoSEq_x * SEqHatDot_y + twoSEq_y * SEqHatDot_x - twoSEq_z * SEqHatDot_w;

            // compute and remove the gyroscope baises
            w_bx += w_err_x * deltat * zeta;
            w_by += w_err_y * deltat * zeta;
            w_bz += w_err_z * deltat * zeta;
            w_x -= w_bx;
            w_y -= w_by;
            w_z -= w_bz;

            // compute the quaternion rate measured by gyroscopes
            SEqDot_omega_w = -halfSEq_x * w_x - halfSEq_y * w_y - halfSEq_z * w_z;
            SEqDot_omega_x = halfSEq_w * w_x + halfSEq_y * w_z - halfSEq_z * w_y;
            SEqDot_omega_y = halfSEq_w * w_y - halfSEq_x * w_z + halfSEq_z * w_x;
            SEqDot_omega_z = halfSEq_w * w_z + halfSEq_x * w_y - halfSEq_y * w_x;

            // compute then integrate the estimated quaternion rate
            SEq_w += (SEqDot_omega_w - (beta * SEqHatDot_w)) * deltat;
            SEq_x += (SEqDot_omega_x - (beta * SEqHatDot_x)) * deltat;
            SEq_y += (SEqDot_omega_y - (beta * SEqHatDot_y)) * deltat;
            SEq_z += (SEqDot_omega_z - (beta * SEqHatDot_z)) * deltat;

            // normalise quaternion
            norm = Math.sqrt(SEq_w * SEq_w + SEq_x * SEq_x + SEq_y * SEq_y + SEq_z * SEq_z);
            SEq_w /= norm;
            SEq_x /= norm;
            SEq_y /= norm;
            SEq_z /= norm;

            // compute flux in the earth frame
            SEq_wSEq_x = SEq_w * SEq_x;                                             // recompute axulirary variables
            SEq_wSEq_y = SEq_w * SEq_y;
            SEq_wSEq_z = SEq_w * SEq_z;
            SEq_ySEq_z = SEq_y * SEq_z;
            SEq_xSEq_y = SEq_x * SEq_y;
            SEq_xSEq_z = SEq_x * SEq_z;
            h_x = twom_x * (0.5 - SEq_y * SEq_y - SEq_z * SEq_z) + twom_y * (SEq_xSEq_y - SEq_wSEq_z) + twom_z * (SEq_xSEq_z + SEq_wSEq_y);
            h_y = twom_x * (SEq_xSEq_y + SEq_wSEq_z) + twom_y * (0.5 - SEq_x * SEq_x - SEq_z * SEq_z) + twom_z * (SEq_ySEq_z - SEq_wSEq_x);
            h_z = twom_x * (SEq_xSEq_z - SEq_wSEq_y) + twom_y * (SEq_ySEq_z + SEq_wSEq_x) + twom_z * (0.5 - SEq_x * SEq_x - SEq_y * SEq_y);

            // normalise the flux vector to have only components in the x and z
            b_x = Math.sqrt((h_x * h_x) + (h_y * h_y));
            b_z = h_z;
			
			quat.set(SEq_x, SEq_y, SEq_z, SEq_w);
		}
		
		private function ahrsUpdate(dt:Number, gx:Number, gy:Number, gz:Number, ax:Number, ay:Number, az:Number, mx:Number, my:Number, mz:Number):void
		{
			var qw:Number = quat.w;
			var qx:Number = quat.x;
			var qy:Number = quat.y;
			var qz:Number = quat.z;   // short name local variable for readability
            var norm:Number;
            var hx:Number;
			var hy:Number; 
			var _2bx:Number;
			var _2bz:Number;
            var sw:Number;
			var sx:Number
			var sy:Number; 
			var sz:Number;
            var qDotw:Number;
			var qDotx:Number;
			var qDoty:Number;
			var qDotz:Number;

            // Auxiliary variables to avoid repeated arithmetic
            var _2qwmx:Number;
            var _2qwmy:Number;
            var _2qwmz:Number;
            var _2qxmx:Number;
            var _4bx:Number;
            var _4bz:Number;
            var _2qw:Number = 2 * qw;
            var _2qx:Number = 2 * qx;
            var _2qy:Number = 2 * qy;
            var _2qz:Number = 2 * qz;
            var _2qwqy:Number = 2 * qw * qy;
            var _2qyqz:Number = 2 * qy * qz;
            var qwqw:Number = qw * qw;
            var qwqx:Number = qw * qx;
            var qwqy:Number = qw * qy;
            var qwqz:Number = qw * qz;
            var qxqx:Number = qx * qx;
            var qxqy:Number = qx * qy;
            var qxqz:Number = qx * qz;
            var qyqy:Number = qy * qy;
            var qyqz:Number = qy * qz;
            var qzqz:Number = qz * qz;

            // Normalise accelerometer measurement
            norm = Math.sqrt(ax * ax + ay * ay + az * az);
            if (norm == 0.0) return; // handle NaN
            norm = 1 / norm;        // use reciprocal for division
            ax *= norm;
            ay *= norm;
            az *= norm;

            // Normalise magnetometer measurement
            norm = Math.sqrt(mx * mx + my * my + mz * mz);
            if (norm == 0.0) return; // handle NaN
            norm = 1 / norm;        // use reciprocal for division
            mx *= norm;
            my *= norm;
            mz *= norm;

            // Reference direction of Earth's magnetic field
            _2qwmx = 2 * qw * mx;
            _2qwmy = 2 * qw * my;
            _2qwmz = 2 * qw * mz;
            _2qxmx = 2 * qx * mx;
            hx = mx * qwqw - _2qwmy * qz + _2qwmz * qy + mx * qxqx + _2qx * my * qy + _2qx * mz * qz - mx * qyqy - mx * qzqz;
            hy = _2qwmx * qz + my * qwqw - _2qwmz * qx + _2qxmx * qy - my * qxqx + my * qyqy + _2qy * mz * qz - my * qzqz;
            _2bx = Math.sqrt(hx * hx + hy * hy);
            _2bz = -_2qwmx * qy + _2qwmy * qx + mz * qwqw + _2qxmx * qz - mz * qxqx + _2qy * my * qz - mz * qyqy + mz * qzqz;
            _4bx = 2 * _2bx;
            _4bz = 2 * _2bz;

            // Gradient decent algorithm corrective step
            sw = -_2qy * (2 * qxqz - _2qwqy - ax) + _2qx * (2 * qwqx + _2qyqz - ay) - _2bz * qy * (_2bx * (0.5 - qyqy - qzqz) + _2bz * (qxqz - qwqy) - mx) + (-_2bx * qz + _2bz * qx) * (_2bx * (qxqy - qwqz) + _2bz * (qwqx + qyqz) - my) + _2bx * qy * (_2bx * (qwqy + qxqz) + _2bz * (0.5 - qxqx - qyqy) - mz);
            sx = _2qz * (2 * qxqz - _2qwqy - ax) + _2qw * (2 * qwqx + _2qyqz - ay) - 4 * qx * (1 - 2 * qxqx - 2 * qyqy - az) + _2bz * qz * (_2bx * (0.5 - qyqy - qzqz) + _2bz * (qxqz - qwqy) - mx) + (_2bx * qy + _2bz * qw) * (_2bx * (qxqy - qwqz) + _2bz * (qwqx + qyqz) - my) + (_2bx * qz - _4bz * qx) * (_2bx * (qwqy + qxqz) + _2bz * (0.5 - qxqx - qyqy) - mz);
            sy = -_2qw * (2 * qxqz - _2qwqy - ax) + _2qz * (2 * qwqx + _2qyqz - ay) - 4 * qy * (1 - 2 * qxqx - 2 * qyqy - az) + (-_4bx * qy - _2bz * qw) * (_2bx * (0.5 - qyqy - qzqz) + _2bz * (qxqz - qwqy) - mx) + (_2bx * qx + _2bz * qz) * (_2bx * (qxqy - qwqz) + _2bz * (qwqx + qyqz) - my) + (_2bx * qw - _4bz * qy) * (_2bx * (qwqy + qxqz) + _2bz * (0.5 - qxqx - qyqy) - mz);
            sz = _2qx * (2 * qxqz - _2qwqy - ax) + _2qy * (2 * qwqx + _2qyqz - ay) + (-_4bx * qz + _2bz * qx) * (_2bx * (0.5 - qyqy - qzqz) + _2bz * (qxqz - qwqy) - mx) + (-_2bx * qw + _2bz * qy) * (_2bx * (qxqy - qwqz) + _2bz * (qwqx + qyqz) - my) + _2bx * qx * (_2bx * (qwqy + qxqz) + _2bz * (0.5 - qxqx - qyqy) - mz);
            norm = 1.0 / Math.sqrt(sw * sw + sx * sx + sy * sy + sz * sz);    // normalise step magnitude
            sw *= norm;
            sx *= norm;
            sy *= norm;
            sz *= norm;
			
			var beta:Number = 0.1;
            // Compute rate of change of quaternion
            qDotw = 0.5 * (-qx * gx - qy * gy - qz * gz) - beta * sw;
            qDotx = 0.5 * (qw * gx + qy * gz - qz * gy) - beta * sx;
            qDoty = 0.5 * (qw * gy - qx * gz + qz * gx) - beta * sy;
            qDotz = 0.5 * (qw * gz + qx * gy - qy * gx) - beta * sz;

            // Integrate to yield quaternion
            qw += qDotw * dt;
            qx += qDotx * dt;
            qy += qDoty * dt;
            qz += qDotz * dt;
            norm = 1.0 / Math.sqrt(qw * qw + qx * qx + qy * qy + qz * qz);    // normalise quaternion
            quat.w = qw * norm;
            quat.x = qx * norm;
            quat.y = qy * norm;
            quat.z = qz * norm;
		}
		
		public function updateFrame(e:EnterFrameEvent):void
		{
			var dt:Number = e.passedTime;
			trace("roll = " + o_roll + "   pitch = " + o_pitch + "   azimuth = " + o_azimuth);
		}
		
		/*
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
			var alpha:Number = 0.8;
			accDiff.Multiply(alpha);
			accV3Cache.Multiply(1.0 - alpha);
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
			//trace("angle = " + gyroQuat.getAngle() + ",   axis (" + gyroAxis.length() + ") = " + "(" +gyroAxis.x + ", " + gyroAxis.y + ", " + gyroAxis.z + ")");
			
			
			
			var filterCoeff:Number = 0.75;
			//currentAngle = ( filterCoeff * (currentAngle + gZ * dt)) + ((1.0 - filterCoeff) * accRot);
			var newAngle:Number = ( filterCoeff * (currentAngle + gZ * dt)) + ((1.0 - filterCoeff) * rotZ);
			
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
			var targetAngularVelocity:Number = (rotZ - boundaryBody.GetAngle()) / timeStep;
			//var targetAngularVelocity:Number = (newAngle - boundaryBody.GetAngle()) / timeStep;
			var angularVel:Number = -(aFactor * gZ ) + ((1 - aFactor) * targetAngularVelocity);
			boundaryBody.SetAngularVelocity(angularVel);
			
			//bordersImage.rotation = newAngle;
			//this.rotation = -newAngle;
			var gravityConstant:Number = 9.81;
			var g3D:Vector3 = new Vector3(aX, aY, aZ);
			var g3DSize:Number = g3D.normalizeAndGetLength();
			var excess:Number = g3DSize - 1.0;
			
			//trace("excess = " + excess);
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
			gravity.Set( -9.81, 0.0);
			
			//trace("bodyAngle = " + boundaryBody.GetAngle() + "   rotZ = " + rotZ + "   newAngle = " + newAngle);
			var gravity2DSize:Number = 0.0;
			if (g3DSize != 0.0)
			{
				gravity2DSize = (g3D.x * g3D.x + g3D.y * g3D.y);
				//gravity.Set((g3D.x / g3DSize), (g3D.y / g3DSize));
				//gravity.MulTM(rotMat);
				//gravity.Multiply( -gravityConstant);
				//shake.MulM(rotMat);
				//gravity.SetV(shake);
				//gravity.Add(shake);
			}
			// apply gravity
			gravity.Multiply(gravity2DSize);
			//trace("gravity 2D size = " + gravity2DSize);
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
		*/
	}

}