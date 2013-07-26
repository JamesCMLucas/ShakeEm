package linalg 
{
	/**
	 * ...
	 * @author James
	 */
	public class Matrix2x2 
	{
		/*! first row, first column*/
		public var m11:Number;
		/*! second row, first column */
		public var m21:Number;
		
		/*! first row, second column */
		public var m12:Number;
		/*! second row, second column */
		public var m22:Number;
		
		/*! constructor */
		public function Matrix2x2(
		a11:Number = 1.0, a12:Number = 0.0,
		a21:Number = 0.0, a22:Number = 1.0) 
		{
			m11 = a11;  m12 = a12;
			m21 = a21;  m22 = a22;
		}
		
		/*! clone this matrix, retun a copy
		 */
		public function clone():Matrix2x2
		{
			return new Matrix2x2(m11, m12, m21, m22);
		}
		
		//////// GETTERS /////////
		
		/*! get the first row */
		public function GetRow1():Vector2
		{
			return new Vector2(m11, m12);
		}
		
		/*! get the second row */
		public function GetRow2():Vector2
		{
			return new Vector2(m21, m22);
		}
		
		/*! get the first column */
		public function GetCol1():Vector2
		{
			return new Vector2(m11, m21);
		}
		
		/*! get the second column */
		public function GetCol2():Vector2
		{
			return new Vector2(m12, m22);
		}
		
		//////// SETTERS /////////
		
		/*! set the first row */
		public function SetRow1(x:Number, y:Number):void
		{
			m11 = x; m12 = y
		}
		
		/*! set the first row */
		public function SetRow1V(v:Vector2):void
		{
			m11 = v.x; m12 = v.y;
		}
		
		/*! set the second row */
		public function SetRow2(x:Number, y:Number):void
		{
			m21 = x; m22 = y;
		}
		
		/*! set the second row */
		public function SetRow2V(v:Vector2):void
		{
			m21 = v.x; m22 = v.y;
		}
		
		/*! set the first column */
		public function SetCol1(x:Number, y:Number):void
		{
			m11 = x; m21 = y;
		}
		
		/*! set the first column */
		public function SetCol1V(v:Vector2):void
		{
			m11 = v.x; m21 = v.y;
		}
		
		/*! set the second column */
		public function SetCol2(x:Number, y:Number):void
		{
			m12 = x; m22 = y;
		}
		
		/*! set the second column */
		public function SetCol2V(v:Vector2):void
		{
			m12 = v.x; m22 = v.y;
		}
		
		/*! transposes this matrix */
		public function transpose():void
		{
			var tmp:Number = m12;
			m12 = m21; m21 = tmp;
		}
		
		/*! retruns a new matrix, the transpose of this matrix */
		public function getTranspose():Matrix2x2
		{
			return new Matrix2x2(m11, m21, m12, m22);
		}
		
		/*! add a matrix to this one */
		public function addM(m:Matrix2x2):void
		{
			m11 += m.m11;  m12 += m.m12;
			m21 += m.m21;  m22 += m.m22;
		}
		
		/*! subract a matrix to this one */
		public function subractM(m:Matrix2x2):void
		{
			m11 -= m.m11;  m12 -= m.m12;
			m21 -= m.m21;  m22 -= m.m22;
		}
		
		/*! returns the determinant of this matrix */
		public function determinant():Number
		{
			return m11 * m22 - m12 * m21;
		}
		
		/*! returns a new matrix, the inverse of this one */
		public function getInverse():Matrix2x2
		{
			var detInv:Number = m11 * m22 - m12 * m21;
			if (detInv != 0.0)
			{
				detInv = 1.0 / detInv;
			}
			return new Matrix2x2(detInv * m22, -detInv * m12, -detInv * m21, detInv * m11);
		}
		
		/*! inverts this matrix */
		public function invert():void
		{
			var detInv:Number = m11 * m22 - m12 * m21;
			if (detInv != 0.0)
			{
				detInv = 1.0 / detInv;
			}
			var a:Number = m11;
			var b:Number = m12;
			var c:Number = m21;
			var d:Number = m22;
			m11 = detInv * d;
			m12 = -detInv * b;
			m21 = -detInv * c;
			m22 = detInv * a;
		}
		
		/*! returns the solution of M*x = b */
		public function solve(b:Vector2):Vector2
		{
			var detInv:Number = determinant();
			if (detInv != 0.0)
			{
				detInv = 1.0 / detInv;
			}
			return new Vector2(detInv * (m22 * b.x - m12 * b.y), detInv * (m11 * b.y - m21 * b.x));
		}
		
		/*! returns a new matrix of zeros */
		public static function spawnZeros():Matrix2x2
		{
			return new Matrix2x2(0.0, 0.0, 0.0, 0.0);
		}
		
		/*! returns a new matrix of ones */
		public static function spawnOnes():Matrix2x2
		{
			return new Matrix2x2(1.0, 1.0, 1.0, 1.0);
		}
		
		/*! returns a new matrix filled with number n */
		public static function spawnFilledWith(n:Number):Matrix2x2
		{
			return new Matrix2x2(n, n, n, n);
		}
		
		/*! returns a new matrix with given rows */
		public static function spawnRows(r1:Vector2, r2:Vector2):Matrix2x2
		{
			return new Matrix2x2(r1.x, r1.y, r2.x, r2.y);
		}
		
		/*! returns a new matrix with given rows */
		public static function spawnColumns(c1:Vector2, c2:Vector2):Matrix2x2
		{
			return new Matrix2x2(c1.x, c2.x, c1.y, c2.y);
		}
		
		/*! returns a new rotation matrix */
		public static function spawnRotation(theta:Number):Matrix2x2
		{
			var sinTheta:Number = Math.sin(theta);
			var cosTheta:Number = Math.cos(theta);
			return new Matrix2x2(cosTheta, -sinTheta, sinTheta, cosTheta);
		}
	}

}