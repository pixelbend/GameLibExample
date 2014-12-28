package test.screens.soundQueueTest
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.component.sound.SoundQueuePlayer;
	import com.pixelBender.model.vo.sound.CompleteQueuePropertiesVO;
	import constants.Constants;
	import starling.display.DisplayObjectContainer;
	import test.screens.common.screen.TestScreen;
	import test.screens.soundQueueTest.vo.SoundQueueTestButtonVO;

	public class SoundQueueTestScreen extends TestScreen
	{
		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/soundQueueTest/settings/logic.xml")]
		private const logicXML														:Class;

		[Embed(source="../../../assets/generic/screens/soundQueueTest/settings/assets.xml")]
		private const assetsXML														:Class;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var queuePlayers													:Vector.<SoundQueuePlayer>;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundQueueTestScreen(mediatorName:String)
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
			queuePlayers = new Vector.<SoundQueuePlayer>(GameConstants.CHANNEL_PLAN_C);
			registerDefaultPackageSounds();
			sendReadyToStart();
		}

		override public function pause():void
		{
			IRunnableHelpers.pause(queuePlayers);
			super.pause();
		}

		override public function resume():void
		{
			IRunnableHelpers.resume(queuePlayers);
			super.resume();
		}

		override public function dispose():void
		{
			unregisterDefaultPackageSounds();
			IRunnableHelpers.dispose(queuePlayers);
			queuePlayers = null;
			super.dispose();
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		override protected function getScreenAssetXML():XML { return new XML(assetsXML.data); }
		override protected function getScreenLogicXML():XML { return new XML(logicXML.data); }
		override protected function createGameScreenProxy():GameScreenProxy
		{
			return new SoundQueueTestProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function handleTestButtonTriggered(testButtonData:Object):void
		{
			var data:SoundQueueTestButtonVO = testButtonData as SoundQueueTestButtonVO;
			switch(data.getCommandName())
			{
				case Constants.START_SOUND_QUEUE:
					handleStartSoundQueue(data);
					break;
				case Constants.PAUSE_SOUND_QUEUE:
					handlePauseSoundQueue(data);
					break;
				case Constants.RESUME_SOUND_QUEUE:
					handleResumeSoundQueue(data);
					break;
				case Constants.STOP_SOUND_QUEUE:
					handleStopSoundQueue(data);
					break;
			}
		}

		//==============================================================================================================
		// LOCALS HANDLERS
		//==============================================================================================================

		private function handleStartSoundQueue(testButtonData:SoundQueueTestButtonVO):void
		{
			var channelID:int = testButtonData.getChannelID();
			if (queuePlayers[channelID] == null)
			{
				queuePlayers[channelID] = SoundHelpers.createQueuePlayer("queue" + channelID, testButtonData.getSounds(),
																			channelID, handleQueueCompleted);
			}
			else
			{
				queuePlayers[channelID].stop();
			}
			queuePlayers[channelID].play();
		}

		private function handlePauseSoundQueue(testButtonData:SoundQueueTestButtonVO):void
		{
			var channelID:int = testButtonData.getChannelID();
			if (queuePlayers[channelID] != null)
			{
				queuePlayers[channelID].pause();
			}
		}

		private function handleResumeSoundQueue(testButtonData:SoundQueueTestButtonVO):void
		{
			var channelID:int = testButtonData.getChannelID();
			if (queuePlayers[channelID] != null)
			{
				queuePlayers[channelID].resume();
			}
		}

		private function handleStopSoundQueue(testButtonData:SoundQueueTestButtonVO):void
		{
			var channelID:int = testButtonData.getChannelID();
			if (queuePlayers[channelID] != null)
			{
				queuePlayers[channelID].stop();
			}
		}

		private static function handleQueueCompleted(vo:CompleteQueuePropertiesVO):void
		{
			trace(vo);
		}
	}
}
