package test.screens.popupTest.view
{
	import com.pixelBender.model.vo.game.GameSizeVO;

	import flash.display.Bitmap;

	import flash.display.BitmapData;

	import starling.display.Image;

	import starling.display.Sprite;

	import test.screens.popupTest.vo.PopupCustomizeViewVO;

	public class AlphaSwitchCustomizeView extends PopupCustomizeView
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var alphaImage									:Image;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function AlphaSwitchCustomizeView(localizationModule:String, parentContainer:Sprite, vo:PopupCustomizeViewVO,
												 	gameSize:GameSizeVO, imageSize:int)
		{
			super(localizationModule, parentContainer, vo, gameSize);

			var bitmapData:BitmapData = new BitmapData(imageSize, imageSize, false, 0xFFFFFF);
			alphaImage = Image.fromBitmap(new Bitmap(bitmapData), false);
			alphaImage.x = containerBounds.width >> 1;
			alphaImage.y = (containerBounds.height - alphaImage.height) >> 1;

			container.addChild(alphaImage);
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function setAlpha(value:Number):void
		{
			alphaImage.alpha = value;
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		public override function dispose():void
		{
			if (alphaImage != null)
			{
				alphaImage.removeFromParent(true);
				alphaImage = null;
			}
			super.dispose();
		}
	}
}
