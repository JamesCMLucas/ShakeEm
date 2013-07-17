package ShakeEmLib 
{
	import com.adobe.nativeExtensions.Gyroscope;
	import com.adobe.nativeExtensions.GyroscopeEvent;
	import de.patrickkulling.air.mobile.extensions.magnetometer.event.MagnetometerEvent;
	import de.patrickkulling.air.mobile.extensions.magnetometer.Magnetometer;
	import flash.events.EventDispatcher;
	import flash.events.GeolocationEvent;
	import jlmath.alg.Mat3x3;
	import jlmath.alg.Quaternion;
	import jlmath.alg.Vec3;
	import jlmath.alg.Ops;
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	import flash.sensors.Geolocation;
	/**
	 * ...
	 * @author James
	 */
	public class cInertialNavigator extends EventDispatcher
	{
		public var gyro:Vec3;
		public var gyroMatrix:Mat3x3;
		public var gyroOrientation:Vec3;
		public var magnet:Vec3;
		public var accel:Vec3;
		public var accMagOrientation:Vec3;
		public var fusedOrientation:Vec3;
		public var rotationMatrix:Mat3x3;
		
		public static var EPSILON:Number = 0.000000001;
		public static var NS2S:Number = 1.0 / 1000000000.0;
		public var initState:Boolean;
		private var timeStamp:Number = 0.0;
		
		
		public static var TIME_CONSTANT:Number = 30;
		public static var FILTER_COEFFICIENT:Number = 0.98;
		
		
		/*! The magnetometer
		 */
		private var mMagnetometer:Magnetometer;
		
		/*! The accelerometer
		 */
		private var mAccelerometer:Accelerometer;
		
		/*! The gyroscope
		 */
		private var mGyroscope:Gyroscope;
		
		/*! Constructor
		 */
		public function cInertialNavigator() 
		{
			gyro = new Vec3();
			gyroMatrix = new Mat3x3(1, 0, 0, 0, 1, 0, 0, 0, 1);
			gyroOrientation = new Vec3();
			magnet = new Vec3();
			accel = new Vec3();
			accMagOrientation = null;// new Vec3();
			fusedOrientation = new Vec3();
			rotationMatrix = new Mat3x3(1, 0, 0, 0, 1, 0, 0, 0, 1);
			
			initState = true;
			timeStamp = 0.0;
			
			// create the magnetometer
			mMagnetometer = new Magnetometer();
			mMagnetometer.setRequestedUpdateInterval(0);
			mMagnetometer.addEventListener(MagnetometerEvent.UPDATE, UpdateMagnetometer);
			
			// create the accelerometer
			mAccelerometer = new Accelerometer();
			mAccelerometer.setRequestedUpdateInterval(0);
			mAccelerometer.addEventListener(AccelerometerEvent.UPDATE, UpdateAccelerometer);
			
			// create the gyroscope
			mGyroscope = new Gyroscope();
			mGyroscope.setRequestedUpdateInterval(0);
			mGyroscope.addEventListener(GyroscopeEvent.UPDATE, UpdateGyroscope);
			
		}
		
		/*!
		 */
		private function CalculateRotationVectorFromGyroVector( gyroValues:cVector3, deltaRotationVector:cVector3, timeFactor:Number ):cVector3
		{
			var normValues:cVector3 = new cVector3();
			var omegaMagnitude:Number = gyroValues.Length();
			if ( omegaMagnitude > EPSILON )
			{
				normValues.x = gyroValues.x / omegaMagnitude;
				normValues.y = gyroValues.y / omegaMagnitude;
				normValues.z = gyroValues.z / omegaMagnitude;
			}
			
			var thetaOverTwo = omegaMagnitude * timeFactor;
			var sinThetaOverTwo = Math.sin(thetaOverTwo);
			var cosThetaOverTwo = Math.cos(thetaOverTwo);
			
		}
		
		private function SetRotationMatrixFromOrientation(m_out:Mat3x3, orientation:Vec3):void
		{
			
		}
		
		/*! Sets the update interval for the accelerometer and gyroscope
		 */
		public function SetUpdateInterval(interval:Number):void
		{
			mMagnetometer.setRequestedUpdateInterval(interval);
			mAccelerometer.setRequestedUpdateInterval(interval);
			mGyroscope.setRequestedUpdateInterval(interval);
		}
		 
		/*! The magnetometer update event function
		 */
		private function UpdateMagnetometer(e:MagnetometerEvent):void
		{
			magnet.set(e.x, e.y, e.z);
		}
		
		 /*! The accelerometer update event function
		 */
		private function UpdateAccelerometer(e:AccelerometerEvent):void
		{
			accel.Set(e.accelerationX, e.accelerationY, e.accelerationZ);
		}
		
		/*! The gyroscope update event function
		 */
		private function UpdateGyroscope(e:GyroscopeEvent):void
		{
			// don't start until first accelerometer/magnetometer orientation has been acquired
			if ( accMagOrientation == null )
			{
				return;
			}
			
			// initialisation of the gyroscope based rotation matrix
			if (initState)
			{
				var initMat:Mat3x3 = new Mat3x3();
				SetRotationMatrixFromOrientation(initMat, accMagOrientation);
				var tst:Vec3 = new Vec3();
				//SensorManager.getOrientation(initMat, tst);
				jlmath.alg.Ops.mulM3M3(gyroMatrix, gyroMatrix, initMat);
				
				initState = false;
			}
			
			// copy the new gyro values into the gyro array
			// convert the raw gyro data into a rotation vector
			var deltaQ:Quaternion = new Quaternion();
			if (timeStamp != 0)
			{
				//var final dT:Number = (e.timestamp - timestamp) * NS2S
				gyro.set(e.x, e.y, e.z);
				// setQuaternionFromGyro(deltaQ, gyro, dT / 2.0);
			}
			
			//timeStamp = e.timestamp;
			
			// convert rotation vector into rotation matrix
			var deltaMat:Mat3x3 = new Mat3x3();
			// setMat3FromQuaternion(deltaMat, deltaQ);
			
			// apply the new rotation interval on the gyroscope based rotation matrix
			Ops.mulM3M3(gyroMatrix, gyroMatrix, deltaMat);
			
			// get the gyroscope based orientation from the rotation matrix
			//SensorManager.getOrientation(gyroMatrix, gyroOrientation);
		}
	}

}