package test.screens.common.screen
{
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.view.gameScreen.StarlingGameScreen;

	import starling.display.DisplayObjectContainer;

	import starling.display.Sprite;

	import test.screens.common.view.TitleView;

	public class BaseTestScreen extends StarlingGameScreen
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Starling screen graphics container
		 */
		protected var starlingGameScreen									:Sprite;

		/**
		 * Welcome intro text
		 */
		protected var title													:TitleView;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function BaseTestScreen(mediatorName:String)
		{
			super(mediatorName);
			starlingGameScreen = new Sprite();
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		override public function prepareForStart(starlingScreenContainer:DisplayObjectContainer,
												 gameScreenProxy:GameScreenProxy):void
		{
			var gameSize:GameSizeVO = gameFacade.getApplicationSize();

			starlingScreenContainer.addChild(starlingGameScreen);
			title = new TitleView(mediatorName, starlingGameScreen, gameSize);
		}

		override public function stop():void
		{
			IRunnableHelpers.dispose(title);
			starlingGameScreen.removeFromParent();
		}

		override public function dispose():void
		{
			StarlingHelpers.disposeContainer(starlingGameScreen);
			starlingGameScreen = null;
		}
	}
}
