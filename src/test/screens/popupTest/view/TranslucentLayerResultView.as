package test.screens.popupTest.view
{
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.model.vo.popup.PopupTranslucentLayerVO;

	import constants.Constants;

	import flash.display.Bitmap;

	import flash.display.BitmapData;

	import starling.display.Image;

	import starling.display.Sprite;
	import starling.text.TextField;

	import test.screens.popupTest.vo.PopupCustomizeResultViewVO;

	public class TranslucentLayerResultView implements IDispose
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var resultImage												:Image;
		private var container												:Sprite;
		private var name													:TextField;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TranslucentLayerResultView(localizationModule:String, parentContainer:Sprite, vo:PopupCustomizeResultViewVO, gameSize:GameSizeVO, imageSize:int)
		{
			container = new Sprite();
			container.x = vo.getX() * gameSize.getWidth();
			container.y = vo.getY() * gameSize.getHeight();
			parentContainer.addChild(container);

			var containerWidth:int = vo.getWidth() * gameSize.getWidth(),
				containerHeight:int = vo.getHeight() * gameSize.getHeight(),
				text:String = LocalizationHelpers.getLocalizedText(localizationModule, vo.getTextID());

			name = new TextField(containerWidth * 0.5, containerHeight, text, Constants.APPLICATION_FONT_BOLD, containerHeight * 0.07, 0xFFFFFF, true);
			container.addChild(name);

			var bitmapData:BitmapData = new BitmapData(imageSize, imageSize, false, 0xFFFFFF);
			resultImage = Image.fromBitmap(new Bitmap(bitmapData), false);
			resultImage.x = (vo.getWidth() * gameSize.getWidth() ) >> 1;
			resultImage.y = ((vo.getHeight() * gameSize.getHeight()) - resultImage.height) >> 1;

			container.addChild(resultImage);
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function update(vo:PopupTranslucentLayerVO):void
		{
			if (vo.getLayerEnabled())
			{
				resultImage.visible = true;
				resultImage.color = vo.getLayerColor();
				resultImage.alpha = vo.getLayerAlpha();
			}
			else
			{
				resultImage.visible = false;
			}
		}

		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================

		public function dispose():void
		{
			StarlingHelpers.disposeContainer(name);
			StarlingHelpers.disposeContainer(container);
			if (resultImage)
			{
				resultImage.removeFromParent(true);
				resultImage = null;
			}
			name = null;
			container = null;
		}
	}
}
