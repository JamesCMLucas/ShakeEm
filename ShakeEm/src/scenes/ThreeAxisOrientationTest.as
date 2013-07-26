package scenes 
{
	import flash.system.Capabilities;
	
	import ShakeEmLib.sensors.SmoothAccelerometer;
	import ShakeEmLib.sensors.SmoothGyroscope;
	import ShakeEmLib.cBoundary;
	import ShakeEmLib.Shape;
	import ShakeEmLib.ContactListener;
	import ShakeEmLib.sensors.ShakeOMatic;
	
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
	public class ThreeAxisOrientationTest extends Scene
	{
		public var shaker:ShakeOMatic;
		
		public var arrowXImage:Image;
		public var arrowYImage:Image;
		public var arrowZImage:Image;
		
		public var accelerometer:SmoothAccelerometer;
		
		public var gyroscope:SmoothGyroscope;
		
		
		public function ThreeAxisOrientationTest() 
		{
			shaker = new ShakeOMatic(3);
			
			// create the smooth gyroscope
			//gyroscope = new SmoothGyroscope(3);
			// create the smooth accelerometer
			//accelerometer = new SmoothAccelerometer(3);
			// per-frame update
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateFrame);
			
			
			var imageSize:Number = 88;
			
			// X arrow is on top
			arrowXImage = new Image(Assets.getTexture("NorthArrow"));
			arrowXImage.pivotX = arrowXImage.width / 2;
			arrowXImage.pivotY = arrowXImage.height / 2;
			arrowXImage.width = imageSize;
			arrowXImage.height = imageSize;
			arrowXImage.x = Constants.CenterX;
			arrowXImage.y = Constants.CenterY - imageSize;
			addChild(arrowXImage);
			
			// Y arrow is in the middle
			arrowYImage = new Image(Assets.getTexture("NorthArrow"));
			arrowYImage.pivotX = arrowYImage.width / 2;
			arrowYImage.pivotY = arrowYImage.height / 2;
			arrowYImage.width = imageSize;
			arrowYImage.height = imageSize;
			arrowYImage.x = Constants.CenterX;
			arrowYImage.y = Constants.CenterY;
			addChild(arrowYImage);
			
			// Z arrow is on the bottom
			arrowZImage = new Image(Assets.getTexture("NorthArrow"));
			arrowZImage.pivotX = arrowZImage.width / 2;
			arrowZImage.pivotY = arrowZImage.height / 2;
			arrowZImage.width = imageSize;
			arrowZImage.height = imageSize;
			arrowZImage.x = Constants.CenterX;
			arrowZImage.y = Constants.CenterY + imageSize;
			addChild(arrowZImage);
		}
		
		/*! The per-frame update event function
		 */
		private function updateFrame(e:EnterFrameEvent):void
		{
			//gyroscope.updatePerFrame();
			//accelerometer.updatePerFrame();
			shaker.updatePerFrame(e.passedTime);
			
			arrowXImage.rotation = shaker.rotationX;
			arrowYImage.rotation = shaker.rotationY;
			arrowZImage.rotation = shaker.rotationZ;
			
			/*
			var dt:Number = e.passedTime;
			var filterCoeff:Number = 0.75;
			
			//calculate the angle from the accelerometer
			var accRot:Number = shaker.rotationZ;// = Math.atan2(accelerometer.smoothX, accelerometer.smoothY);
			var currentAngle:Number = arrowXImage.rotation;
			var gyroZ:Number = shaker.gyroValues.z;// = gyroscope.smoothZ;
			var gyroTolerance:Number = 0.001;  // using a gyro tolerance helps??
			
			// set the rotation as an estimate based on the current gyroZ reading and assiming we're one step behind
			if (Math.abs(gyroZ) > gyroTolerance)
			{
				// the "for sure" angle
				arrowXAngle = (filterCoeff * (arrowXAngle + gyroZ * dt)) + ((1.0 - filterCoeff) * accRot);
				// the predicted rotation
				var stepsBehind:Number = 2.0;
				arrowXImage.rotation = arrowXAngle + (gyroZ * dt * stepsBehind);
			}
			else
			{
				arrowXAngle = accRot;
				arrowXImage.rotation = arrowXAngle;
			}
			*/
			
			
			
			//ArrowFiltered.rotation = (filterCoeff * (currentAngle + gyroZ * dt)) + ((1.0 - filterCoeff) * accRot);
			
			//ArrowSmoothAcc.rotation = accRot;
			//ArrowSmoothGyro.rotation += FlashGyroZCache * dt;
		}
	}
}