package test.screens.fileReferenceTest
{
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import constants.Constants;
	import flash.display.MovieClip;
	import org.puremvc.as3.interfaces.INotification;
	import starling.display.DisplayObjectContainer;

	import test.screens.common.screen.TestScreenWithBackButton;

	public class FileReferenceTestScreen extends TestScreenWithBackButton
	{
		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/fileReferenceTest/settings/assets.xml")]
		private const assetsXML												:Class;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Mediator responsible with creating the background
		 */
		protected var backgroundMediator									:FileReferenceBackgroundMediator;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function FileReferenceTestScreen(mediatorName:String)
		{
			super(mediatorName);
		}

		//==============================================================================================================
		// GAME SCREEN API
		//==============================================================================================================

		override public function prepareForStart(starlingScreenContainer:DisplayObjectContainer, gameScreenProxy:GameScreenProxy):void
		{
			super.prepareForStart(starlingScreenContainer, gameScreenProxy);

			// Background
			backgroundMediator = new FileReferenceBackgroundMediator(mediatorName, starlingGameScreen);
			facade.registerMediator(backgroundMediator);
			var gameFacade:GameFacade = facade as GameFacade,
				backgroundVector:MovieClip = gameScreenProxy.getScreenAssetPackage().getSWFAsset("background").getMovieSwf(),
				backgroundCreated:Boolean = backgroundMediator.initialize(gameFacade.getApplicationSize(), backgroundVector);
			// Check OK
			if (backgroundCreated)
			{
				handleBackgroundCreated();
			}
		}

		override public function stop():void
		{
			if (backgroundMediator != null)
			{
				facade.removeMediator(backgroundMediator.getMediatorName());
				backgroundMediator.dispose();
				backgroundMediator = null;
			}

			super.stop();
		}

		//==============================================================================================================
		// MEDIATOR API
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [
					getBackNotificationName(),
					FileReferenceBackgroundMediator.BACKGROUND_CREATED
					];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case getBackNotificationName():
					ScreenHelpers.showScreen(Constants.INTRO_SCREEN_NAME, Constants.TRANSITION_SEQUENCE_NAME);
					break;
				case FileReferenceBackgroundMediator.BACKGROUND_CREATED:
					if( mediatorName == String(notification.getBody()))
					{
						handleBackgroundCreated();
					}
					break;
			}
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		override protected function getScreenAssetXML():XML { return new XML(assetsXML.data); }
		override protected function getScreenLogicXML():XML { return null; }

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function handleBackgroundCreated():void
		{
			// Ready to start
			sendReadyToStart();
		}
	}
}
