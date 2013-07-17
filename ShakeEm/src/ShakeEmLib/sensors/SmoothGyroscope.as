package ShakeEmLib.sensors 
{
	import com.adobe.nativeExtensions.Gyroscope;
	import com.adobe.nativeExtensions.GyroscopeEvent;
	
	/**
	 * ...
	 * @author James
	 */
	public class SmoothGyroscope extends SmoothSensor
	{
		/*! The gyroscope
		 */
		private var mGyro:Gyroscope;
		
		/*! Constructor
		 */
		public function SmoothGyroscope(smoothingWindowSize:uint = 3)
		{
			super(smoothingWindowSize);
			super.setNoUpdateAction(SmoothSensor.USE_DEFAULT_VALUES);
			super.setDefaultValues(0.0, 0.0, 0.0);
			mGyro = new Gyroscope();
			mGyro.setRequestedUpdateInterval(0);
			mGyro.addEventListener(GyroscopeEvent.UPDATE, updateInternal);
		}
		
		/*! The update event function
		 */
		private function updateInternal(e:GyroscopeEvent):void
		{
			super.setCurrentValues(e.x, e.y, e.z);
		}
		
		/*! Changes the update interval for the accelerometer
		 */
		public function setRequestedUpdatedInterval(interval:Number):void
		{
			mGyro.setRequestedUpdateInterval(interval);
		}
	}

}