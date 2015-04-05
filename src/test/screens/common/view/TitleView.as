package test.screens.common.view
{
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import constants.Constants;

	import starling.display.Sprite;
	import starling.text.TextField;

	public class TitleView implements IDispose
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Screen title text
		 */
		protected var title															:TextField;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TitleView(mediatorName:String, container:Sprite, gameSize:GameSizeVO)
		{
			title = new TextField(gameSize.getWidth(), gameSize.getHeight() * 0.2,
									LocalizationHelpers.getLocalizedText(mediatorName, "title"),
										Constants.APPLICATION_FONT_BOLD, gameSize.getHeight() * 0.1, 0xFFFFFF, true);
			title.y = gameSize.getHeight() * 0.15;
			container.addChild(title);
		}

		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================

		public function dispose():void
		{
			StarlingHelpers.removeFromParent(title);
			title = null;
		}
	}
}
