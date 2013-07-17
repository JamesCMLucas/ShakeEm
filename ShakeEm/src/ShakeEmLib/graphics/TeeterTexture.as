package ShakeEmLib.graphics 
{
	/**
	 * ...
	 * @author James
	 */
	
	import starling.display.Image;
	import starling.events.TouchEvent;
    import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class TeeterTexture extends Image
	{
		private var mCentreFrame:int = 0;
		private var mCurrentFrame:int = 0;
		
		private var mTextures:Vector.<Texture>;
		private var mTiltRanges:Vector.<Number>;
		
		public function TeeterTexture(textures:Vector.<Texture>, maxTilt:Number) 
		{
			mTextures = textures.concat();
			mCentreFrame = mTextures.length / 2;
			mCurrentFrame = mCentreFrame;
			
			// set the start texture in the image to the centre frame
			super( mTextures[mCentreFrame] );
			
			mTiltRanges = new Vector.<Number>(mTextures.length+1);
			SetMaxTilt(maxTilt);
		}
		
		public function SetTilt( tilt:Number ):void
		{
			var frame:int = mCentreFrame;
			
			if ( tilt >= 0.0 )
			{
				while ( frame < (mTextures.length - 1) && tilt > mTiltRanges[frame + 1] )
				{
					frame++
				}
			}
			else
			{
				while ( frame > 0 && tilt < mTiltRanges[frame] )
				{
					frame--;
				}
			}
			
			if ( frame != mCurrentFrame )
			{
				mCurrentFrame = frame;
				texture = mTextures[mCurrentFrame];
			}
			
		}
		
		public function SetMaxTilt( maxTilt:Number ):void
		{
			var range:Number = maxTilt / mCentreFrame;
			var halfRange:Number = range * 0.5;
			
			mTiltRanges[mCentreFrame] = -halfRange;
			mTiltRanges[mCentreFrame + 1] = halfRange;
			
			var i:int = 0;
			for (i = mCentreFrame + 2; i < mTiltRanges.length; i++ )
			{
				mTiltRanges[i] = mTiltRanges[i - 1] + range;
			}
			for (i = mCentreFrame - 1; i >= 0; i-- )
			{
				mTiltRanges[i] = mTiltRanges[i + 1] - range;
			}
		}
		
		public function GetTexture(frameID:int):Texture
        {
            if (frameID < 0 || frameID >= mTextures.length) throw new ArgumentError("Invalid frame id");
            return mTextures[frameID];
        }
	}

}