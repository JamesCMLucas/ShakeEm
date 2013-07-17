package ShakeEmLib.sensors 
{
	import flash.system.Capabilities;
	
	import jlmath.alg.Vec2;
	import jlmath.alg.Vec3;
	
	/**
	 * ... 
	 * @author James
	 */
	public class KinematicDevice
	{
		/*! the accelerometer
		 */
		public var accelerometer:SmoothAccelerometer;
		/*! the gyroscope
		 */
		public var gyroscope:SmoothGyroscope;
		/*! the latest calculated gravity components of the accelerometer values (points down)
		 */
		public var gravityX:Number = 0.0;
		public var gravityY:Number = 0.0;
		public var gravityZ:Number = 0.0;
		
		/*! the latest accelerometer values (updated per frame)
		 */
		public var ax:Number = 0.0;
		public var ay:Number = 0.0;
		public var az:Number = 0.0;
		
		/*! the latest gyroscope values (updated per frame)
		 */
		public var gx:Number = 0.0;
		public var gy:Number = 0.0;
		public var gz:Number = 0.0;
		
		/*! the latest calculated angular velocities
		 */
		//public var angularVelX:Number = 0.0;
		//public var angularVelY:Number = 0.0;
		public var angularVelocity:Number = 0.0;
		private var angle:Number = 0.0;
		
		/*! complementary filter coeffiction
		 */
		private var filterCoefficient:Number = 0.75;
		 
		/*! complementary angular velocity coefficient
		 */
		private var avFilterCoefficient:Number = 0.2;
		
		/*! the physical size of the screen, in meters
		 */
		private var screenSize:Vec2;
		
		
		public function KinematicDevice(smoothness:uint = 3) 
		{
			if (smoothness < 1)
			{
				throw new ArgumentError("SensorDevice constructor: smoothness must be at least equal to 1");
			}
			
			try
			{
				accelerometer = new SmoothAccelerometer(smoothness);
			} 
			catch (e:Error)
			{
				throw new Error("SensorDevice constructor: Something went wrong making the accelerometer!");
			}
			try
			{
				gyroscope = new SmoothGyroscope(smoothness);
			} 
			catch (e:Error)
			{
				throw new Error("SensorDevice constructor: Something went wrong making the gyroscope!");
			}
			
			
			
			var dpi:Number = Capabilities.screenDPI;
			var scaleFactor:Number = Starling.contentScaleFactor;
			//var resX:Number = Capabilities.screenResolutionX;
			//var resY:Number = Capabilities.screenResolutionY;
			//var dpWide:Number = Starling.current.nativeStage.fullScreenWidth * 160 / dpi;
			var inchesToMeters:Number = 0.0254;
			var metersWide:Number = Starling.current.nativeStage.fullScreenWidth * scaleFactor * inchesToMeters / dpi;
			var metersHigh:Number = Starling.current.nativeStage.fullScreenHeight * scaleFactor * inchesToMeters / dpi;
			screenSize = new Vec2(metersWide, metersHigh);
		}
		
		/*! per-frame update
		 */
		public function updatePerFrame(dt:Number, targetAngle:Number = 0.0, targetPositionX:Number = 0.0, targetPositionY:Number = 0.0):void
		{
			accelerometer.updatePerFrame();
			gyroscope.updatePerFrame();
			
			ax = accelerometer.smoothX;
			ay = accelerometer.smoothY;
			az = accelerometer.smoothZ;
			
			
			gx = gyroscope.smoothX;
			gy = gyroscope.smoothY;
			gz = gyroscope.smoothZ;
			
			var rotZ:Number = Math.atan2(aX, aY);
			angle = (filterCoefficient * (angle + gz * dt)) + ((1.0 - filterCoefficient) * rotZ);
			
			var aLen:Number = Math.sqrt(ax * ax + ay * ay + az * az);
			
			var alpha:Number = 0.8;
			gravityX = (alpha * gravityX) + (1.0 - alpha) * ax;
			gravityY = (alpha * gravityY) + (1.0 - alpha) * ay;
		}
		
		/*! the current angle about the z axis
		 */
		public function get angle():Number
		{
			return this.angle;
		}
		/*! the physical height of the screen, in meters
		 */
		public function get heightInMeters():Number
		{
			return screenSize.y;
		}
		
		/*! the physical width of the screen, in meters
		 */
		public function get widthInMeters():Number
		{
			return screenSize.y;
		}
		
		/*! complementary filter coeffiction
		 */
		public function get filterCoefficient():Number
		{
			return this.filterCoefficient;
		}
		
		/*! complementary filter coeffiction
		 */
		public function set filterCoefficient(coeff:Number):void
		{
			if ((coeff > 0.0) && (coeff < 1.0))
			{
				this.filterCoefficient = coeff;
			}
		}
	}

}