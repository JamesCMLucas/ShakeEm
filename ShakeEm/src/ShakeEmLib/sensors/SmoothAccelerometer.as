package ShakeEmLib.sensors 
{
	/**
	 * ...
	 * @author James
	 */
	
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	 
	public class SmoothAccelerometer extends SmoothSensor
	{
		/*! The accelerometer
		 */
		private var mAccelerometer:Accelerometer;
		
		/*! Constructor
		 */
		public function SmoothAccelerometer(smoothingWindowSize:uint = 3) 
		{
			super(smoothingWindowSize);
			super.setNoUpdateAction(SmoothSensor.REPEAT_PREVIOUS_UPDATE);
			
			mAccelerometer = new Accelerometer();
			mAccelerometer.setRequestedUpdateInterval(0);
			mAccelerometer.addEventListener(AccelerometerEvent.UPDATE, updateInternal);
		}
		
		/*! The update event function
		 */
		private function updateInternal(e:AccelerometerEvent):void
		{
			super.setCurrentValues(e.accelerationX, e.accelerationY, e.accelerationZ);
		}
		
		/*! Changes the update interval for the accelerometer
		 */
		public function setRequestedUpdatedInterval(interval:Number):void
		{
			mAccelerometer.setRequestedUpdateInterval(interval);
		}
	}

}