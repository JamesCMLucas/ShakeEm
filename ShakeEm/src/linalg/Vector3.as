package linalg 
{
	/**
	 * ...
	 * @author James
	 */
	public class Vector3 
	{
		/*! x dimension
		 */
		public var x:Number;
		/*! y dimension
		 */
		public var y:Number;
		/*! z dimension
		 */
		public var z:Number;
		
		/*! constructor
		 */
		public function Vector3(xValue:Number = 0.0, yValue:Number = 0.0, zValue:Number = 0.0) 
		{
			x = xValue; y = yValue; z = zValue;
		}
		
		/*! clone this vector, retun a copy
		 */
		public function clone():Vector3
		{
			return new Vector3(x, y, z);
		}
		
		/*! calculates the square length
		 */
		public function lengthSquared():Number
		{
			return x * x + y * y + z * z;
		}
		
		/*! calculates the length
		 */
		public function length():Number
		{
			return Math.sqrt(x * x + y * y + z * z);
		}
		
		/*! normalize this vector
		 */
		public function normalize():void
		{
			var len:Number = Math.sqrt(x * x + y * y + z * z);
			if (len != 0.0)
			{
				x /= len;  y /= len;  z /= len;
			}
		}
		
		/*! normalize this vector and return the length
		 *  if length turns out to be zero, vector will become (0,1,0)
		 */
		public function normalizeAndGetLength():Number
		{
			var len:Number = Math.sqrt(x * x + y * y + z * z);
			if (len != 0.0)
			{
				x /= len;  y /= len;  z /= len;
			}
			else
			{
				x = 0.0;  y = 1.0;  z = 0.0;
			}
			return len;
		}
		
		/*! multiplies this vector by the number
		 */
		public function multiply(n:Number):void
		{
			x *= n;  y *= n;  z *= n;
		}
		
		/*! multiplies this vector (component-wise) by vector v
		 */
		public function multiplyV(v:Vector3):void
		{
			x *= v.x;  y *= v.y;  z *= v.z;
		}
		
		/*! adds n to each component
		 */
		public function add(n:Number):void
		{
			x += n;  y += n;  z += n;
		}
		
		/*! adds vector v to this vector
		 */
		public function addV(v:Vector3):void
		{
			x += v.x;  y += v.y;  z += v.z;
		}
		
		/*! subtracts n to each component
		 */
		public function subtract(n:Number):void
		{
			x -= n;  y -= n;  z -= n;
		}
		
		/*! subtracts vector v to this vector
		 */
		public function subtractV(v:Vector3):void
		{
			x -= v.x;  y -= v.y;  z -= v.z;
		}
		
		/*! returns the dot product of this vector and v
		 */
		public function dot(v:Vector3):Number
		{
			return (x * v.x + y * v.y + z * v.z);
		}
		
		/*! returns the cross product of this vector and v
		 */
		public function cross(v:Vector3):Vector3
		{
			return new Vector3(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x);
		}
		
		/*! sets the x, y, z values
		 */
		public function set(xValue:Number, yValue:Number, zValue:Number):void
		{
			x = xValue;  y = yValue;  z = zValue;
		}
		
		/*! copies contents of v
		 */
		public function setV(v:Vector3):void
		{
			x = v.x;  y = v.y;  z = v.z;
		}
	}

}