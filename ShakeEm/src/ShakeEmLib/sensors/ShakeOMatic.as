package ShakeEmLib.sensors 
{
	import starling.core.Starling;
	
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Vec2;
	
	import flash.system.Capabilities;
	
	import linalg.Matrix3x3;
	import linalg.Vector3;
	import linalg.Ops;
	/**
	 * ... 
	 * @author James
	 * 
	 * ShakeOMatic
	 * manages the accelerometer and gyroscope to produce 
	 * linear and angular acceleration and velocity in
	 * real world and a simulated world scale
	 */
	public class ShakeOMatic
	{
		/*! the magnetometer */
		public var magnetometer:SmoothMagnetometer;
		/*! the accelerometer */
		public var accelerometer:SmoothAccelerometer;
		/*! the gyroscope */
		public var gyroscope:SmoothGyroscope;
		/*! the latest magnetometer values (updated per frame) */
		public var magnetValues:Vector3;
		/*! the latest accelerometer values (updated per frame) */
		public var accValues:Vector3;
		/*! the latest gyroscope values (updated per frame) */
		public var gyroValues:Vector3;
		
		public var orientation:Vector3;
		
		/*! angular velocity */
		private var angularVel:Vector3;
		
		/*! gravity acceleration */
		private var gravity:Vector3;
		/*! linear velocity */
		private var linearVel:Vector3;
		/*! linear acceleration (applied) */
		private var linearAcc:Vector3;
		/*! rotation about the relative axes */
		private var rotation:Vector3;
		
		/*! complementary filter coeffiction */
		public var filterCoefficient:Number = 0.75;
		/*! scaling factor */
		public var scalingFactor:Number = 1.0;
		/*! complementary angular velocity coefficient
		 */
		//private var avFilterCoefficient:Number = 0.2;
		
		/*! the physical size of the screen, in meters
		 */
		private var screenWidth:Number;
		private var screenHeight:Number;
		
		public function ShakeOMatic(smoothness:uint = 3) 
		{
			if (smoothness < 1)
			{
				throw new ArgumentError("SensorDevice constructor: smoothness must be at least equal to 1");
			}
			try
			{
				magnetometer = new SmoothMagnetometer(smoothness);
			} 
			catch (e:Error)
			{
				throw new Error("SensorDevice constructor: Something went wrong making the magnetometer!");
			}
			try
			{
				accelerometer = new SmoothAccelerometer(smoothness);
			} 
			catch (e:Error)
			{
				throw new Error("SensorDevice constructor: Something went wrong making the accelerometer!");
			}
			try
			{
				gyroscope = new SmoothGyroscope(smoothness);
			} 
			catch (e:Error)
			{
				throw new Error("SensorDevice constructor: Something went wrong making the gyroscope!");
			}
			
			gyroValues = new Vector3();
			accValues = new Vector3(0.0, 1.0, 0.0);
			magnetValues = new Vector3();
			
			gravity = new Vector3();
			linearAcc = new Vector3();
			linearVel = new Vector3();
			rotation = new Vector3();
			orientation = new Vector3();
			
			// calculate the screen size
			var dpi:Number = Capabilities.screenDPI;
			var scaleFactor:Number = Starling.contentScaleFactor;
			var inchesToMeters:Number = 0.0254;
			screenWidth = Starling.current.nativeStage.fullScreenWidth * scaleFactor * inchesToMeters / dpi;
			screenHeight = Starling.current.nativeStage.fullScreenHeight * scaleFactor * inchesToMeters / dpi;
		}
		
		/*! per-frame update */
		public function updatePerFrame(dt:Number):void
		{
			// update the sensors
			accelerometer.updatePerFrame();
			gyroscope.updatePerFrame();
			
			// update our cache
			magnetValues.set(magnetometer.smoothX, magnetometer.smoothY, magnetometer.smoothZ);
			accValues.set(accelerometer.smoothX, accelerometer.smoothY, accelerometer.smoothZ);
			gyroValues.set(gyroscope.smoothX, gyroscope.smoothY, gyroscope.smoothZ);
			
			
			//accValues.normalize();
			//magnetValues.normalize();
			
			//var pitch:Number = Math.asin(-accValues.y);
			//var roll:Number = Math.asin(accValues.x);
			
			//var y:Number = -magnetValues.x * Math.cos(roll) + magnetValues.z * Math.sin(roll);
			//var x:Number = -magnetValues.x * Math.sin(pitch) * Math.sin(roll) + magnetValues.y * Math.cos(pitch) + magnetValues.z * Math.sin(pitch) * Math.cos(roll);
			//var azimuth:Number = Math.atan2(x, y);
			//orientation.set(pitch, roll, azimuth);
			//trace("magnet = (" + magnetValues.x + ", " + magnetValues.y + ", " + magnetValues.z + ")");
			// TODO: need to remove predicted gravity components here, THEN set the values
			// predicted angles from accelerometer
			
			var accRot:Vector3 = new Vector3();
			/*
			trace("magnet = (" + magnetValues.x + ", " + magnetValues.y + ", " + magnetValues.z + ")");
			magnetValues.normalize();
			accRot.x = Math.atan2(-magnetValues.z, magnetValues.y);
			accRot.y = Math.atan2(magnetValues.z, magnetValues.x);
			accRot.z = Math.atan2(magnetValues.x, magnetValues.y);
			rotation.setV(accRot);
			*/
			
			accRot.z = Math.atan2(accValues.x, accValues.y);
			accRot.x = Math.atan2(-accValues.z, accValues.y);
			accRot.y = Math.atan2(accValues.z, accValues.x);
			
			rotation.x = (filterCoefficient * (rotation.x + gyroValues.x * dt)) + ((1.0 - filterCoefficient) * accRot.x);
			rotation.y = (filterCoefficient * (rotation.y + gyroValues.y * dt)) + ((1.0 - filterCoefficient) * accRot.y);
			rotation.z = (filterCoefficient * (rotation.z + gyroValues.z * dt)) + ((1.0 - filterCoefficient) * accRot.z);
			
			//trace("rotation = (" + rotation.x + ", " + rotation.y + ", " + rotation.z + ")");
			
			
			// first half step of velocity verlet
			//var acc:Vector3 = accValues.clone();
			//acc.multiply(dt * 0.5);
			// velocity at time t + dt*0.5
			//var velThalf:Vector3 = Ops.V3addV3(linearVel, acc);
			
			
			
			//accValues.set(accelerometer.smoothX, accelerometer.smoothY, accelerometer.smoothZ);
			
			//acc.setV(accValues);
			//acc.multiply(dt * dt * 0.5);
			//linearVel = Ops.V3addV3(velThalf, acc);
			
			
			/*
			var rotZ:Number = Math.atan2(accValues.x, accValues.y);
			var newAngle:Number = (filterCoeff * (rotation.z + gyroValues.z * dt)) + ((1.0 - filterCoeff) * rotation.z);
			var gravityConstant:Number = 9.81;
			var gravityDirection:b2Vec2 = new b2Vec2(0.0, 1.0);
			var rotMat:b2Mat22 = new b2Mat22();
			rotMat.Set(newAngle);
			currentAngle = newAngle;
			gravityDirection.MulM(rotMat);
			
			var newGravity:b2Vec2 = new b2Vec2();
			newGravity.SetV(gravityDirection);
			var gravitySize:Number = accValues.length();
			if (gravitySize != 0.0)
			{
				gravitySize = Math.sqrt(accValues.x * accValues.x + accValues.y * accValues.y) / gravitySize;
			}
			
			newGravity.Multiply(gravitySize*gravityConstant);
			var alpha:Number = 0.8;
			gravity.Multiply(alpha);
			gravity.Add ( new b2Vec2(newGravity.x * (1.0 - alpha), newGravity.y * (1.0 - alpha)) );
			
			var linearAcceleration:b2Vec2 = new b2Vec2(newGravity.x - gravity.x, newGravity.y - gravity.y);
			gravity.SetV(newGravity);
			*/
			
			
			
			
			/*
			// make the direction cosine matrix for the gyroscope
			var dThetaX:Number = gyroValues.x * dt;
			var dThetaY:Number = gyroValues.y * dt;
			var dThetaZ:Number = gyroValues.z * dt;
			var dcmGyro:Matrix3x3 = new Matrix3x3(1.0, -dThetaZ, dThetaY, dThetaZ, 1.0, -dThetaX, -dThetaY, dThetaX, 1.0);
			
			// errors accumulate! renormalize
			// I'm assuming the X and Y axes for normalization
			// but maybe the choice should be dynamic, based on some importance choice
			var dcmRowX:Vector3 = dcmGyro.GetRow1();
			var dcmRowY:Vector3 = dcmGyro.GetRow2();
			var dcmError:Number = dcmRowX.dot(dcmRowY);
			
			var dcmRowXOrtho:Vector3 = dcmRowY.clone();
			var dcmRowYOrtho:Vector3 = dcmRowX.clone();
			dcmRowXOrtho.multiply(-dcmError * 0.5);
			dcmRowYOrtho.multiply(-dcmError * 0.5);
			dcmRowXOrtho.addV(dcmRowX);
			dcmRowYOrtho.addV(dcmRowY);
			// assign z axis the cross product
			var dcmRowZOrtho:Vector3 = dcmRowXOrtho.cross(dcmRowYOrtho);
			// scale the rows so each has a magnitude of 1
			dcmRowXOrtho.multiply(0.5 * (3.0 - dcmRowXOrtho.lengthSquared()));
			dcmRowYOrtho.multiply(0.5 * (3.0 - dcmRowYOrtho.lengthSquared()));
			dcmRowZOrtho.multiply(0.5 * (3.0 - dcmRowZOrtho.lengthSquared()));
			// set the rows of the matrix
			dcmGyro.SetRow1V(dcmRowXOrtho);
			dcmGyro.SetRow2V(dcmRowYOrtho);
			dcmGyro.SetRow3V(dcmRowZOrtho);
			*/
			
			
			// TODO: we need the centrifugal acceleration to adjust our gravity estimate
			//var accCentrifugal:Vector3 = gyroValues.cross(linearVel);
			
			
			
			
			
			/*
			var rotZ:Number = Math.atan2(aX, aY);
			angle = (filterCoefficient * (angle + gz * dt)) + ((1.0 - filterCoefficient) * rotZ);
			
			var aLen:Number = Math.sqrt(ax * ax + ay * ay + az * az);
			
			var alpha:Number = 0.8;
			gravityX = (alpha * gravityX) + (1.0 - alpha) * ax;
			gravityY = (alpha * gravityY) + (1.0 - alpha) * ay;
			*/
		}
		
		/*! sets the world scaling factor by width (corresponding to the phone's width - x axis) */
		public function setWorldWidth(width:Number):void
		{
			this.scalingFactor = width / this.screenWidth;
		}
		
		/*! sets the world scaling factor by height (corresponding to the phone's height - y axis) */
		public function setWorldHeight(height:Number):void
		{
			this.scalingFactor = height / this.screenHeight;
		}
		
		/*! the current angle about the x axis */
		public function get rotationX():Number
		{
			return rotation.x;
		}
		
		/*! the current angle about the y axis */
		public function get rotationY():Number
		{
			return rotation.y;
		}
		
		/*! the current angle about the z axis */
		public function get rotationZ():Number
		{
			return rotation.z;
		}
		/*! the physical height of the screen, in meters */
		public function get heightInMeters():Number
		{
			return screenHeight;
		}
		
		/*! the physical width of the screen, in meters */
		public function get widthInMeters():Number
		{
			return screenWidth;
		}
		
		/*! complementary filter coeffiction */
		/*public function get filterCoefficient():Number
		{
			return this.filterCoefficient;
		}*/
		
		/*! complementary filter coeffiction */
		/*public function set filterCoefficient(coeff:Number):void
		{
			if ((coeff > 0.0) && (coeff < 1.0))
			{
				this.filterCoefficient = coeff;
			}
		}*/
	}

}