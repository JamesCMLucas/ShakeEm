package ShakeEmLib 
{
	import Box2D.Dynamics.b2World;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author James
	 */
	public class cArena extends Sprite
	{
		/*!The box2d world
		 */
		private var mWorld:b2World;
		/*!The pixels per meters ratio
		 */
		private var mPixelsPerMeter:Number = 50.0;
		/*!The meters per pixels ratio
		 */
		private var mMetersPerPixel:Number = 1.0 / mPixelsPerMeter;
		
		/*The shapes are stored here
		 */
		private var mShapes:Vector.<cShape>;
		
		/*!Constructor
		 */
		public function cArena() 
		{
			mShapes = new Vector.<cShape>();
		}
		
		public function AddShape(shape:cShape):void
		{
			mShapes.push(shape);
		}
		
		/*!Gets the number of pixels that represent each meter in box2d world
		 */
		public function GetPixelsPerMeter():Number 
		{
			return mPixelsPerMeter;
		}
		
		/*!Sets the number of pixels that represent each meter in box2d world
		 */
		public function SetPixelsPerMeter(value:Number):void 
		{
			mPixelsPerMeter = value;
			mMetersPerPixel = 1.0 / mPixelsPerMeter;
		}
		
		/*!Gets the number of meters in box2d world that are covered per pixel
		 */
		public function GetMetersPerPixel():Number 
		{
			return mMetersPerPixel;
		}
		
		/*!Sets the number of meters in box2d world that are covered per pixel
		 */
		public function SetMetersPerPixel(value:Number):void 
		{
			mMetersPerPixel = value;
			mPixelsPerMeter = 1.0 / mMetersPerPixel;
		}
		
	}

}