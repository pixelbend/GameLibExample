package test.screens.soundTest
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.model.GameScreenProxy;

	import starling.display.DisplayObjectContainer;
	import test.screens.common.screen.TestScreen;
	import test.screens.soundTest.vo.SoundTestButtonDataVO;

	public class SoundTestScreen extends TestScreen
	{
		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/soundTest/settings/logic.xml")]
		private const logicXML														:Class;

		[Embed(source="../../../assets/generic/screens/soundTest/settings/assets.xml")]
		private const assetsXML														:Class;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundTestScreen(mediatorName:String)
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
			registerDefaultPackageSounds();
			sendReadyToStart();
		}

		public override function stop():void
		{
			SoundHelpers.stopAllSoundsOnChannels();
			unregisterDefaultPackageSounds();
			super.stop();
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		override protected function getScreenAssetXML():XML { return new XML(assetsXML.data); }
		override protected function getScreenLogicXML():XML { return new XML(logicXML.data); }
		override protected function createGameScreenProxy():GameScreenProxy
		{
			return new SoundTestProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		//==============================================================================================================
		// NOTIFICATION HANDLERS
		//==============================================================================================================

		protected override function handleTestButtonTriggered(testButtonData:Object):void
		{
			var data:SoundTestButtonDataVO = testButtonData as SoundTestButtonDataVO;
			switch(data.getNoteName())
			{
				case GameConstants.PLAY_SOUND_ON_CHANNEL:
					SoundHelpers.playSound(data.getSoundName(), data.getChannelID(), null, data.getPriority());
					break;
				case GameConstants.PAUSE_RESUME_SOUND_ON_CHANNEL:
					if (data.getNoteType() == GameConstants.TYPE_PAUSE_SOUND)
					{
						SoundHelpers.pauseSoundOnChannel(data.getChannelID());
					}
					else
					{
						SoundHelpers.resumeSoundOnChannel(data.getChannelID());
					}
					break;
				case GameConstants.STOP_SOUND_ON_CHANNEL:
					SoundHelpers.stopSoundOnChannel(data.getChannelID());
					break;
				case GameConstants.STOP_SOUNDS_ON_ALL_CHANNELS:
					SoundHelpers.stopAllSoundsOnChannels();
					break;
			}
		}
	}
}
