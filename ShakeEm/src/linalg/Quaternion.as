package linalg 
{
	/**
	 * ...
	 * @author James
	 */
	public class Quaternion 
	{
		/*! x dimension */
		public var x:Number;
		/*! y dimension */
		public var y:Number;
		/*! z dimension */
		public var z:Number;
		/*! w dimension */
		public var w:Number;
		/*! constructor -> defaults to identity */
		public function Quaternion(xValue:Number = 0.0, yValue:Number = 0.0, zValue:Number = 0.0, wValue:Number = 1.0) 
		{
			x = xValue; y = yValue; z = zValue; w = wValue;
		}
		
		/*! clone this quaternion, retun a copy */
		public function clone():Quaternion
		{
			return new Quaternion(x, y, z, w);
		}
		
		/*! get the angle of rotation */
		public function getAngle():Number
		{
			return 2.0 * Math.acos(w);
		}
		
		/*! get the axis of rotation
		 */
		public function getAxis():Vector3
		{
			var om2:Number = 1.0 - (w * w);
			if (om2 < 0.000000001)
			{
				return new Vector3(0.0, 1.0, 0.0);
			}
			var omInv:Number = 1.0 / Math.sqrt(om2);
			return  new Vector3(x * omInv, y * omInv, z * omInv);
		}
		
		/*! calculates the square length */
		public function lengthSquared():Number
		{
			return x * x + y * y + z * z + w * w;
		}
		
		/*! calculates the length
		 */
		public function length():Number
		{
			return Math.sqrt(x * x + y * y + z * z + w * w);
		}
		
		/*! normalize this quaternion
		 */
		public function normalize():void
		{
			var len:Number = Math.sqrt(x * x + y * y + z * z + w * w);
			if (len != 0.0)
			{
				x /= len;  y /= len;  z /= len;  w /= len;
			}
		}
		
		/*! normalize this quaternion and return the length
		 *  if length turns out to be zero, vector will become the identity
		 */
		public function normalizeAndGetLength():Number
		{
			var len:Number = Math.sqrt(x * x + y * y + z * z + w * w);
			if (len != 0.0)
			{
				x /= len;  y /= len;  z /= len;  w /= len;
			}
			else
			{
				x = 0.0;  y = 0.0;  z = 0.0;  w = 1.0;
			}
			return len;
		}
		
		/*! sets the x, y, z, w values */
		public function set(xValue:Number, yValue:Number, zValue:Number, wValue:Number):void
		{
			x = xValue;  y = yValue;  z = zValue;  w = wValue;
		}
		
		/*! copies contents of q */
		public function setQ(q:Quaternion):void
		{
			x = q.x;  y = q.y;  z = q.z; w = q.w;
		}
		
		/*! addition */
		public function addQ(q:Quaternion):void
		{
			x += q.x; y += q.y; z += q.z; w += q.w;
		}
		
		/*! subtraction */
		public function subtractQ(q:Quaternion):void
		{
			x -= q.x; y -= q.y; z -= q.z; w -= q.w;
		}
		
		/*! multiply by a number */
		public function multiply(n:Number):void
		{
			x *= n; y *= n; z *= n; w *= n;
		}
		
		/*! multiply by a quaternion */
		public function multiplyQ(q:Quaternion):void
		{
			var _x:Number = w * q.x + x * q.w + y * q.z - z * q.y;
			var _y:Number = w * q.y + y * q.w + z * q.x - x * q.z;
			var _z:Number = w * q.z + z * q.w + x * q.y - y * q.x;
			w = w * q.w - x * q.x - y * q.y - z * q.z;
			x = _x;
			y = _y;
			z = _z;
		}
		
		/*! divide by a number */
		public function divide(n:Number):void
		{
			if (n != 0.0)
			{
				x /= n; y /= n; z /= n; w /= n;
			}
		}
		
		/*! returns a new quaternion, this one divided by a number */
		public function getDivided(n:Number):Quaternion
		{
			if (n != 0.0)
			{
				return new Quaternion(x / n, y / n, z / n, w / n)
			}
			else
			{
				return new Quaternion();
			}
		}
		
		/*! returns a new quaternion, this one negated */
		public function getNegated():Quaternion
		{
			return new Quaternion( -x, -y, -z, -w);
		}
		
		/*! negate */
		public function negate():void
		{
			x = -x; y = -y; z = -z; w = -w;
		}
		
		/*! conjugate */
		public function conjugate():void
		{
			x = -x; y = -y; z = -z;
		}
		
		/*! returns a new quaternion, the conjugate of this */
		public function getConjugate():Quaternion
		{
			return new Quaternion( -x, -y, -z, w);
		}
		
		/*! inverts this quaternion */
		public function invert():void
		{
			this.conjugate();
			this.divide(this.lengthSquared());
		}
		
		/*! returns a new quaternion, this one inverted */
		public function getInverted():Quaternion
		{
			var q:Quaternion = this.getConjugate();
			q.divide(this.lengthSquared());
			return q;
		}
		
		/*! applies this as a rotation to another quaternion */
		public function applyToQuaternion(q:Quaternion):void
		{
			var conj:Quaternion = this.clone();
			conj.conjugate();
			var tmp:Quaternion = q.clone();
			tmp.multiplyQ(conj);
			q.multiplyQ(tmp);
		}
		
		/*! applies this as a rotation to vector v */
		public function applyToVector(v:Vector3):void
		{
			var vq:Quaternion = new Quaternion(v.x, v.y, v.z, 0.0);
			var conj:Quaternion = this.clone();
			vq.multiplyQ(conj);
			var rq:Quaternion = this.clone();
			rq.multiplyQ(vq);
			v.set(rq.x, rq.y, rq.z);
		}
		
		/*! returns the local x axis */
		public function getLocalXAxis():Vector3
		{
			return new Vector3(1.0 - 2.0 * (y * y + z * z), 2.0 * (x * y + z * w), 2.0 * (x * z - y * w));
		}
		
		/*! returns the local y axis */
		public function getLocalYAxis():Vector3
		{
			return new Vector3(2.0 * (x * y - z * w), 1.0 - 2.0 * (x * x + z * z), 2.0 * (y * z + x * w));
		}
		
		/*! returns the local z axis */
		public function getLocalZAxis():Vector3
		{
			return new Vector3(2.0 * (x * z + y * w), 2.0 * (y * z - x * w), 1.0 - 2.0 * (x * x + y * y));
		}
		
		/*! returns a new quaternion from an axis and angle
		 *  Note: assumes the vector v has been normalized
		 */
		public static function spawnAxisAngle(v:Vector3,a:Number):Quaternion
		{
			var sa:Number = Math.sin(a * 0.5);
			return new Quaternion(v.x * sa, v.y * sa, v.z * sa, Math.cos(a * 0.5));
		}
		
		/*! returns a new quaternion from euler angles */
		public static function spawnEulerAngles(yaw:Number, pitch:Number, roll:Number):Quaternion
		{
			var sinRoll:Number = Math.sin( roll * 0.5 );
			var sinYaw:Number = Math.sin( yaw * 0.5 );
			var sinPitch:Number = Math.sin( pitch * 0.5 );
			var cosRoll:Number = Math.cos( roll * 0.5 );
			var cosYaw:Number = Math.cos( yaw * 0.5 );
			var cosPitch:Number = Math.cos( pitch * 0.5 );
			
			var q:Quaternion = new Quaternion();
			q.x = cosYaw * sinPitch * cosRoll - sinYaw * cosPitch * sinRoll;
			q.y = sinYaw * cosPitch * cosRoll + cosYaw * sinPitch * sinRoll;
			q.z = cosYaw * cosPitch * sinRoll - sinYaw * sinPitch * cosRoll;
			q.w = cosYaw * cosPitch * cosRoll + sinYaw * sinPitch * sinRoll;
			return q;
		}
		/*! returns a new quaternion from a rotation matrix */
		/*
		public static function spawnMatrix(m:Matrix3x3):Quaternion
		{
			if (m.trace() > 0.0)
			{
				var t:Number = m.trace() + 1.0;
				var s:Number = 0.5 / Math.sqrt(t);
				return new Quaternion( s * (m.m23 - m.m21), s * (m.m31 - m.m32), s * (m.m12 - m.m21), s * t);
			}
			else if (m.m11 > m.m22 && m.m11 > m.m33)
			{
				
			}
			else if (m.m32 > m.m33)
			{
				
			}
			else
			{
				
			}
		}
		*/
		
	}

}