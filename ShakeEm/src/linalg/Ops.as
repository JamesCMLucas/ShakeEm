package linalg 
{
	/**
	 * ...
	 * @author James
	 */
	public class Ops 
	{
		/*! returns the vector  m*v */
		public static function MatrixMultiplyVector(m:Matrix3x3, v:Vector3):Vector3
		{
			return new Vector3(m.m11 * v.x + m.m12 * v.y + m.m13 * v.z, m.m21 * v.x + m.m22 * v.y + m.m23 * v.z, m.m31 * v.x + m.m32 * v.y + m.m33 * v.z);
		}
		
		/*! returns the vector  v*m */
		public static function VectorMultiplyMatrix(v:Vector3, m:Matrix3x3):Vector3
		{
			return new Vector3(m.m11 * v.x + m.m21 * v.y + m.m31 * v.z, m.m12 * v.x + m.m22 * v.y + m.m32 * v.z, m.m13 * v.x + m.m23 * v.y + m.m33 * v.z);
		}
		
		/*! returns the vector  transpose(m)*v */
		public static function TransposeMultiplyVector(m:Matrix3x3, v:Vector3):Vector3
		{
			return new Vector3(m.m11 * v.x + m.m21 * v.y + m.m31 * v.z, m.m12 * v.x + m.m22 * v.y + m.m32 * v.z, m.m13 * v.x + m.m23 * v.y + m.m33 * v.z);
		}
		
		/*! returns the vector  v*transpose(m) */
		public static function VectorMultiplyTranspose(v:Vector3, m:Matrix3x3):Vector3
		{
			return new Vector3(m.m11 * v.x + m.m12 * v.y + m.m13 * v.z, m.m21 * v.x + m.m22 * v.y + m.m23 * v.z, m.m31 * v.x + m.m32 * v.y + m.m33 * v.z);
		}
		
		////////////////////// ADDITION //////////////////////
		
		/*! returns the vector  v1 + v2 */
		public static function V2addV2(v1:Vector2,v2:Vector2):Vector2
		{
			return new Vector2(v1.x + v2.x, v1.y + v2.y);
		}
		
		/*! returns the vector  v1 + v2 */
		public static function V3addV3(v1:Vector3,v2:Vector3):Vector3
		{
			return new Vector3(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
		}
		
		/*! returns the quaternion  q1 + q2 */
		public static function QaddQ(q1:Quaternion,q2:Quaternion):Quaternion
		{
			return new Quaternion(q1.x + q2.x, q1.y + q2.y, q1.z + q2.z, q1.w + q2.w);
		}
		
		/*! returns the matrix m1 + m2 */
		public static function M2addM2(m1:Matrix2x2,m2:Matrix2x2):Matrix2x2
		{
			return new Matrix2x2(
			m1.m11 + m2.m11, m1.m12 + m2.m12,
			m1.m21 + m2.m21, m1.m22 + m2.m22 );
		}
		
		/*! returns the matrix m1 + m2 */
		public static function M3addM3(m1:Matrix3x3,m2:Matrix3x3):Matrix3x3
		{
			return new Matrix3x3(
			m1.m11 + m2.m11, m1.m12 + m2.m12, m1.m13 + m2.m13,
			m1.m21 + m2.m21, m1.m22 + m2.m22, m1.m23 + m2.m23,
			m1.m31 + m2.m31, m1.m32 + m2.m32, m1.m33 + m2.m33 );
		}
		
		////////////////////// SUBTRACTION //////////////////////
		
		/*! returns the vector  v1 - v2 */
		public static function V2subtractV2(v1:Vector2,v2:Vector2):Vector2
		{
			return new Vector2(v1.x - v2.x, v1.y - v2.y);
		}
		
		/*! returns the vector  v1 - v2 */
		public static function V3subtractV3(v1:Vector3,v2:Vector3):Vector3
		{
			return new Vector3(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
		}
		
		/*! returns the quaternion  q1 - q2 */
		public static function QsubtractQ(q1:Quaternion,q2:Quaternion):Quaternion
		{
			return new Quaternion(q1.x - q2.x, q1.y - q2.y, q1.z - q2.z, q1.w - q2.w);
		}
		
		/*! returns the matrix m1 - m2 */
		public static function M2subtractM2(m1:Matrix2x2,m2:Matrix2x2):Matrix2x2
		{
			return new Matrix2x2(
			m1.m11 - m2.m11, m1.m12 - m2.m12,
			m1.m21 - m2.m21, m1.m22 - m2.m22 );
		}
		
		/*! returns the matrix m1 - m2 */
		public static function M3subtractM3(m1:Matrix3x3,m2:Matrix3x3):Matrix3x3
		{
			return new Matrix3x3(
			m1.m11 - m2.m11, m1.m12 - m2.m12, m1.m13 - m2.m13,
			m1.m21 - m2.m21, m1.m22 - m2.m22, m1.m23 - m2.m23,
			m1.m31 - m2.m31, m1.m32 - m2.m32, m1.m33 - m2.m33 );
		}
	}

}