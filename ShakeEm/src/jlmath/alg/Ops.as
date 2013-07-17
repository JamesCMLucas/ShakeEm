package jlmath.alg 
{
	/*! Handles operations
	 * addition, subtraction, multiplication, division
	 */
	
	/**
	 * ...
	 * @author James
	 */
	public class Ops 
	{
		/////////////////////////////////////////////////////////////////////
		///                                                               ///
		///                          ADDITION                             ///
		///                                                               ///
		/////////////////////////////////////////////////////////////////////
		
		/*! v_out = v1 + v2
		 */
		public static function addV2V2(v_out:Vec2, v1:Vec2, v2:Vec2):void
		{
			v_out.set(v1.x + v2.x, v1.y + v2.y);
		}
		
		/*! v_out = v1 + v2
		 */
		public static function addV3V3(v_out:Vec3, v1:Vec3, v2:Vec3):void
		{
			v_out.set(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
		}
		
		/*! v_out = v1 + v2
		 */
		public static function addV4V4(v_out:Vec4, v1:Vec4, v2:Vec4):void
		{
			v_out.set(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z, v1.w + v2.w);
		}
		
		
		/*! v_out = v + Vec2(s, s)
		 */
		public static function addV2Scalar(v_out:Vec2, v:Vec2, s:Number):void
		{
			v_out.set(v.x + s, v.y + s);
		}
		
		/*! v_out = v + Vec3(s, s, s)
		 */
		public static function addV3Scalar(v_out:Vec3, v:Vec3, s:Number):void
		{
			v_out.set(v.x + s, v.y + s, v.z + s);
		}
		
		/*! v_out = v + Vec4(s, s, s, s)
		 */
		public static function addV4Scalar(v_out:Vec4, v:Vec4, s:Number):void
		{
			v_out.set(v.x + s, v.y + s, v.z + s, v.w + s);
		}
		
		/*! m_out = m1 + m2
		 */
		public static function addM2M2(m_out:Mat2x2, m1:Mat2x2, m2:Mat2x2):void
		{
			m_out.set(m1.a + m2.a, m1.b + m2.b, m1.c + m2.c, m1.d + m2.d);
		}
		
		/*! m_out = m + Mat2x2(s, s, s, s)
		 */
		public static function addM2Scalar(m_out:Mat2x2, m:Mat2x2, s:Number):void
		{
			m_out.set(m.a + s, m.b + s, m.c + s, m.d + s);
		}
		
		/*! m_out = m1 + m2
		 */
		public static function addM3M3(m_out:Mat3x3, m1:Mat3x3, m2:Mat3x3):void
		{
			m_out.set(m1.a + m2.a, m1.b + m2.b, m1.c + m2.c, m1.d + m2.d, m1.e + m2.e, m1.f + m2.f, m1.g + m2.g, m1.h + m2.h, m1.i + m2.i);
		}
		
		/*! m_out = m + Mat3x3(s, s, s, s, s, s, s, s, s)
		 */
		public static function addM3Scalar(m_out:Mat3x3, m:Mat3x3, s:Number):void
		{
			m_out.set(m.a + s, m.b + s, m.c + s, m.d + s, m.e + s, m.f + s, m.g + s, m.h + s, m.i + s);
		}
		
		
		/////////////////////////////////////////////////////////////////////
		///                                                               ///
		///                         SUBTRACTION                           ///
		///                                                               ///
		/////////////////////////////////////////////////////////////////////
		/*! v_out = v1 - v2
		 */
		public static function subV2V2(v_out:Vec2, v1:Vec2, v2:Vec2):void
		{
			v_out.set(v1.x - v2.x, v1.y - v2.y);
		}
		
		/*! v_out = v1 - v2
		 */
		public static function subV3V3(v_out:Vec3, v1:Vec3, v2:Vec3):void
		{
			v_out.set(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
		}
		
		/*! v_out = v1 - v2
		 */
		public static function subV4V4(v_out:Vec4, v1:Vec4, v2:Vec4):void
		{
			v_out.set(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z, v1.w - v2.w);
		}
		
		
		/*! v_out = v - Vec2(s, s)
		 */
		public static function subV2Scalar(v_out:Vec2, v:Vec2, s:Number):void
		{
			v_out.set(v.x - s, v.y - s);
		}
		
		/*! v_out = v - Vec3(s, s, s)
		 */
		public static function subV3Scalar(v_out:Vec3, v:Vec3, s:Number):void
		{
			v_out.set(v.x - s, v.y - s, v.z - s);
		}
		
		/*! v_out = v - Vec4(s, s, s, s)
		 */
		public static function subV4Scalar(v_out:Vec4, v:Vec4, s:Number):void
		{
			v_out.set(v.x - s, v.y - s, v.z - s, v.w - s);
		}
		
		/*! m_out = m1 - m2
		 */
		public static function subM2M2(m_out:Mat2x2, m1:Mat2x2, m2:Mat2x2):void
		{
			m_out.set(m1.a - m2.a, m1.b - m2.b, m1.c - m2.c, m1.d - m2.d);
		}
		
		/*! m_out = m - Mat2x2(s, s, s, s)
		 */
		public static function subM2Scalar(m_out:Mat2x2, m:Mat2x2, s:Number):void
		{
			m_out.set(m.a - s, m.b - s, m.c - s, m.d - s);
		}
		
		/*! m_out = m1 - m2
		 */
		public static function subM3M3(m_out:Mat3x3, m1:Mat3x3, m2:Mat3x3):void
		{
			m_out.set(m1.a - m2.a, m1.b - m2.b, m1.c - m2.c, m1.d - m2.d, m1.e - m2.e, m1.f - m2.f, m1.g - m2.g, m1.h - m2.h, m1.i - m2.i);
		}
		
		/*! m_out = m - Mat3x3(s, s, s, s, s, s, s, s, s)
		 */
		public static function subM3Scalar(m_out:Mat3x3, m:Mat3x3, s:Number):void
		{
			m_out.set(m.a - s, m.b - s, m.c - s, m.d - s, m.e - s, m.f - s, m.g - s, m.h - s, m.i - s);
		}
		
		
		/////////////////////////////////////////////////////////////////////
		///                                                               ///
		///                       MULTIPLICATION                          ///
		///                                                               ///
		/////////////////////////////////////////////////////////////////////
		
		
		/*! m_out = m1 * m2
		 */
		public static function mulM2M2(m_out:Mat2x2, m1:Mat2x2, m2:Mat2x2):void
		{
			m_out.set( 
			(m1.a * m2.a + m1.b * m2.c), (m1.a * m2.b + m1.b * m2.d),
			(m1.c * m2.a + m1.d * m2.c), (m1.c * m2.b + m1.d * m2.d) );
		}
		
		/*! m_out = v * m
		 */
		public static function mulV2M2(v_out:Vec2, v:Vec2, m:Mat2x2):void
		{
			v_out.set((v.x * m.a + v.y * m.c), (v.x * m.b + v.y * m.d));
		}
		
		/*! m_out = m * v
		 */
		public static function mulM2V2(v_out:Vec2, m:Mat2x2, v:Vec2):void
		{
			v_out.set((m.a * v.x + m.b * v.y), (m.c * v.x + m.d * v.y));
		}
		
		/*! m_out = m1 * m2
		 */
		public static function mulM3M3(m_out:Mat3x3, m1:Mat3x3, m2:Mat3x3):void
		{
			m_out.set( 
			(m1.a * m2.a + m1.b * m2.d + m1.c * m2.g), (m1.a * m2.b + m1.b * m2.e + m1.c * m2.h), (m1.a * m2.c + m1.b * m2.f + m1.c * m2.i),
			(m1.d * m2.a + m1.e * m2.d + m1.f * m2.g), (m1.d * m2.b + m1.d * m2.e + m1.f * m2.h), (m1.d * m2.c + m1.e * m2.f + m1.f * m2.i),
			(m1.g * m2.a + m1.h * m2.d + m1.i * m2.g), (m1.g * m2.b + m1.h * m2.e + m1.i * m2.h), (m1.g * m2.c + m1.h * m2.f + m1.i * m2.i) );
		}
		
		/*! m_out = v * m
		 */
		public static function mulV3M3(v_out:Vec3, v:Vec3, m:Mat3x3):void
		{
			v_out.set((v.x * m.a + v.y * m.d + v.z * m.g), (v.x * m.b + v.y * m.e + v.z * m.h), (v.x * m.c + v.y * m.f + v.z * m.i));
		}
		
		/*! m_out = m * v
		 */
		public static function mulM3V3(v_out:Vec3, m:Mat3x3, v:Vec3):void
		{
			v_out.set((m.a * v.x + m.b * v.y + m.c * v.z), (m.d * v.x + m.e * v.y + m.f * v.z), (m.g * v.x + m.h * v.y + m.i * v.z));
		}
		
		
		/////////////////////////////////////////////////////////////////////
		///                                                               ///
		///                        DOT PRODUCTS                           ///
		///                                                               ///
		/////////////////////////////////////////////////////////////////////
		
		/*! returns v1 * v2
		 */
		public static function dotV2V2(v1:Vec2, v2:Vec2):Number
		{
			return (v1.x * v2.x) + (v1.y * v2.y);
		}
		
		/*! returns v1 * v2
		 */
		public static function dotV3V3(v1:Vec3, v2:Vec3):Number
		{
			return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z);
		}
		
		/*! returns v1 * v2
		 */
		public static function dotV4V4(v1:Vec4, v2:Vec4):Number
		{
			return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z) + (v1.w * v2.w);
		}
		
		
		/////////////////////////////////////////////////////////////////////
		///                                                               ///
		///                       CROSS PRODUCTS                          ///
		///                                                               ///
		/////////////////////////////////////////////////////////////////////
		
		/*! returns z dimension of v1 X v2
		 */
		public static function crossV2V2(v1:Vec2, v2:Vec2):Number
		{
			return v1.x * v2.y - v1.y * v2.x;
		}
		
		/*! v_out = v1 X v2
		 */
		public static function crossV3V3(v_out:Vec3, v1:Vec3, v2:Vec3):void
		{
			v_out.set( v1.y * v2.z - v1.z * v2.y, v1.z * v2.x - v1.x * v2.z, v1.x * v2.y - v1.y * v2.x );
		}
		
		
	}

}