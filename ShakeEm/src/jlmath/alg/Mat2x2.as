package jlmath.alg 
{
	/**
	 * ...
	 * @author James
	 */
	public class Mat2x2 
	{
		/*! the entries in the matrix
		 * 
		 * no direct access
		 * but lots of implicit and explicit getters and setters
		 * 
		 * m00 m01
		 * m10 m11
		 * 
		 * or
		 * 
		 * a b
		 * c d
		 */
		protected var m:Vector.<Number>;
		
		/*! constructor
		 */
		public function Mat2x2(a00:Number, a01:Number, a10:Number, a11:Number)
		{
			m = new Vector.<Number>(4);
			m[0] = a00;  m[1] = a01;  m[2] = a10;  m[3] = a11;
		}
		/*! clone this matrix, retun a copy
		 */
		public function clone():Mat2x2
		{
			return new Mat2x2(m[0], m[1], m[2], m[3]);
		}
		
		
		/////////////////// EXPLICIT GETTERS & SETTERS  //////////////////////
		
		//////// EXPLICIT GETTERS /////////
		
		/*! get the first row
		 */
		public function GetRow0():Vec2
		{
			return new Vec2(m[0], m[1]);
		}
		
		/*! get the second row
		 */
		public function GetRow1():Vec2
		{
			return new Vec2(m[2], m[3]);
		}
		
		/*! get the first column
		 */
		public function GetCol0():Vec2
		{
			return new Vec2(m[0], m[2]);
		}
		
		/*! get the second column
		 */
		public function GetCol1():Vec2
		{
			return new Vec2(m[1], m[3]);
		}
		
		
		//////// EXPLICIT SETTERS /////////
		
		/*! set the first row
		 */
		public function SetRow0(x:Number, y:Number):void
		{
			m[0] = x;  m[1] = y;
		}
		
		/*! set the second row
		 */
		public function SetRow1(x:Number, y:Number):void
		{
			m[2] = x;  m[3] = y;
		}
		
		/*! set the first row
		 */
		public function SetRow0V(v:Vec2):void
		{
			m[0] = v.x;  m[1] = v.y;
		}
		
		/*! set the second row
		 */
		public function SetRow1V(v:Vec2):void
		{
			m[2] = v.x;  m[3] = v.y;
		}
		
		/*! set the first column
		 */
		public function SetCol0(x:Number, y:Number):void
		{
			m[0] = x;  m[2] = y;
		}
		
		/*! set the second column
		 */
		public function SetCol1(x:Number, y:Number):void
		{
			m[1] = x;  m[3] = y;
		}
		
		/*! set the first column
		 */
		public function SetCol0V(v:Vec2):void
		{
			m[0] = v.x;  m[2] = v.y;
		}
		
		/*! set the second column
		 */
		public function SetCol1V(v:Vec2):void
		{
			m[1] = v.x;  m[3] = v.y;
		}
		
		
		/////////////////// IMPLICIT GETTERS & SETTERS  //////////////////////
		
		//////// IMPLICIT GETTERS /////////
		
		/*! getter function for the entry in the first row, first column
		 */
		public function get m00():Number
		{
			return this.m[0];
		}
		
		/*! getter function for the entry in the first row, second column
		 */
		public function get m01():Number
		{
			return this.m[1];
		}
		
		/*! getter function for the entry in the second row, first column
		 */
		public function get m10():Number
		{
			return this.m[2];
		}
		
		/*! getter function for the entry in the second row, second column
		 */
		public function get m11():Number
		{
			return this.m[3];
		}
		
		/*! getter function for the entry in the first row, first column
		 */
		public function get a():Number
		{
			return this.m[0];
		}
		
		/*! getter function for the entry in the first row, second column
		 */
		public function get b():Number
		{
			return this.m[1];
		}
		
		/*! getter function for the entry in the second row, first column
		 */
		public function get c():Number
		{
			return this.m[2];
		}
		
		/*! getter function for the entry in the second row, second column
		 */
		public function get d():Number
		{
			return this.m[3];
		}
		
		
		
		//////// IMPLICIT SETTERS /////////
		
		/*! setter function for the entry in the first row, first column
		 */
		public function set m00(value:Number):void
		{
			this.m[0] = value;
		}
		
		/*! setter function for the entry in the first row, second column
		 */
		public function set m01(value:Number):void
		{
			this.m[1] = value;
		}
		
		/*! setter function for the entry in the second row, first column
		 */
		public function set m10(value:Number):void
		{
			this.m[2] = value;
		}
		
		/*! setter function for the entry in the second row, second column
		 */
		public function set m11(value:Number):void
		{
			this.m[3] = value;
		}
		
		/*! setter function for the entry in the first row, first column
		 */
		public function set a(value:Number):void
		{
			this.m[0] = value;
		}
		
		/*! setter function for the entry in the first row, second column
		 */
		public function set b(value:Number):void
		{
			this.m[1] = value;
		}
		
		/*! setter function for the entry in the second row, first column
		 */
		public function set c(value:Number):void
		{
			this.m[2] = value;
		}
		
		/*! setter function for the entry in the second row, second column
		 */
		public function set d(value:Number):void
		{
			this.m[3] = value;
		}
	}

}