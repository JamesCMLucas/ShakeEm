package linalg 
{
	/**
	 * ...
	 * @author James
	 */
	public class Matrix3x3 
	{
		/*! first row, first column*/
		public var m11:Number;
		/*! second row, first column */
		public var m21:Number;
		/*! third row, first column */
		public var m31:Number;
		
		/*! first row, second column */
		public var m12:Number;
		/*! second row, second column */
		public var m22:Number;
		/*! third row, second column */
		public var m32:Number;
		
		/*! first row, third column */
		public var m13:Number;
		/*! second row, third column */
		public var m23:Number;
		/*! third row, third column */
		public var m33:Number;
		
		/*! constructor */
		public function Matrix3x3(
		a11:Number = 1.0, a12:Number = 0.0, a13:Number = 0.0,
		a21:Number = 0.0, a22:Number = 1.0, a23:Number = 0.0,
		a31:Number = 0.0, a32:Number = 0.0, a33:Number = 1.0) 
		{
			m11 = a11;  m12 = a12;  m13 = a13;
			m21 = a21;  m22 = a22;  m23 = a23;
			m31 = a31;  m32 = a32;  m33 = a33;
		}
		
		/*! clone this matrix, retun a copy
		 */
		public function clone():Matrix3x3
		{
			return new Matrix3x3(m11, m12, m13, m21, m22, m23, m31, m32, m33);
		}
		
		//////// GETTERS /////////
		
		/*! get the first row */
		public function GetRow1():Vector3
		{
			return new Vector3(m11, m12, m13);
		}
		
		/*! get the second row */
		public function GetRow2():Vector3
		{
			return new Vector3(m21, m22, m23);
		}
		
		/*! get the third row */
		public function GetRow3():Vector3
		{
			return new Vector3(m31, m32, m33);
		}
		
		/*! get the first column */
		public function GetCol1():Vector3
		{
			return new Vector3(m11, m21, m31);
		}
		
		/*! get the second column */
		public function GetCol2():Vector3
		{
			return new Vector3(m12, m22, m32);
		}
		
		/*! get the third column */
		public function GetCol3():Vector3
		{
			return new Vector3(m13, m23, m33);
		}
		
		//////// SETTERS /////////
		
		/*! set the first row */
		public function SetRow1(x:Number, y:Number, z:Number):void
		{
			m11 = x; m12 = y; m13 = z;
		}
		
		/*! set the first row */
		public function SetRow1V(v:Vector3):void
		{
			m11 = v.x; m12 = v.y; m13 = v.z;
		}
		
		/*! set the second row */
		public function SetRow2(x:Number, y:Number, z:Number):void
		{
			m21 = x; m22 = y; m23 = z;
		}
		
		/*! set the second row */
		public function SetRow2V(v:Vector3):void
		{
			m21 = v.x; m22 = v.y; m23 = v.z;
		}
		
		/*! set the third row */
		public function SetRow3(x:Number, y:Number, z:Number):void
		{
			m31 = x; m32 = y; m33 = z;
		}
		
		/*! set the third row */
		public function SetRow3V(v:Vector3):void
		{
			m31 = v.x; m32 = v.y; m33 = v.z;
		}
		
		/*! set the first column */
		public function SetCol1(x:Number, y:Number, z:Number):void
		{
			m11 = x; m21 = y; m31 = z;
		}
		
		/*! set the first column */
		public function SetCol1V(v:Vector3):void
		{
			m11 = v.x; m21 = v.y; m31 = v.z;
		}
		
		/*! set the second column */
		public function SetCol2(x:Number, y:Number, z:Number):void
		{
			m12 = x; m22 = y; m32 = z;
		}
		
		/*! set the second column */
		public function SetCol2V(v:Vector3):void
		{
			m12 = v.x; m22 = v.y; m32 = v.z;
		}
		
		/*! set the third column */
		public function SetCol3(x:Number, y:Number, z:Number):void
		{
			m13 = x; m23 = y; m33 = z;
		}
		
		/*! set the third column */
		public function SetCol3V(v:Vector3):void
		{
			m13 = v.x; m23 = v.y; m33 = v.z;
		}
		
		/*! transposes this matrix */
		public function transpose():void
		{
			var tmp:Number = m12;
			m12 = m21; m21 = tmp;
			tmp = m13;
			m13 = m31; m31 = tmp;
			tmp = m23;
			m23 = m32; m32 = tmp;
		}
		
		/*! retruns a new matrix, the transpose of this matrix */
		public function getTranspose():Matrix3x3
		{
			return new Matrix3x3(m11, m21, m31, m12, m22, m32, m13, m23, m33);
		}
		
		/*! add a matrix to this one */
		public function addM(m:Matrix3x3):void
		{
			m11 += m.m11;  m12 += m.m12;  m13 += m.m13;
			m21 += m.m21;  m22 += m.m22;  m23 += m.m23;
			m31 += m.m31;  m32 += m.m32;  m33 += m.m33;
		}
		
		/*! subract a matrix to this one */
		public function subractM(m:Matrix3x3):void
		{
			m11 -= m.m11;  m12 -= m.m12;  m13 -= m.m13;
			m21 -= m.m21;  m22 -= m.m22;  m23 -= m.m23;
			m31 -= m.m31;  m32 -= m.m32;  m33 -= m.m33;
		}
		
		/*! returns the trace of this matrix */
		public function trace():Number
		{
			return m11 + m22 + m33;
		}
		
		/*! returns the determinant of this matrix */
		public function determinant():Number
		{
			return m11 * (m22 * m33 - m23 * m32) - m12 * (m21 * m33 - m23 * m31) + m13 * (m21 * m32 - m22 * m31);
		}
		/*! returns the inverse of this matrix */
		public function getInverse():Matrix3x3
		{
			var detInv:Number = this.determinant();
			if (detInv == 0.0)
			{
				return Matrix3x3.spawnZeros();
			}
			
			detInv = 1.0 / detInv;
			
			return new Matrix3x3(
			detInv * (m22 * m33 - m23 * m32), detInv * (m13 * m32 - m12 * m33), detInv * (m12 * m23 - m13 * m22),
			detInv * (m23 * m31 - m21 * m33), detInv * (m11 * m33 - m13 * m31), detInv * (m13 * m21 - m11 * m23),
			detInv * (m21 * m32 - m22 * m31), detInv * (m12 * m31 - m11 * m32), detInv * ( m11 * m22 - m12 * m21));
		}
		
		/*! returns a new matrix of zeros */
		public static function spawnZeros():Matrix3x3
		{
			return new Matrix3x3(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		}
		
		/*! returns a new matrix of ones */
		public static function spawnOnes():Matrix3x3
		{
			return new Matrix3x3(1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);
		}
		
		/*! returns a new matrix with given rows */
		public static function spawnRows(r1:Vector3, r2:Vector3, r3:Vector3):Matrix3x3
		{
			return new Matrix3x3(r1.x, r1.y, r1.z, r2.x, r2.y, r2.z, r3.x, r3.y, r3.z);
		}
		
		/*! returns a new matrix with given rows */
		public static function spawnColumns(c1:Vector3, c2:Vector3, c3:Vector3):Matrix3x3
		{
			return new Matrix3x3(c1.x, c2.x, c3.x, c1.y, c2.y, c3.y, c1.z, c2.z, c3.z);
		}
		
		
		/*! returns a new matrix filled with number n */
		public static function spawnFilledWith(n:Number):Matrix3x3
		{
			return new Matrix3x3(n, n, n, n, n, n, n, n, n);
		}
		
		/*! returns a new matrix, rotation theta degrees about the x axis */
		public static function spawnRotationX(theta:Number):Matrix3x3
		{
			var sinTheta:Number = Math.sin(theta);
			var cosTheta:Number = Math.cos(theta);
			return new Matrix3x3(1.0, 0.0, 0.0, 0.0, cosTheta, -sinTheta, 0.0, sinTheta, cosTheta);
		}
		
		/*! returns a new matrix, rotation theta degrees about the y axis */
		public static function spawnRotationY(theta:Number):Matrix3x3
		{
			var sinTheta:Number = Math.sin(theta);
			var cosTheta:Number = Math.cos(theta);
			return new Matrix3x3(cosTheta, 0.0, sinTheta, 0.0, 1.0, 0.0, -sinTheta, 0.0, cosTheta);
		}
		
		/*! returns a new matrix, rotation theta degrees about the z axis */
		public static function spawnRotationZ(theta:Number):Matrix3x3
		{
			var sinTheta:Number = Math.sin(theta);
			var cosTheta:Number = Math.cos(theta);
			return new Matrix3x3(cosTheta, -sinTheta, 0.0, sinTheta, cosTheta, 0.0, 0.0, 0.0, 1.0);
		}
		
		/*! returns a new matrix, rotation about axis a by theta radians
		 *  Note: assumes axis a has been normalized
		 */
		public static function spawnRotationAxisAngle(a:Vector3, theta:Number):Matrix3x3
		{
			var ab:Number = a.x * a.y;
			var ac:Number = a.x * a.z;
			var bc:Number = a.y * a.z;
			var cR:Number = Math.cos(theta);
			var cR1:Number = 1.0 - cR;
			var sR:Number = Math.sin(theta);
			
			return new Matrix3x3(
			a.x * a.x * cR1 + cR, ab * cR1 - a.z * sR, ac * cR1 + a.y * sR,
			ab * cR1 + a.z * sR, a.y * a.y * cR1 + cR, bc * cR1 - a.x * sR,
			ac * cR1 - a.y * sR, bc * cR1 + a.x * sR, a.z * a.z * cR1 + cR);
		}
		
		/*! returns a new rotation matrix from quaternion q
		 *  Note: assumes quaternion q has been normalized
		 */
		public static function spawnRotationQuaternion(q:Quaternion):Matrix3x3
		{
			// this assumes q is normalized...
			var x2:Number = q.x + q.x;
			var y2:Number = q.y + q.y;
			var z2:Number = q.z + q.z;
			
			var xx2:Number = q.x * x2;
			var yy2:Number = q.y * y2;
			var zz2:Number = q.z * z2;
			
			var yz2:Number = q.y * z2;
			var wx2:Number = q.w * x2;
			
			var xy2:Number = q.x * y2;
			var wz2:Number = q.w * z2;
			
			var xz2:Number = q.x * z2;
			var wy2:Number = q.w * y2;

			return new Matrix3x3(
			1.0 - yy2 - zz2, xy2 - wz2, xz2 + wy2,
			xy2 + wz2, 1.0 - xx2 - zz2, yz2 - wx2,
			xz2 - wy2, yz2 + wx2, 1.0 - xx2 - yy2);
		}
	}

}