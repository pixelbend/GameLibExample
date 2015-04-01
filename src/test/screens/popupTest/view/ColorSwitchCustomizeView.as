package test.screens.popupTest.view
{
	import com.pixelBender.model.vo.game.GameSizeVO;

	import flash.display.Bitmap;

	import flash.display.BitmapData;

	import starling.display.Image;

	import starling.display.Sprite;

	import test.screens.popupTest.vo.PopupCustomizeViewVO;

	public class ColorSwitchCustomizeView extends PopupCustomizeView
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var colorImage									:Image;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function ColorSwitchCustomizeView(localizationModule:String, parentContainer:Sprite, vo:PopupCustomizeViewVO,
												 	gameSize:GameSizeVO, imageSize:int)
		{
			super(localizationModule, parentContainer, vo, gameSize);

			var bitmapData:BitmapData = new BitmapData(imageSize, imageSize, false, 0xFFFFFF);
			colorImage = Image.fromBitmap(new Bitmap(bitmapData), false);
			colorImage.x = containerBounds.width >> 1;
			colorImage.y = (containerBounds.height - colorImage.height) >> 1;

			container.addChild(colorImage);
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function setColor(value:int):void
		{
			colorImage.color = value;
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		public override function dispose():void
		{
			if (colorImage != null)
			{
				colorImage.removeFromParent(true);
				colorImage = null;
			}
			super.dispose();
		}
	}
}
