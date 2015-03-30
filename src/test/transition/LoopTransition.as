package test.transition
{
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import constants.Constants;

	import starling.display.DisplayObjectContainer;

	import starling.text.TextField;

	import test.facade.TestGameFacade;

	public class LoopTransition extends TestTransition
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		private const TRANSITION_MODULE_NAME							:String = "transition";
		private const LOADING_TEXT_ID									:String = "loading";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var loadingText											:TextField;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function LoopTransition(name:String)
		{
			super(name);
			var gameSize:GameSizeVO = TestGameFacade.getInstance().getApplicationSize();
			loadingText = new TextField(gameSize.getWidth(), gameSize.getHeight(), "",
										Constants.APPLICATION_FONT_BOLD, gameSize.getHeight() * 0.1, 0x000000, true);
		}

		//==============================================================================================================
		// OVERRIDES
		//==============================================================================================================

		override protected function playTransition():void
		{
			super.playTransition();
			if (loadingText.text == "")
			{
				loadingText.text = LocalizationHelpers.getLocalizedText(TRANSITION_MODULE_NAME, LOADING_TEXT_ID);
			}
			transitionView.addChild(loadingText);
		}

		override protected function stopTransition():void
		{
			super.stopTransition();
			loadingText.removeFromParent();
		}

		override protected function updateTransition():void
		{
			if (delta >= TRANSITION_TIME)
			{
				delta = 0;
				handleLoopComplete(null);
			}
		}
	}
}
