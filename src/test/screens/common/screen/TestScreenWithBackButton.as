package test.screens.common.screen
{
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import constants.Constants;

	import org.puremvc.as3.interfaces.INotification;

	import starling.display.DisplayObjectContainer;

	import test.screens.common.view.BackView;

	public class TestScreenWithBackButton extends BaseTestScreen
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Back view
		 */
		protected var backView												:BackView;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TestScreenWithBackButton(mediatorName:String)
		{
			super(mediatorName);
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		override public function prepareForStart(starlingScreenContainer:DisplayObjectContainer,
												 gameScreenProxy:GameScreenProxy):void
		{
			super.prepareForStart(starlingScreenContainer, gameScreenProxy);

			var gameSize:GameSizeVO = gameFacade.getApplicationSize();
			backView = new BackView(facade, mediatorName, starlingGameScreen, gameSize);
		}

		override public function start():void
		{
			IRunnableHelpers.start(backView);
		}

		override public function pause():void
		{
			IRunnableHelpers.pause(backView);
		}

		override public function resume():void
		{
			IRunnableHelpers.resume(backView);
		}

		override public function stop():void
		{
			IRunnableHelpers.dispose(backView);
			backView = null;

			super.stop();
		}

		//==============================================================================================================
		// MEDIATOR API
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [ getBackNotificationName() ];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case getBackNotificationName():
					ScreenHelpers.showScreen(Constants.INTRO_SCREEN_NAME, Constants.TRANSITION_SEQUENCE_NAME);
					break;
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function getBackNotificationName():String
		{
			return mediatorName + BackView.BACK_TRIGGERED;
		}
	}
}
