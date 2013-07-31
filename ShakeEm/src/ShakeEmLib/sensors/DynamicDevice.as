package ShakeEmLib.sensors 
{
	import linalg.Matrix3x3;
	import linalg.Quaternion;
	import linalg.Vector3;
	import linalg.Ops;
	
	/**
	 * ...
	 * @author James
	 */
	public class DynamicDevice 
	{
		public var acc:SmoothAccelerometer;
		public var gyro:SmoothGyroscope;
		public var mag:SmoothMagnetometer;
		
		// latest accelerometer values
		public var accValues:Vector3;
		// latest gyroscope values
		public var gyroValues:Vector3;
		// latest magnetometer values
		public var magValues:Vector3;
		//
		private var mQuat:Quaternion;
		// phone orientation (axes x,y,z = north,west,up)
		public var orientation:Quaternion;
		// the gravity vector ("down")
		public var gravity:Vector3;
		// gravity removed, the "shake" acceleration
		public var acceleration:Vector3;
		
		public function DynamicDevice(smoothness:uint = 3) 
		{
			mag = new SmoothMagnetometer(smoothness);
			gyro = new SmoothGyroscope(smoothness);
			acc = new SmoothAccelerometer(smoothness);
			
			accValues = new Vector3();
			gyroValues = new Vector3();
			magValues = new Vector3();
			
			mQuat = new Quaternion();
			orientation = new Quaternion();
			gravity = new Vector3();
			acceleration = new Vector3();
		}
		
		public function updatePerFrame(dt:Number):void
		{
			acc.updatePerFrame();
			mag.updatePerFrame();
			gyro.updatePerFrame();
			
			accValues.set(acc.smoothX, acc.smoothY, acc.smoothZ);
			gyroValues.set(gyro.smoothX, gyro.smoothY, gyro.smoothZ);
			magValues.set(mag.smoothX, mag.smoothY, mag.smoothZ);
			
			ahrsUpdate(dt, gyroValues.x, gyroValues.y, gyroValues.z, accValues.x, accValues.y, accValues.z, magValues.x, magValues.y, magValues.z);
			orientation = mQuat.getInverted();
			
			var up:Vector3 = orientation.getLocalZAxis();
			gravity.set(-up.x, -up.y, -up.z);
			
			//acceleration = 
		}
		
		private function ahrsUpdate(dt:Number, gx:Number, gy:Number, gz:Number, ax:Number, ay:Number, az:Number, mx:Number, my:Number, mz:Number):void
		{
			var qw:Number = mQuat.w;
			var qx:Number = mQuat.x;
			var qy:Number = mQuat.y;
			var qz:Number = mQuat.z;   // short name local variable for readability
            var norm:Number;
            var hx:Number;
			var hy:Number; 
			var _2bx:Number;
			var _2bz:Number;
            var sw:Number;
			var sx:Number
			var sy:Number; 
			var sz:Number;
            var qDotw:Number;
			var qDotx:Number;
			var qDoty:Number;
			var qDotz:Number;

            // Auxiliary variables to avoid repeated arithmetic
            var _2qwmx:Number;
            var _2qwmy:Number;
            var _2qwmz:Number;
            var _2qxmx:Number;
            var _4bx:Number;
            var _4bz:Number;
            var _2qw:Number = 2 * qw;
            var _2qx:Number = 2 * qx;
            var _2qy:Number = 2 * qy;
            var _2qz:Number = 2 * qz;
            var _2qwqy:Number = 2 * qw * qy;
            var _2qyqz:Number = 2 * qy * qz;
            var qwqw:Number = qw * qw;
            var qwqx:Number = qw * qx;
            var qwqy:Number = qw * qy;
            var qwqz:Number = qw * qz;
            var qxqx:Number = qx * qx;
            var qxqy:Number = qx * qy;
            var qxqz:Number = qx * qz;
            var qyqy:Number = qy * qy;
            var qyqz:Number = qy * qz;
            var qzqz:Number = qz * qz;

            // Normalise accelerometer measurement
            norm = Math.sqrt(ax * ax + ay * ay + az * az);
            if (norm == 0.0) return; // handle NaN
            norm = 1 / norm;        // use reciprocal for division
            ax *= norm;
            ay *= norm;
            az *= norm;

            // Normalise magnetometer measurement
            norm = Math.sqrt(mx * mx + my * my + mz * mz);
            if (norm == 0.0) return; // handle NaN
            norm = 1 / norm;        // use reciprocal for division
            mx *= norm;
            my *= norm;
            mz *= norm;

            // Reference direction of Earth's magnetic field
            _2qwmx = 2 * qw * mx;
            _2qwmy = 2 * qw * my;
            _2qwmz = 2 * qw * mz;
            _2qxmx = 2 * qx * mx;
            hx = mx * qwqw - _2qwmy * qz + _2qwmz * qy + mx * qxqx + _2qx * my * qy + _2qx * mz * qz - mx * qyqy - mx * qzqz;
            hy = _2qwmx * qz + my * qwqw - _2qwmz * qx + _2qxmx * qy - my * qxqx + my * qyqy + _2qy * mz * qz - my * qzqz;
            _2bx = Math.sqrt(hx * hx + hy * hy);
            _2bz = -_2qwmx * qy + _2qwmy * qx + mz * qwqw + _2qxmx * qz - mz * qxqx + _2qy * my * qz - mz * qyqy + mz * qzqz;
            _4bx = 2 * _2bx;
            _4bz = 2 * _2bz;

            // Gradient decent algorithm corrective step
            sw = -_2qy * (2 * qxqz - _2qwqy - ax) + _2qx * (2 * qwqx + _2qyqz - ay) - _2bz * qy * (_2bx * (0.5 - qyqy - qzqz) + _2bz * (qxqz - qwqy) - mx) + (-_2bx * qz + _2bz * qx) * (_2bx * (qxqy - qwqz) + _2bz * (qwqx + qyqz) - my) + _2bx * qy * (_2bx * (qwqy + qxqz) + _2bz * (0.5 - qxqx - qyqy) - mz);
            sx = _2qz * (2 * qxqz - _2qwqy - ax) + _2qw * (2 * qwqx + _2qyqz - ay) - 4 * qx * (1 - 2 * qxqx - 2 * qyqy - az) + _2bz * qz * (_2bx * (0.5 - qyqy - qzqz) + _2bz * (qxqz - qwqy) - mx) + (_2bx * qy + _2bz * qw) * (_2bx * (qxqy - qwqz) + _2bz * (qwqx + qyqz) - my) + (_2bx * qz - _4bz * qx) * (_2bx * (qwqy + qxqz) + _2bz * (0.5 - qxqx - qyqy) - mz);
            sy = -_2qw * (2 * qxqz - _2qwqy - ax) + _2qz * (2 * qwqx + _2qyqz - ay) - 4 * qy * (1 - 2 * qxqx - 2 * qyqy - az) + (-_4bx * qy - _2bz * qw) * (_2bx * (0.5 - qyqy - qzqz) + _2bz * (qxqz - qwqy) - mx) + (_2bx * qx + _2bz * qz) * (_2bx * (qxqy - qwqz) + _2bz * (qwqx + qyqz) - my) + (_2bx * qw - _4bz * qy) * (_2bx * (qwqy + qxqz) + _2bz * (0.5 - qxqx - qyqy) - mz);
            sz = _2qx * (2 * qxqz - _2qwqy - ax) + _2qy * (2 * qwqx + _2qyqz - ay) + (-_4bx * qz + _2bz * qx) * (_2bx * (0.5 - qyqy - qzqz) + _2bz * (qxqz - qwqy) - mx) + (-_2bx * qw + _2bz * qy) * (_2bx * (qxqy - qwqz) + _2bz * (qwqx + qyqz) - my) + _2bx * qx * (_2bx * (qwqy + qxqz) + _2bz * (0.5 - qxqx - qyqy) - mz);
            norm = 1.0 / Math.sqrt(sw * sw + sx * sx + sy * sy + sz * sz);    // normalise step magnitude
            sw *= norm;
            sx *= norm;
            sy *= norm;
            sz *= norm;
			
			var beta:Number = 0.1;
            // Compute rate of change of quaternion
            qDotw = 0.5 * (-qx * gx - qy * gy - qz * gz) - beta * sw;
            qDotx = 0.5 * (qw * gx + qy * gz - qz * gy) - beta * sx;
            qDoty = 0.5 * (qw * gy - qx * gz + qz * gx) - beta * sy;
            qDotz = 0.5 * (qw * gz + qx * gy - qy * gx) - beta * sz;

            // Integrate to yield quaternion
            qw += qDotw * dt;
            qx += qDotx * dt;
            qy += qDoty * dt;
            qz += qDotz * dt;
            norm = 1.0 / Math.sqrt(qw * qw + qx * qx + qy * qy + qz * qz);    // normalise quaternion
            mQuat.w = qw * norm;
            mQuat.x = qx * norm;
            mQuat.y = qy * norm;
            mQuat.z = qz * norm;
		}
		
	}

}