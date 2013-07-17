package jlmath.alg 
{
	/**
	 * ...
	 * @author James
	 */
	public class Vec2 
	{
		/*! the values x, y
		 */
		protected var m:Vector.<Number>;
		
		/*! constructor
		 */
		public function Vec2(x:Number = 0.0, y:Number = 0.0)
		{
			m = new Vector.<Number>(2);
			m[0] = x;  m[1] = y;
		}
		
		/*! clone this vector, retun a copy
		 */
		public function clone():Vec2
		{
			return new Vec2(m[0], m[1]);
		}
		
		/*! calculates the square length
		 */
		public function lengthSquared():Number
		{
			return m[0] * m[0] + m[1] * m[1];
		}
		
		/*! calculates the length
		 */
		public function length():Number
		{
			return Math.sqrt(m[0] * m[0] + m[1] * m[1]);
		}
		
		/*! multiplies this vector by the number
		 */
		public function multiply(n:Number):void
		{
			m[0] *= n;  m[1] *= n;
		}
		
		/*! multiplies this vector (component-wise) by vector v
		 */
		public function multiplyV(v:Vec2):void
		{
			m[0] *= v.m[0];  m[1] *= v.m[1];
		}
		
		/*! adds n to each component
		 */
		public function add(n:Number):void
		{
			m[0] += n;  m[1] += n;
		}
		
		/*! adds vector v to this vector
		 */
		public function addV(v:Vec2):void
		{
			m[0] += v.m[0];  m[1] += v.m[1];
		}
		
		/*! adds n to each component
		 */
		public function subtract(n:Number):void
		{
			m[0] -= n;  m[1] -= n;
		}
		
		/*! adds vector v to this vector
		 */
		public function subtractV(v:Vec2):void
		{
			m[0] -= v.m[0];  m[1] -= v.m[1];
		}
		
		/*! returns the dot product of this vector and v
		 */
		public function dot(v:Vec2):Number
		{
			return (m[0] * v.m[0] + m[1] * v.m[1]);
		}
		
		/*! returns the cross product of this vector and v
		 */
		public function cross(v:Vec2):Number
		{
			return m[0] * v.m[1] - m[1] * v.m[0];
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
		
		/*! sets the x, y values
		 */
		public function set(xValue:Number, yValue:Number):void
		{
			m[0] = xValue;  m[1] = yValue;
		}
		
		/*! copies contents of v
		 */
		public function setV(v:Vec2):void
		{
			m[0] = v.m[0];  m[1] = v.m[1];
		}
	}

}