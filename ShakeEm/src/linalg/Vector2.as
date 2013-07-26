package linalg 
{
	/**
	 * ...
	 * @author James
	 */
	public class Vector2 
	{
		/*! x dimension */
		public var x:Number;
		/*! y dimension */
		public var y:Number;
		
		/*! constructor */
		public function Vector2(xValue:Number = 0.0, yValue:Number = 0.0) 
		{
			x = xValue; y = yValue;
		}
		
		/*! clone this vector, retun a copy */
		public function clone():Vector2
		{
			return new Vector2(x, y);
		}
		
		/*! calculates the square length */
		public function lengthSquared():Number
		{
			return x * x + y * y;
		}
		
		/*! calculates the length */
		public function length():Number
		{
			return Math.sqrt(x * x + y * y);
		}
		
		/*! normalize this vector */
		public function normalize():void
		{
			var len:Number = Math.sqrt(x * x + y * y);
			if (len != 0.0)
			{
				x /= len;  y /= len;
			}
		}
		
		/*! normalize this vector and return the length
		 *  if length turns out to be zero, vector will become (0,1,0)
		 */
		public function normalizeAndGetLength():Number
		{
			var len:Number = Math.sqrt(x * x + y * y);
			if (len != 0.0)
			{
				x /= len;  y /= len;
			}
			else
			{
				x = 0.0;  y = 1.0;
			}
			return len;
		}
		
		/*! multiplies this vector by the number */
		public function multiply(n:Number):void
		{
			x *= n;  y *= n;
		}
		
		/*! multiplies this vector (component-wise) by vector v */
		public function multiplyV(v:Vector2):void
		{
			x *= v.x;  y *= v.y;
		}
		
		/*! adds n to each component */
		public function add(n:Number):void
		{
			x += n;  y += n;
		}
		
		/*! adds vector v to this vector */
		public function addV(v:Vector2):void
		{
			x += v.x;  y += v.y;
		}
		
		/*! subtracts n to each component */
		public function subtract(n:Number):void
		{
			x -= n;  y -= n;
		}
		
		/*! subtracts vector v to this vector */
		public function subtractV(v:Vector2):void
		{
			x -= v.x;  y -= v.y;
		}
		
		/*! returns the dot product of this vector and v */
		public function dot(v:Vector2):Number
		{
			return (x * v.x + y * v.y);
		}
		
		/*! returns the z value of the cross product */
		public function cross(v:Vector2):Number
		{
			return x * v.y - y * v.x;
		}
		
		/*! sets the x, y values */
		public function set(xValue:Number, yValue:Number):void
		{
			x = xValue;  y = yValue;
		}
		
		/*! copies contents of v */
		public function setV(v:Vector2):void
		{
			x = v.x;  y = v.y;
		}
	}

}