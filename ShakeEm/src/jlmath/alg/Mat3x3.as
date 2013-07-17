package jlmath.alg 
{
	/**
	 * ...
	 * @author James
	 */
	public class Mat3x3 
	{
		/*! the entries in the matrix
		 * 
		 * no direct access
		 * but lots of implicit and explicit getters and setters
		 * 
		 * m00 m01 m02
		 * m10 m11 m12
		 * m20 m21 m22
		 * 
		 * or
		 * 
		 * a b c
		 * d e f
		 * g h i
		 */
		protected var m:Vector.<Number>;
		
		/*! constructor
		 */
		public function Mat3x3(
		a00:Number = 1.0, a01:Number = 0.0, a02:Number = 0.0,
		a10:Number = 0.0, a11:Number = 1.0, a12:Number = 0.0,
		a20:Number = 0.0, a21:Number = 0.0, a22:Number = 1.0)
		{
			m = new Vector.<Number>(4);
			m[0] = a00;  m[1] = a01;  m[2] = a02;
			m[3] = a10;  m[4] = a11;  m[5] = a12;
			m[6] = a20;  m[7] = a21;  m[8] = a22;
		}
		
		/*! clone this matrix, retun a copy
		 */
		public function clone():Mat3x3
		{
			return new Mat3x3(m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8]);
		}
		
		/////////////////// EXPLICIT GETTERS & SETTERS  //////////////////////
		
		//////// EXPLICIT GETTERS /////////
		
		/*! get the first row
		 */
		public function GetRow0():Vec3
		{
			return new Vec3(m[0], m[1], m[2]);
		}
		
		/*! get the second row
		 */
		public function GetRow1():Vec3
		{
			return new Vec3(m[3], m[4], m[5]);
		}
		
		/*! get the third row
		 */
		public function GetRow2():Vec3
		{
			return new Vec3(m[6], m[7], m[8]);
		}
		
		/*! get the first column
		 */
		public function GetCol0():Vec3
		{
			return new Vec3(m[0], m[3], m[6]);
		}
		
		/*! get the second column
		 */
		public function GetCol1():Vec3
		{
			return new Vec3(m[1], m[4], m[7]);
		}
		
		/*! get the third column
		 */
		public function GetCol2():Vec3
		{
			return new Vec3(m[2], m[5], m[8]);
		}
		
		//////// EXPLICIT SETTERS /////////
		
		/*! set the first row
		 */
		public function SetRow0(x:Number, y:Number, z:Number):void
		{
			m[0] = x; m[1] = y; m[2] = z;
		}
		
		/*! set the second row
		 */
		public function SetRow1(x:Number, y:Number, z:Number):void
		{
			m[3] = x; m[4] = y; m[5] = z;
		}
		
		/*! set the third row
		 */
		public function SetRow2(x:Number, y:Number, z:Number):void
		{
			m[6] = x; m[7] = y; m[8] = z;
		}
		
		/*! set the first row
		 */
		public function SetRow0V(v:Vec3):void
		{
			m[0] = v.x; m[1] = v.y; m[2] = v.z;
		}
		
		/*! set the second row
		 */
		public function SetRow1V(v:Vec3):void
		{
			m[3] = v.x; m[4] = v.y; m[5] = v.z;
		}
		
		/*! set the third row
		 */
		public function SetRow2V(v:Vec3):void
		{
			m[6] = v.x; m[7] = v.y; m[8] = v.z;
		}
		
		/*! set the first column
		 */
		public function SetCol0(x:Number, y:Number, z:Number):void
		{
			m[0] = x; m[3] = y; m[6] = z;
		}
		
		/*! set the second column
		 */
		public function SetCol1(x:Number, y:Number, z:Number):void
		{
			m[1] = x; m[4] = y; m[7] = z;
		}
		
		/*! set the third column
		 */
		public function SetCol2(x:Number, y:Number, z:Number):void
		{
			m[2] = x; m[5] = y; m[8] = z;
		}
		
		/*! set the first column
		 */
		public function SetCol0V(v:Vec3):void
		{
			m[0] = v.x; m[3] = v.y; m[6] = v.z;
		}
		
		/*! set the second column
		 */
		public function SetCol1V(v:Vec3):void
		{
			m[1] = v.x; m[4] = v.y; m[7] = v.z;
		}
		
		/*! set the third column
		 */
		public function SetCol2V(v:Vec3):void
		{
			m[2] = v.x; m[5] = v.y; m[8] = v.z;
		}
		
		/*! transposes this matrix
		 */
		public function transpose():void
		{
			var tmp:Number = m[1];
			m[1] = m[3]; m[3] = tmp;
			tmp = m[2];
			m[2] = m[6]; m[6] = tmp;
			tmp = m[5];
			m[5] = m[7]; m[7] = tmp;
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
		
		/*! getter function for the entry in the first row, third column
		 */
		public function get m02():Number
		{
			return this.m[2];
		}
		
		/*! getter function for the entry in the second row, first column
		 */
		public function get m10():Number
		{
			return this.m[3];
		}
		
		/*! getter function for the entry in the second row, second column
		 */
		public function get m11():Number
		{
			return this.m[4];
		}
		
		/*! getter function for the entry in the second row, third column
		 */
		public function get m12():Number
		{
			return this.m[5];
		}
		
		/*! getter function for the entry in the third row, first column
		 */
		public function get m20():Number
		{
			return this.m[6];
		}
		
		/*! getter function for the entry in the third row, second column
		 */
		public function get m21():Number
		{
			return this.m[7];
		}
		
		/*! getter function for the entry in the third row, third column
		 */
		public function get m22():Number
		{
			return this.m[8];
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
		
		/*! getter function for the entry in the first row, third column
		 */
		public function get c():Number
		{
			return this.m[2];
		}
		
		/*! getter function for the entry in the second row, first column
		 */
		public function get d():Number
		{
			return this.m[3];
		}
		
		/*! getter function for the entry in the second row, second column
		 */
		public function get e():Number
		{
			return this.m[4];
		}
		
		/*! getter function for the entry in the second row, third column
		 */
		public function get f():Number
		{
			return this.m[5];
		}
		
		/*! getter function for the entry in the third row, first column
		 */
		public function get g():Number
		{
			return this.m[6];
		}
		
		/*! getter function for the entry in the third row, second column
		 */
		public function get h():Number
		{
			return this.m[7];
		}
		
		/*! getter function for the entry in the third row, third column
		 */
		public function get i():Number
		{
			return this.m[8];
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
		
		/*! setter function for the entry in the first row, third column
		 */
		public function set m02(value:Number):void
		{
			this.m[2] = value;
		}
		
		/*! setter function for the entry in the second row, first column
		 */
		public function set m10(value:Number):void
		{
			this.m[3] = value;
		}
		
		/*! setter function for the entry in the second row, first column
		 */
		public function set m11(value:Number):void
		{
			this.m[4] = value;
		}
		
		/*! setter function for the entry in the second row, third column
		 */
		public function set m12(value:Number):void
		{
			this.m[5] = value;
		}
		
		/*! setter function for the entry in the third row, first column
		 */
		public function set m20(value:Number):void
		{
			this.m[6] = value;
		}
		
		/*! setter function for the entry in the third row, second column
		 */
		public function set m21(value:Number):void
		{
			this.m[7] = value;
		}
		
		/*! setter function for the entry in the third row, third column
		 */
		public function set m22(value:Number):void
		{
			this.m[8] = value;
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
		
		/*! setter function for the entry in the first row, third column
		 */
		public function set c(value:Number):void
		{
			this.m[2] = value;
		}
		
		/*! setter function for the entry in the second row, first column
		 */
		public function set d(value:Number):void
		{
			this.m[3] = value;
		}
		
		/*! setter function for the entry in the second row, first column
		 */
		public function set e(value:Number):void
		{
			this.m[4] = value;
		}
		
		/*! setter function for the entry in the second row, third column
		 */
		public function set f(value:Number):void
		{
			this.m[5] = value;
		}
		
		/*! setter function for the entry in the third row, first column
		 */
		public function set g(value:Number):void
		{
			this.m[6] = value;
		}
		
		/*! setter function for the entry in the third row, second column
		 */
		public function set h(value:Number):void
		{
			this.m[7] = value;
		}
		
		/*! setter function for the entry in the third row, third column
		 */
		public function set i(value:Number):void
		{
			this.m[8] = value;
		}
	}

}