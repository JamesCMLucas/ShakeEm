package jlmath.alg 
{
	/**
	 * ...
	 * @author James
	 */
	public class Quaternion 
	{
		public static var EPSILON:Number = 0.000000001;
		
		/*! the values x, y, z, w
		 */
		protected var m:Vector.<Number>;
		
		/*! constructor
		 *  defaults to identity (0,0,0,1)
		 */
		public function Quaternion(x:Number = 0.0, y:Number = 0.0, z:Number = 0.0, w:Number = 1.0)
		{
			m = new Vector.<Number>(4);
			m[0] = x;  m[1] = y;  m[2] = z;  m[3] = w;
		}
		
		/*! clone this quaternion, retun a copy
		 */
		public function clone():Quaternion
		{
			return new Quaternion(m[0], m[1], m[2], m[3]);
		}
		
		/*! get the angle of rotation
		 */
		public function getAngle():Number
		{
			return 2.0 * Math.acos(w);
		}
		
		/*! get the axis of rotation
		 */
		public function getAxis():Vec3
		{
			var om2:Number = 1.0 - ( m[3] * m[3] );
			if (om2 < EPSILON )
			{
				return new Vec3(0.0, 1.0, 0.0);
			}
			var omInv:Number = 1.0 / Math.sqrt(om2);
			return  new Vec3(m[0] * omInv, m[1] * omInv, m[2] * omInv);
		}
		
		/*! calculates the square length
		 */
		public function lengthSquared():Number
		{
			return m[0] * m[0] + m[1] * m[1] + m[2] * m[2] + m[3] * m[3];
		}
		
		/*! calculates the length
		 */
		public function length():Number
		{
			return Math.sqrt(m[0] * m[0] + m[1] * m[1] + m[2] * m[2] + m[3] * m[3]);
		}
		
		////////////////////////////////////////////////////////////
		///                                                      ///
		///                  GETTERS AND SETTERS                 ///
		///                                                      ///
		////////////////////////////////////////////////////////////
		
		/*! getter function for the x value
		 */
		public function get x():Number
		{
			return this.m[0];
		}
		
		/*! getter function for the y value
		 */
		public function get y():Number
		{
			return this.m[1];
		}
		
		/*! getter function for the z value
		 */
		public function get z():Number
		{
			return this.m[2];
		}
		
		/*! getter function for the w value
		 */
		public function get w():Number
		{
			return this.m[3];
		}
		
		/*! setter function for the x value
		 */
		public function set x(value:Number):void
		{
			this.m[0] = value;
		}
		
		/*! setter function for the y value
		 */
		public function set y(value:Number):void
		{
			this.m[1] = value;
		}
		
		/*! setter function for the z value
		 */
		public function set z(value:Number):void
		{
			this.m[2] = value;
		}
		
		/*! setter function for the w value
		 */
		public function set w(value:Number):void
		{
			this.m[3] = value;
		}
		
		/*! sets the x, y, z, w values
		 */
		public function set(xValue:Number, yValue:Number, zValue:Number, wValue:Number):void
		{
			m[0] = xValue;  m[1] = yValue;  m[2] = zValue;  m[3] = wValue;
		}
		
		/*! copies contents of q
		 */
		public function setQ(q:Quaternion):void
		{
			m[0] = q.m[0];  m[1] = q.m[1];  m[2] = q.m[2];  m[3] = q.m[3];
		}
	}

}