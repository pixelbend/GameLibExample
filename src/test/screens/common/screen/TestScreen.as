package test.screens.common.screen
{
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import constants.Constants;
	import org.puremvc.as3.interfaces.INotification;
	import starling.display.DisplayObjectContainer;
	import test.screens.common.view.BackView;

	public class TestScreen extends AbstractScreen
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Back button
		 */
		protected var backView														:BackView;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TestScreen(mediatorName:String)
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
			backView = new BackView(facade, mediatorName, starlingGameScreen, gameFacade.getApplicationSize());
		}

		override public function start():void
		{
			super.start();
			backView.start();
		}

		override public function pause():void
		{
			super.pause();
			backView.pause();
		}

		override public function resume():void
		{
			super.resume();
			backView.resume();
		}

		override public function stop():void
		{
			IRunnableHelpers.dispose([backView]);
			backView = null;
			super.stop();
		}

		public override function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(
																getBackNotificationName()
															);
		}

		public override function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			switch(notification.getName())
			{
				case getBackNotificationName():
					handleBackTriggered();
					break;
			}
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		protected function handleBackTriggered():void
		{
			ScreenHelpers.showScreen(Constants.INTRO_SCREEN_NAME, Constants.TRANSITION_SEQUENCE_NAME);
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
