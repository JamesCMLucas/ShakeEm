package ShakeEmLib.sensors 
{
	import de.patrickkulling.air.mobile.extensions.magnetometer.Magnetometer;
	import de.patrickkulling.air.mobile.extensions.magnetometer.event.*;
	
	/**
	 * ...
	 * @author James
	 */
	public class SmoothMagnetometer extends SmoothSensor
	{
		/*! The magnetometer
		 */
		private var mMagnetometer:Magnetometer;
		
		/*! Constructor
		 */
		public function SmoothMagnetometer(smoothingWindowSize:uint = 3) 
		{
			super(smoothingWindowSize);
			super.setNoUpdateAction(SmoothSensor.REPEAT_PREVIOUS_UPDATE);
			
			mMagnetometer = new Magnetometer();
			mMagnetometer.setRequestedUpdateInterval(0);
			mMagnetometer.addEventListener(MagnetometerEvent.UPDATE, updateInternal);
		}
		
		/*! The update event function
		 */
		private function updateInternal(e:MagnetometerEvent):void
		{
			super.setCurrentValues(e.x, e.y, e.z);
		}
		
		/*! Changes the update interval for the magnetometer
		 */
		public function setRequestedUpdatedInterval(interval:Number):void
		{
			mMagnetometer.setRequestedUpdateInterval(interval);
		}
	}

}