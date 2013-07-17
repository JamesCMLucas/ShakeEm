package jlmath.alg 
{
	/*! Handles addition operations for vectors and matrices
	 */
	/**
	 * ...
	 * @author James
	 */
	public class Addition 
	{
		/*! v_out = v1 + v2
		 */
		public static function v4v4(v_out:Vec4, v1:Vec4, v2:Vec4):void
		{
			v_out.set(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z, v1.w + v2.w);
		}
	}

}