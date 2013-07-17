package ShakeEmLib 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...A container class for
	 * @author James
	 */
	public class Shape extends cEntity
	{
		/*! The type of shape: circle, star.. etc
		 * This is also the name of the texture that gets loaded from Assets
		 */
		public var Type:String = "";
		/*! The colour of shape: blue, gold.. etc
		 */
		public var Colour:String = "";
		/*! The size/scale of shape
		 */
		public var Width:Number = 1.0;
		public var Height:Number = 1.0;
		/*! The image
		 */
		public var ShapeImage:Image;
		/*! Identifies this shape has a boundary or not
		 */
		public var bIsBoundary:Boolean;
		/*! Constructor
		 */
		public function Shape(type:String, colour:String, imageSizeW:Number, imageSizeH:Number, isBoundary:Boolean = false) 
		{
			super();
			
			addEventListener(Event.ADDED, OnAddedToParent);
			addEventListener(Event.REMOVED, OnRemovedFromParent);
			
			Type = type;
			Colour = colour;
			Width = imageSizeW;
			Height = imageSizeH;
			bIsBoundary = isBoundary;
			
			ShapeImage = new Image(Assets.getTexture(type));
			ShapeImage.pivotX = ShapeImage.width / 2;
			ShapeImage.pivotY = ShapeImage.height / 2;
			ShapeImage.width = imageSizeW;
			ShapeImage.height = imageSizeH;
		}
		
		private function OnAddedToParent(e:Event):void
		{
			parent.addChild(ShapeImage);
		}
		
		private function OnRemovedFromParent(e:Event):void
		{
			parent.removeChild(ShapeImage);
		}
		
		public function Update():void
		{
			ShapeImage.x = this.x;
			ShapeImage.y = this.y;
			ShapeImage.rotation = this.rotation;
		}
	}

}