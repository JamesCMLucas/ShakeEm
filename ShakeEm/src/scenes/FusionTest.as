package scenes 
{
	import linalg.Matrix3x3;
	import linalg.Quaternion;
	import linalg.Vector3;
	
	import ShakeEmLib.sensors.SmoothMagnetometer;
	import ShakeEmLib.sensors.SmoothAccelerometer;
	import ShakeEmLib.sensors.SmoothGyroscope;
	
	import starling.core.Starling;
	import starling.display.Image;
    import starling.textures.Texture;
	import starling.events.EnterFrameEvent;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author James
	 */
	public class FusionTest extends Scene
	{
		public var acc:SmoothAccelerometer;
		public var gyro:SmoothGyroscope;
		public var mag:SmoothMagnetometer;
		
		public var quat:Quaternion;
		//public var accSize:Number = 0.0;
		public var arrow:Image;
		
		public function FusionTest() 
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateFrame);
			
			mag = new SmoothMagnetometer(3);
			gyro = new SmoothGyroscope(3);
			acc = new SmoothAccelerometer(3);
			
			quat = new Quaternion();
			
			arrow = new Image(Assets.getTexture("NorthArrow"));
			
			var arrowSize:Number = Constants.GameWidth / 4;
			arrow.pivotX = arrow.width / 2;
			arrow.pivotY = arrow.height / 2;
			arrow.width = arrowSize;
			arrow.height = arrowSize;
			arrow.x = Constants.CenterX;
			arrow.y = Constants.CenterY;
			
			addChild(arrow);
		}
		
		public function updateFrame(e:EnterFrameEvent):void
		{
			function traceVec(name:String, v:Vector3):void
			{
				trace(name + " = (" + v.x + ", " + v.y + ", " + v.z + ")");
			}
			var dt:Number = e.passedTime;
			
			mag.updatePerFrame();
			gyro.updatePerFrame();
			acc.updatePerFrame();
			
			var aX:Number = acc.smoothX;
			var aY:Number = acc.smoothY;
			var aZ:Number = acc.smoothZ;
			
			var gX:Number = gyro.smoothX;
			var gY:Number = gyro.smoothY;
			var gZ:Number = gyro.smoothZ;
			
			var mX:Number = mag.smoothX;
			var mY:Number = mag.smoothY;
			var mZ:Number = mag.smoothZ;
			
			var m:Vector3 = new Vector3(mX, mY, mZ);
			m.normalize();
			//trace("magnet = (" + m.x + ", " + m.y + ", " + m.z + ")");
			
			this.ahrsUpdate(dt, gX, gY, gZ, aX, aY, aZ, mX, mY, mZ);
			
			var orientation:Quaternion = quat.getInverted();
			// xAxis will point North (in phone frame coords)
			var xAxis:Vector3 = orientation.getLocalXAxis();
			// yAxis will point West (in phone frame coords)
			var yAxis:Vector3 = orientation.getLocalYAxis();
			// zAxis will point Up (in phone frame coords)
			var zAxis:Vector3 = orientation.getLocalZAxis();
			
			
			var gravity:Vector3 = zAxis.clone();
			//gravity.multiply( -1.0);
			var acceleration:Vector3 = new Vector3(aX, aY, aZ);
			
			/*
			function getLinearMultiple(n:Number,va:Number,vb:Number):Number
			{
				var absN:Number = Math.abs(n);
				if (absN < va)
				{
					return 0.0;
				}
				else if (absN < vb)
				{
					return (n - va)/(vb - va);
				}
				else
				{
					return 1.0;
				}
			}
			
			function calmAccel(a:Vector3):void
			{
				var v0:Number = 0.08;
				var v1:Number = 0.2;
				var mult:Number = getLinearMultiple(a.x, v0, v1);
				a.x *= mult;
				mult = getLinearMultiple(a.y, v0, v1);
				a.y *= mult;
				mult = getLinearMultiple(a.z, v0, v1);
				a.z *= mult;
			}
			*/
			//trace("|a| = " + acceleration.length());
			acceleration.subtractV(gravity);
			//calmAccel(acceleration);
			trace("acc size = " + acceleration.length());
			//traceVec("acceleration", acceleration);
			//trace( "aX = " + aX + "   zAxis.x = " + zAxis.x);
			
			
			
			// for xy tilt
			var angle:Number = Math.atan2( -zAxis.x, zAxis.y);
			// for z axis rotation
			//traceVec("z axis", zAxis);
			
			// to point north
			//var angle:Number = Math.atan2(-yAxis.y, -yAxis.x);
			// set it
			arrow.rotation = -angle;
			
			// calculate the scale
			var scale:Number = Math.cos(Constants.Pi_Div_2 * zAxis.z);
			//trace("z = " + zAxis.z + "   scale = " + scale);
			arrow.scaleY = scale * 0.625;
			//traceVec("z axis", zAxis);
		}
		
		private function ahrsUpdate(dt:Number, gx:Number, gy:Number, gz:Number, ax:Number, ay:Number, az:Number, mx:Number, my:Number, mz:Number):void
		{
			var qw:Number = quat.w;
			var qx:Number = quat.x;
			var qy:Number = quat.y;
			var qz:Number = quat.z;   // short name local variable for readability
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
            quat.w = qw * norm;
            quat.x = qx * norm;
            quat.y = qy * norm;
            quat.z = qz * norm;
		}
		
	}

}