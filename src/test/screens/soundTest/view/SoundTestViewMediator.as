package test.screens.soundTest.view
{
	import com.pixelBender.helpers.IDisposeHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IRunnable;
	import com.pixelBender.model.component.sound.SoundQueuePlayer;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.model.vo.sound.CompleteQueuePropertiesVO;
	import com.pixelBender.model.vo.sound.CompleteSoundPropertiesVO;

	import constants.Constants;

	import flash.text.TextFieldAutoSize;

	import flash.utils.Dictionary;

	import org.puremvc.as3.interfaces.INotification;

	import org.puremvc.as3.patterns.mediator.Mediator;

	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.VAlign;

	import test.screens.common.view.TestButtonView;

	import test.screens.common.vo.TestButtonLayoutVO;
	import test.screens.common.vo.TestButtonVO;

	import test.screens.common.vo.TestTitleLayoutVO;
	import test.screens.soundQueueTest.vo.SoundQueueTestSetupVO;
	import test.screens.soundTest.vo.SoundTestSetupVO;

	public class SoundTestViewMediator extends Mediator implements IRunnable
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const STARTED_SOUND_ON_CHANNEL				:String = MEDIATOR_NAME + "_startedSoundOnChannel";
		public static const STOPPED_SOUND_ON_CHANNEL				:String = MEDIATOR_NAME + "_stoppedSoundOnChannel";

		protected static const MEDIATOR_NAME						:String = "_soundTestViewMediator";

		protected static const ACTION_PLAY							:String = "play";
		protected static const ACTION_PAUSE							:String = "pause";
		protected static const ACTION_STOP							:String = "stop";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var name											:TextField;
		private var container										:Sprite;
		private var buttons											:Dictionary;

		private var channelID										:int;
		private var soundID											:String;
		private var soundPlaying									:Boolean;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundTestViewMediator(parentMediatorName:String, parentContainer:Sprite, gameSize:GameSizeVO,
												   titleLayout:TestTitleLayoutVO, buttonLayout:TestButtonLayoutVO,
												   setup:SoundTestSetupVO, buttonTexturesMap:Dictionary)
		{
			super(parentMediatorName + MEDIATOR_NAME + "_" + setup.getSetupID());

			channelID = setup.getChannelID();
			soundID = setup.getSoundID();

			createContainer(parentContainer, setup, gameSize);
			createName(parentMediatorName, titleLayout, setup, gameSize);
			createButtons(buttonLayout, buttonTexturesMap, gameSize);

			enableButtons(ACTION_PLAY);
		}

		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================

		public function start():void
		{
			IRunnableHelpers.start(buttons);
			soundPlaying = false;
		}

		public function pause():void
		{
			IRunnableHelpers.pause(buttons);
		}

		public function resume():void
		{
			IRunnableHelpers.resume(buttons);
		}

		public function dispose():void
		{
			StarlingHelpers.removeFromParent(container);
			StarlingHelpers.removeFromParent(name);
			IDisposeHelpers.dispose(buttons);

			container = null;
			name = null;
			buttons = null;
			soundPlaying = false;
		}

		//==============================================================================================================
		// Mediator API
		//==============================================================================================================

		public override function listNotificationInterests():Array
		{
			return [mediatorName + TestButtonView.BUTTON_TRIGGERED];
		}

		public override function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case mediatorName + TestButtonView.BUTTON_TRIGGERED:
					handleAction(String(notification.getBody()));
					break;
			}
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		private function handleAction(actionID:String):void
		{
			switch(actionID)
			{
				case ACTION_PLAY:
					playSound();
					break;
				case ACTION_PAUSE:
					pauseSound();
					break;
				case ACTION_STOP:
					stopSound();
					break;
			}
		}

		private function playSound():void
		{
			if (soundPlaying)
			{
				SoundHelpers.resumeSoundOnChannel(channelID);
			}
			else
			{
				soundPlaying = true;
				SoundHelpers.playSound(soundID, channelID, handleSoundCompleted);
			}
			if (soundPlaying)
			{
				enableButtons(ACTION_PAUSE, ACTION_STOP);
				facade.sendNotification(STARTED_SOUND_ON_CHANNEL, channelID);
			}
		}

		private function pauseSound():void
		{
			if (soundPlaying)
			{
				SoundHelpers.pauseSoundOnChannel(channelID);
				enableButtons(ACTION_PLAY, ACTION_STOP);
			}
		}

		private function stopSound():void
		{
			if (soundPlaying)
			{
				SoundHelpers.stopSoundOnChannel(channelID);
			}
		}

		private function handleSoundCompleted(vo:CompleteSoundPropertiesVO):void
		{
			soundPlaying = false;
			enableButtons(ACTION_PLAY);
			facade.sendNotification(STOPPED_SOUND_ON_CHANNEL, channelID);
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function enableButtons(...buttonsToEnable):void
		{
			for (var buttonID:String in buttons)
			{
				if (buttonsToEnable.indexOf(buttonID) >= 0)
				{
					buttons[buttonID].enable();
				}
				else
				{
					buttons[buttonID].disable();
				}
			}
		}

		private function createContainer(parentContainer:Sprite, setup:SoundTestSetupVO, gameSize:GameSizeVO):void
		{
			container = new Sprite();
			parentContainer.addChild(container);
			container.y = gameSize.getHeight() * setup.getY();
		}

		private function createName(parentMediatorName:String, titleLayout:TestTitleLayoutVO, setup:SoundTestSetupVO, gameSize:GameSizeVO):void
		{
			var tfHeight:int = gameSize.getHeight() * titleLayout.getTextHeight();
			name = new TextField(gameSize.getWidth() * titleLayout.getTextWidth(), tfHeight,
										LocalizationHelpers.getLocalizedText(parentMediatorName, setup.getTextID()),
										Constants.APPLICATION_FONT_REGULAR, tfHeight * 0.25, 0xFFFFFF, true);
			name.x = gameSize.getWidth() * titleLayout.getX();
			container.addChild(name);
		}

		private function createButtons(buttonLayout:TestButtonLayoutVO, buttonTexturesMap:Dictionary, gameSize:GameSizeVO):void
		{
			var buttonVOs:Vector.<TestButtonVO> = buttonLayout.getButtons(),
				buttonID:String,
				buttonView:TestButtonView,
				buttonTextures:Vector.<Texture>;

			buttons = new Dictionary();
			for (var i:int=0; i<buttonVOs.length; i++)
			{
				buttonID = buttonVOs[i].getButtonID();
				buttonTextures = buttonTexturesMap[buttonID];
				buttonView = new TestButtonView(mediatorName, buttonID);
				buttonView.createButton(container, buttonTextures[0], buttonTextures[1], gameSize.getWidth() * buttonVOs[i].getX(), 0);
				buttons[buttonID] = buttonView;
			}
		}
	}
}
