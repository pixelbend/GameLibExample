package test.screens.soundTest.view
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.helpers.IDisposeHelpers;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IRunnable;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.model.vo.sound.CompleteSoundPropertiesVO;
	import com.pixelBender.model.vo.sound.PlaySoundPropertiesVO;

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
		private var playingSoundChannels							:Dictionary;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function StopAllSoundsViewMediator(parentMediatorName:String, parentContainer:Sprite, gameSize:GameSizeVO,
												 	setupVO:StopAllSoundsViewVO, buttonTexturesMap:Dictionary)
		{
			super(parentMediatorName + MEDIATOR_NAME);

			playingSoundChannels = new Dictionary();

			createContainer(parentContainer, setupVO, gameSize);
			createName(parentMediatorName, setupVO, gameSize);
			createButton(setupVO, buttonTexturesMap, gameSize);
		}

		public function start():void
		{
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
			DictionaryHelpers.deleteValues(playingSoundChannels);

			playingSoundChannels = null;
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
						GameConstants.SOUND_STARTED,
						GameConstants.SOUND_COMPLETED
					];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case mediatorName + TestButtonView.BUTTON_TRIGGERED:
					handleStopAllSounds();
					break;
				case GameConstants.SOUND_STARTED:
					handleChannelStarted(notification.getBody() as PlaySoundPropertiesVO);
					break;
				case GameConstants.SOUND_COMPLETED:
					handleChannelStopped(notification.getBody() as CompleteSoundPropertiesVO);
					break;
			}
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		private function handleStopAllSounds():void
		{
			SoundHelpers.stopAllSoundsOnChannels();
			button.disable();
		}

		private function handleChannelStarted(playPropertiesVO:PlaySoundPropertiesVO):void
		{
			playingSoundChannels[playPropertiesVO.getChannelID()] = true;
			button.enable();
		}

		private function handleChannelStopped(completePropertiesVO:CompleteSoundPropertiesVO):void
		{
			delete playingSoundChannels[completePropertiesVO.getChannelID()];
			if (DictionaryHelpers.dictionaryLength(playingSoundChannels) == 0)
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
			button.disable();
		}
	}
}
