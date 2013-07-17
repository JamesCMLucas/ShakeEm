package utils 
{
	/**
	 * ...
	 * @author James
	 */
	import flash.geom.Point;
    import flash.geom.Rectangle;
	
	
	
	import starling.display.DisplayObjectContainer;
    import starling.textures.Texture;
	import flash.geom.Rectangle;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
	import starling.events.EnterFrameEvent;
    import starling.display.Sprite;
	import starling.display.Image;
    import starling.textures.Texture;
	
	/** Dispatched when the user triggers the button. Bubbles. */
    [Event(name="triggered", type="starling.events.Event")]
	
	public class cSliderControl extends DisplayObjectContainer
	{
		private static const MAX_DRAG_DIST:Number = 50;
		private var mUpState:Texture;
        private var mDownState:Texture;
        
        private var mContents:Sprite;
        private var mBackground:Image;
        
        private var mScaleWhenDown:Number;
        private var mAlphaWhenDisabled:Number;
        private var mEnabled:Boolean;
        private var mIsDown:Boolean;
        private var mUseHandCursor:Boolean;
		
		private var mHalfSize:Number;
		private var mSize:Number;
		private var mPosition:Point;
		public var CurrentValue:Number;
		private var mIsVertical:Boolean;
		
		
		public function cSliderControl(upState:Texture, xPos:Number, yPos:Number, halfSize:Number, isVertical:Boolean = true, downState:Texture=null ) 
		{
			mHalfSize = halfSize;
			mSize = halfSize * 2;
			CurrentValue = 0.0;
			mIsVertical = isVertical;
			
			if (upState == null) throw new ArgumentError("Texture cannot be null");
            
            mUpState = upState;
            mDownState = downState ? downState : upState;
            mBackground = new Image(upState);
            mScaleWhenDown = downState ? 1.0 : 0.9;
            mAlphaWhenDisabled = 0.5;
            mEnabled = true;
            mIsDown = false;
            mUseHandCursor = true;
            
            mContents = new Sprite();
			mPosition = new Point( xPos, yPos );
			this.x = xPos;
			this.y = yPos;
			calculateCurrentValue();
			mContents.addChild(mBackground);
            addChild(mContents);
            addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function calculateCurrentValue():void
		{
			if ( mIsVertical )
				{
					CurrentValue = this.y - mPosition.y + mHalfSize;
					CurrentValue /= mHalfSize;
					CurrentValue += 1.0;
				}
				else
				{
					CurrentValue = this.x - mPosition.x + mHalfSize;
					CurrentValue /= mHalfSize;
					CurrentValue += 1.0;
				}
		}
		
		private function resetContents():void
        {
            mIsDown = false;
            mBackground.texture = mUpState;
            mContents.x = mContents.y = 0;
			//this.x = mPosition.x;
			//this.y = mPosition.y;
            mContents.scaleX = mContents.scaleY = 1.0;
        }
		
		private function onTouch(event:TouchEvent):void
        {
            Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(this)) ? 
                MouseCursor.BUTTON : MouseCursor.AUTO;
            
            var touch:Touch = event.getTouch(this);
            if (!mEnabled || touch == null) return;
            
            if (touch.phase == TouchPhase.BEGAN && !mIsDown)
            {
                mBackground.texture = mDownState;
                mContents.scaleX = mContents.scaleY = mScaleWhenDown;
                mContents.x = (1.0 - mScaleWhenDown) / 2.0 * mBackground.width;
                mContents.y = (1.0 - mScaleWhenDown) / 2.0 * mBackground.height;
                mIsDown = true;
				// start holding
				//addEventListener(EnterFrameEvent.ENTER_FRAME, onHold);
            }
            else if (touch.phase == TouchPhase.MOVED && mIsDown)
            {
				if ( mIsVertical )
				{
					this.y = touch.globalY;
					if ( this.y > mPosition.y + mHalfSize )
					{
						this.y = mPosition.y + mHalfSize;
					}
					else if ( this.y < mPosition.y - mHalfSize )
					{
						this.y = mPosition.y - mHalfSize;
					}
					CurrentValue = this.y - mPosition.y + mHalfSize;
					CurrentValue /= mHalfSize;
					CurrentValue += 1.0;
				}
				else
				{
					this.x = touch.globalX;
					if ( this.x > mPosition.x + mHalfSize )
					{
						this.x = mPosition.x + mHalfSize;
					}
					else if ( this.x < mPosition.x - mHalfSize )
					{
						this.x < mPosition.x - mHalfSize;
					}
					CurrentValue = this.x - mPosition.x + mHalfSize;
					CurrentValue /= mHalfSize;
					CurrentValue += 1.0;
				}
                // reset button when user dragged too far away after pushing
                var buttonRect:Rectangle = getBounds(stage);
                if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
                    touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
                    touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
                    touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
                {
                    resetContents();
                }
            }
            else if (touch.phase == TouchPhase.ENDED && mIsDown)
            {
                resetContents();
                dispatchEventWith(Event.TRIGGERED, true);
            }
        }
		
		private function onHold(e:EnterFrameEvent):void
		{
			
		}
		
		/** The scale factor of the button on touch. Per default, a button with a down state 
          * texture won't scale. */
        public function get scaleWhenDown():Number { return mScaleWhenDown; }
        public function set scaleWhenDown(value:Number):void { mScaleWhenDown = value; }
        
        /** The alpha value of the button when it is disabled. @default 0.5 */
        public function get alphaWhenDisabled():Number { return mAlphaWhenDisabled; }
        public function set alphaWhenDisabled(value:Number):void { mAlphaWhenDisabled = value; }
        
        /** Indicates if the button can be triggered. */
        public function get enabled():Boolean { return mEnabled; }
        public function set enabled(value:Boolean):void
        {
            if (mEnabled != value)
            {
                mEnabled = value;
                mContents.alpha = value ? 1.0 : mAlphaWhenDisabled;
                resetContents();
            }
        }
        
        /** The texture that is displayed when the button is not being touched. */
        public function get upState():Texture { return mUpState; }
        public function set upState(value:Texture):void
        {
            if (mUpState != value)
            {
                mUpState = value;
                if (!mIsDown) mBackground.texture = value;
            }
        }
        
        /** The texture that is displayed while the button is touched. */
        public function get downState():Texture { return mDownState; }
        public function set downState(value:Texture):void
        {
            if (mDownState != value)
            {
                mDownState = value;
                if (mIsDown) mBackground.texture = value;
            }
        }
        
        /** Indicates if the mouse cursor should transform into a hand while it's over the button. 
         *  @default true */
        public override function get useHandCursor():Boolean { return mUseHandCursor; }
        public override function set useHandCursor(value:Boolean):void { mUseHandCursor = value; }
	}

}