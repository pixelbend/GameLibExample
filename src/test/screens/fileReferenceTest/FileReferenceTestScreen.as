package test.screens.fileReferenceTest
{
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.view.gameScreen.StarlingGameScreen;
	import constants.Constants;
	import flash.display.MovieClip;
	import org.puremvc.as3.interfaces.INotification;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import test.screens.common.view.BackView;
	import test.screens.common.view.TitleView;

	public class FileReferenceTestScreen extends StarlingGameScreen
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
		 * Starling screen graphics container
		 */
		protected var starlingGameScreen									:Sprite;

		/**
		 * Mediator responsible with creating the background
		 */
		protected var backgroundMediator									:FileReferenceBackgroundMediator;

		/**
		 * Back view
		 */
		protected var backView												:BackView;

		/**
		 * Welcome intro text
		 */
		protected var title													:TitleView;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function FileReferenceTestScreen(mediatorName:String)
		{
			super(mediatorName);
			starlingGameScreen = new Sprite();
		}

		//==============================================================================================================
		// GAME SCREEN API
		//==============================================================================================================

		override public function prepareForStart(starlingScreenContainer:DisplayObjectContainer, gameScreenProxy:GameScreenProxy):void
		{
			// Add screen container to display list
			starlingScreenContainer.addChild(starlingGameScreen);
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
			starlingGameScreen.removeFromParent();
			if (backgroundMediator)
			{
				facade.removeMediator(backgroundMediator.getMediatorName());
			}
			IRunnableHelpers.dispose([backView, title, backgroundMediator]);
			backgroundMediator = null;
			backView = null;
			title = null;
		}

		override public function dispose():void
		{
			StarlingHelpers.disposeContainer(starlingGameScreen);
			starlingGameScreen = null;
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

		protected function getBackNotificationName():String
		{
			return mediatorName + BackView.BACK_TRIGGERED;
		}

		protected function handleBackgroundCreated():void
		{
			// Internals
			var gameSize:GameSizeVO = GameFacade(facade).getApplicationSize();
			// Title
			title = new TitleView(mediatorName, starlingGameScreen, gameSize);
			// Back view
			backView = new BackView(facade, mediatorName, starlingGameScreen, gameSize);
			// Ready to start
			sendReadyToStart();
		}
	}
}
