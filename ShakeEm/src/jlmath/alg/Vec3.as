package jlmath.alg 
{
	/**
	 * ...
	 * @author James
	 */
	public class Vec3 
	{
		/*! the values x, y, z
		 */
		protected var m:Vector.<Number>;
		
		/*! constructor
		 */
		public function Vec3(x:Number = 0.0, y:Number = 0.0, z:Number = 0.0)
		{
			m = new Vector.<Number>(3);
			m[0] = x;  m[1] = y;  m[2] = z;
		}
		
		/*! clone this vector, retun a copy
		 */
		public function clone():Vec3
		{
			return new Vec3(m[0], m[1], m[2]);
		}
		
		
		/*! calculates the square length
		 */
		public function lengthSquared():Number
		{
			return m[0] * m[0] + m[1] * m[1] + m[2] * m[2];
		}
		
		/*! calculates the length
		 */
		public function length():Number
		{
			return Math.sqrt(m[0] * m[0] + m[1] * m[1] + m[2] * m[2]);
		}
		
		/*! multiplies this vector by the number
		 */
		public function multiply(n:Number):void
		{
			m[0] *= n;  m[1] *= n;  m[2] *= n;
		}
		
		/*! multiplies this vector (component-wise) by vector v
		 */
		public function multiplyV(v:Vec3):void
		{
			m[0] *= v.m[0];  m[1] *= v.m[1];  m[2] *= v.m[2];
		}
		
		/*! adds n to each component
		 */
		public function add(n:Number):void
		{
			m[0] += n;  m[1] += n;  m[2] += n;
		}
		
		/*! adds vector v to this vector
		 */
		public function addV(v:Vec3):void
		{
			m[0] += v.m[0];  m[1] += v.m[1];  m[2] += v.m[2];
		}
		
		/*! adds n to each component
		 */
		public function subtract(n:Number):void
		{
			m[0] -= n;  m[1] -= n;  m[2] -= n;
		}
		
		/*! adds vector v to this vector
		 */
		public function subtractV(v:Vec3):void
		{
			m[0] -= v.m[0];  m[1] -= v.m[1];  m[2] -= v.m[2];
		}
		
		/*! returns the dot product of this vector and v
		 */
		public function dot(v:Vec3):Number
		{
			return (m[0] * v.m[0] + m[1] * v.m[1] + m[2] * v.m[2]);
		}
		
		/*! returns the cross product of this vector and v
		 */
		public function cross(v:Vec3):Vec3
		{
			return new Vec3(m[1] * v.m[2] - m[2] * v.m[1], m[2] * v.m[0] - m[0] * v.m[2], m[0] * v.m[1] - m[1] * v.m[0]);
		}
		
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
		
		/*! sets the x, y, z values
		 */
		public function set(xValue:Number, yValue:Number, zValue:Number):void
		{
			m[0] = xValue;  m[1] = yValue;  m[2] = zValue;
		}
		
		/*! copies contents of v
		 */
		public function setV(v:Vec3):void
		{
			m[0] = v.m[0];  m[1] = v.m[1];  m[2] = v.m[2];
		}
	}

}