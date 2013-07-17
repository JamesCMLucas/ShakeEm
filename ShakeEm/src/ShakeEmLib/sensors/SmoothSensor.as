package ShakeEmLib.sensors 
{
	/**
	 * ...
	 * @author James
	 */
	public class SmoothSensor 
	{
		/*! If the sensor hasn't received an updated state since the previous frame, do nothing.
		 *  The current states will remain, and smooth value calculations will return the same values
		 */
		public static const DO_NOTHING:int = 0;
		/*! If the sensor hasn't received an updated state since the previous frame, use the previous update as the new values.
		 */
		public static const REPEAT_PREVIOUS_UPDATE:int = 1;
		/*! If the sensor hasn't received an updated state since the previous frame, use the devault values as the new values.
		 */
		public static const USE_DEFAULT_VALUES:int = 2;
		/*! Indicates the action to take when the sensor hasn't received an update since the previous frame update
		 *  Defaults to DO_NOTHING
		 */
		private var mNoUpdateAction:int = DO_NOTHING;
		
		/*! The default x reading
		 *  Defaults to 0.0
		 */
		private var mDefaultX:Number = 0.0;
		/*! The default y reading
		 *  Defaults to 0.0
		 */
		private var mDefaultY:Number = 0.0;
		/*! The default z reading
		 *  Defaults to 0.0
		 */
		private var mDefaultZ:Number = 0.0;
		
		/*! The values in the x axis
		 */
		protected var mX:Vector.<Number>;
		/*! The values in the y axis
		 */
		protected var mY:Vector.<Number>;
		/*! The values in the z axis
		 */
		protected var mZ:Vector.<Number>;
		
		/*! The size of the averaging window (vector sizes for x, y z smootherizers)
		 */
		protected var mW:uint;
		
		/*! Our current position in the window
		 */
		private var mCurrentWindowPosition:uint;
		/*! The previous position in the window
		 */
		private var mPreviousWindowPosition:uint;
		
		/*! Indicates that setCurrentValues has been called since the most recent call to updatPerFrame
		 *  Indicates that zero values should be used
		 */
		private var mbValuesHaveBeenUpdated:Boolean = false;
		
		/*! Constructor
		 */
		public function SmoothSensor(smoothingWindowSize:uint = 3) 
		{
			mbValuesHaveBeenUpdated = false;
			mCurrentWindowPosition = 0;
			mPreviousWindowPosition = 0;
			mW = smoothingWindowSize;
			mX = new Vector.<Number>(mW, 0.0);
			mY = new Vector.<Number>(mW, 0.0);
			mZ = new Vector.<Number>(mW, 0.0);
		}
		
		/*! Call this ONCE per frame before using this thing
		 */
		public function updatePerFrame():void
		{
			if (!mbValuesHaveBeenUpdated)
			{
				switch (mNoUpdateAction)
				{
					case DO_NOTHING:
					break;
				case REPEAT_PREVIOUS_UPDATE:
					{
						this.setCurrentValues(mX[mPreviousWindowPosition], mY[mPreviousWindowPosition], mZ[mPreviousWindowPosition]);
					}
					break;
				case USE_DEFAULT_VALUES:
					{
						this.setCurrentValues(mDefaultX, mDefaultY, mDefaultZ);
					}
					break;
				default:
					break;
				}
			}
			
			// step forward
			mPreviousWindowPosition = mCurrentWindowPosition;
			mCurrentWindowPosition = (mCurrentWindowPosition + 1) % mW;
			
			// reset
			mbValuesHaveBeenUpdated = false;
		}
		
		/*! Sets the current values
		 */
		protected function setCurrentValues(x:Number, y:Number, z:Number):void
		{
			mX[mCurrentWindowPosition] = x;
			mY[mCurrentWindowPosition] = y;
			mZ[mCurrentWindowPosition] = z;
			mbValuesHaveBeenUpdated = true;
		}
		
		/*! Sets the default values
		 */
		public function setDefaultValues(x:Number, y:Number, z:Number):void
		{
			mDefaultX = x;
			mDefaultY = y;
			mDefaultZ = z;
		}
		
		/*! Sets the action to take when no update has been made since the previous frame update
		 *  No changes made if action is invalid
		 */
		public function setNoUpdateAction(action:int):void
		{
			switch( action)
			{
				case DO_NOTHING:
					{
						mNoUpdateAction = action;
					}
					break;
				case REPEAT_PREVIOUS_UPDATE:
					{
						mNoUpdateAction = action;
					}
					break;
				case USE_DEFAULT_VALUES:
					{
						mNoUpdateAction = action;
					}
					break;
				default:
					break;
			}
		}
		
		/*! get the smooth (averaged) x acceleration value
		 */
		public function get smoothX():Number
		{
			// get the total
			var value:Number = 0.0;
			for (var i:uint = 0; i < mW; i++)
			{
				value += mX[i];
			}
			
			// return the average
			return value / mW;
		}
		
		/*! get the smooth (averaged) y acceleration value
		 */
		public function get smoothY():Number
		{
			// get the total
			var value:Number = 0.0;
			for (var i:uint = 0; i < mW; i++)
			{
				value += mY[i];
			}
			
			// return the average
			return value / mW;
		}
		
		/*! get the smooth (averaged) z acceleration value
		 */
		public function get smoothZ():Number
		{
			// get the total
			var value:Number = 0.0;
			for (var i:uint = 0; i < mW; i++)
			{
				value += mZ[i];
			}
			
			// return the average
			return value / mW;
		}
	}

}