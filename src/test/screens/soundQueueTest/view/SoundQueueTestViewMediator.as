package test.screens.soundQueueTest.view
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

	import flash.utils.Dictionary;

	import org.puremvc.as3.interfaces.INotification;

	import org.puremvc.as3.patterns.mediator.Mediator;

	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;

	import test.screens.common.view.TestButtonView;

	import test.screens.common.vo.TestButtonLayoutVO;
	import test.screens.common.vo.TestButtonVO;

	import test.screens.common.vo.TestTitleLayoutVO;
	import test.screens.soundQueueTest.vo.SoundQueueTestSetupVO;

	public class SoundQueueTestViewMediator extends Mediator implements IRunnable
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		protected static const MEDIATOR_NAME						:String = "_soundQueueTestViewMediator";

		protected static const ACTION_PLAY							:String = "play";
		protected static const ACTION_PAUSE							:String = "pause";
		protected static const ACTION_STOP							:String = "stop";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var name											:TextField;
		private var container										:Sprite;
		private var buttons											:Dictionary;
		private var soundQueue										:SoundQueuePlayer;

		private var channelID										:int;
		private var queueSoundIDs									:Vector.<String>;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundQueueTestViewMediator(parentMediatorName:String, parentContainer:Sprite, gameSize:GameSizeVO,
												   titleLayout:TestTitleLayoutVO, buttonLayout:TestButtonLayoutVO,
												   setup:SoundQueueTestSetupVO, buttonTexturesMap:Dictionary)
		{
			super(parentMediatorName + MEDIATOR_NAME + "_" + setup.getSetupID());

			trace(mediatorName);

			channelID = setup.getChannelID();
			queueSoundIDs = setup.getSoundIDs();

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
			container = null;

			StarlingHelpers.removeFromParent(name);
			name = null;

			IDisposeHelpers.dispose(buttons);
			buttons = null;

			if (soundQueue != null)
			{
				soundQueue.dispose();
				soundQueue = null;
			}

			queueSoundIDs = null;
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
					playQueue();
					break;
				case ACTION_PAUSE:
					pauseQueue();
					break;
				case ACTION_STOP:
					stopQueue();
					break;
			}
		}

		private function playQueue():void
		{
			if (getQueueActive())
			{
				soundQueue.resume();
			}
			else
			{
				soundQueue = SoundHelpers.createQueuePlayer("queue" + channelID, queueSoundIDs, channelID, handleQueueCompleted);
				soundQueue.play();
			}
			enableButtons(ACTION_PAUSE, ACTION_STOP);
		}

		private function pauseQueue():void
		{
			if (getQueueActive())
			{
				soundQueue.pause();
				enableButtons(ACTION_PLAY, ACTION_STOP);
			}
		}

		private function stopQueue():void
		{
			if (getQueueActive())
			{
				soundQueue.stop();
			}
		}

		private function handleQueueCompleted(vo:CompleteQueuePropertiesVO):void
		{
			soundQueue.dispose();
			soundQueue = null;
			enableButtons(ACTION_PLAY);
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function getQueueActive():Boolean
		{
			return soundQueue != null;
		}

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

		private function createContainer(parentContainer:Sprite, setup:SoundQueueTestSetupVO, gameSize:GameSizeVO):void
		{
			container = new Sprite();
			parentContainer.addChild(container);
			container.y = gameSize.getHeight() * setup.getY();
		}

		private function createName(parentMediatorName:String, titleLayout:TestTitleLayoutVO, setup:SoundQueueTestSetupVO, gameSize:GameSizeVO):void
		{
			name = new TextField(gameSize.getWidth() * titleLayout.getTextWidth(), gameSize.getHeight() * titleLayout.getTextHeight(),
										LocalizationHelpers.getLocalizedText(parentMediatorName, setup.getTextID()),
										"Verdana", 20, 0x000000, true);
			name.x = gameSize.getWidth() * titleLayout.getX();
			container.addChild(name);
		}

		private function createButtons(buttonLayout:TestButtonLayoutVO, buttonTexturesMap:Dictionary, gameSize:GameSizeVO):void
		{
			var buttonVOs:Vector.<TestButtonVO> = buttonLayout.getButtons(),
				buttonID:String,
				buttonView:TestButtonView,
				buttonTexturesTriplet:Vector.<Texture>;

			buttons = new Dictionary();
			for (var i:int=0; i<buttonVOs.length; i++)
			{
				buttonID = buttonVOs[i].getButtonID();
				buttonTexturesTriplet = buttonTexturesMap[buttonID];
				buttonView = new TestButtonView(mediatorName, buttonID);
				buttonView.createButton(container, buttonTexturesTriplet[0], buttonTexturesTriplet[1], gameSize.getWidth() * buttonVOs[i].getX(), 0);
				buttons[buttonID] = buttonView;
			}
		}
	}
}
