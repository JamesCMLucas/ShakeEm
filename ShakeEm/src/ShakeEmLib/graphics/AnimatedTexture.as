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
	
	public class AnimatedTexture extends Image
	{
		public var CurrentFrameIndex:int = 0;
		
		private var mTextures:Vector.<Texture>;
		public var bPlaying:Boolean = false;
		public var bLooping:Boolean = false;
		
		public function cAnimatedTexture(textures:Vector.<Texture>) 
		{
			mTextures = textures.concat();
			CurrentFrameIndex = 0;
			super( mTextures[0] );
		}
		
		public function StepFrame():void
		{
			var frameIndex:int = CurrentFrameIndex;
			
			if ( !bPlaying ) return;
			
			frameIndex++;
			
			if (frameIndex >= mTextures.length)
			{
				if ( bLooping )
				{
					CurrentFrameIndex = 0;
					texture = mTextures[CurrentFrameIndex];
				}
				else
				{
					bPlaying = false;
				}
			}
			else
			{
				CurrentFrameIndex = frameIndex;
				texture = mTextures[CurrentFrameIndex];
			}
		}
	}

}