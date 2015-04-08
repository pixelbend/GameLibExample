package test.screens.soundTest.view
{
	import com.pixelBender.helpers.IDisposeHelpers;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IRunnable;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import constants.Constants;

	import flash.utils.Dictionary;

	import org.puremvc.as3.interfaces.INotification;

	import org.puremvc.as3.patterns.mediator.Mediator;

	import starling.display.Sprite;

	import starling.text.TextField;
	import starling.textures.Texture;

	import test.screens.common.view.TestButtonView;

	import test.screens.soundTest.vo.StopAllSoundsViewVO;

	public class StopAllSoundsViewMediator extends Mediator implements IRunnable
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		protected static const MEDIATOR_NAME						:String = "_stopAllSoundsViewMediator";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var name											:TextField;
		private var container										:Sprite;
		private var button											:TestButtonView;
		private var playingSoundChannels							:int;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function StopAllSoundsViewMediator(parentMediatorName:String, parentContainer:Sprite, gameSize:GameSizeVO,
												 	setupVO:StopAllSoundsViewVO, buttonTexturesMap:Dictionary)
		{
			super(parentMediatorName + MEDIATOR_NAME);

			createContainer(parentContainer, setupVO, gameSize);
			createName(parentMediatorName, setupVO, gameSize);
			createButton(setupVO, buttonTexturesMap, gameSize);
		}

		public function start():void
		{
			playingSoundChannels = 0;
			button.start();
			button.disable();
		}

		public function pause():void
		{
			button.pause();
		}

		public function resume():void
		{
			button.resume();
		}

		public function dispose():void
		{
			StarlingHelpers.removeFromParent(container);
			StarlingHelpers.removeFromParent(name);
			IDisposeHelpers.dispose(button);

			container = null;
			name = null;
			button = null;
		}

		//==============================================================================================================
		// Mediator API
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [
						mediatorName + TestButtonView.BUTTON_TRIGGERED,
						SoundTestViewMediator.STARTED_SOUND_ON_CHANNEL,
						SoundTestViewMediator.STOPPED_SOUND_ON_CHANNEL
					];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case mediatorName + TestButtonView.BUTTON_TRIGGERED:
					SoundHelpers.stopAllSoundsOnChannels();
					break;
				case SoundTestViewMediator.STARTED_SOUND_ON_CHANNEL:
					handleChannelStarted();
					break;
				case SoundTestViewMediator.STOPPED_SOUND_ON_CHANNEL:
					handleChannelStopped();
					break;
			}
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		private function handleChannelStarted():void
		{
			playingSoundChannels++;
			button.enable();
		}

		private function handleChannelStopped():void
		{
			playingSoundChannels--;
			if (playingSoundChannels <= 0)
			{
				button.disable();
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function createContainer(parentContainer:Sprite, setup:StopAllSoundsViewVO, gameSize:GameSizeVO):void
		{
			container = new Sprite();
			parentContainer.addChild(container);
			container.y = gameSize.getHeight() * setup.getY();
		}

		private function createName(parentMediatorName:String, setup:StopAllSoundsViewVO, gameSize:GameSizeVO):void
		{
			var tfHeight:int = gameSize.getHeight() * setup.getTextHeight();

			name = new TextField(gameSize.getWidth() * setup.getTextWidth(), tfHeight,
					LocalizationHelpers.getLocalizedText(parentMediatorName, setup.getTextID()),
					Constants.APPLICATION_FONT_REGULAR, tfHeight * 0.25, 0xFFFFFF, true);

			container.addChild(name);
		}

		private function createButton(buttonLayout:StopAllSoundsViewVO, buttonTexturesMap:Dictionary, gameSize:GameSizeVO):void
		{
			var buttonTextures:Vector.<Texture> = buttonTexturesMap[buttonLayout.getButtonLinkage()];
			button = new TestButtonView(mediatorName, null);
			button.createButton(container, buttonTextures[0], buttonTextures[1], gameSize.getWidth() * buttonLayout.getButtonX(), 0);
		}
	}
}
