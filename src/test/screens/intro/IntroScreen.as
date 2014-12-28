package test.screens.intro
{
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.model.GameScreenProxy;

	import constants.Constants;

	import starling.display.DisplayObjectContainer;
	import test.screens.common.screen.AbstractScreen;
	import test.screens.intro.vo.IntroButtonDataVO;

	public class IntroScreen extends AbstractScreen
	{
		//==============================================================================================================
		// EMBEDDED MEMBERS
		//==============================================================================================================

		[Embed(source="../../../assets/generic/screens/intro/settings/logic.xml")]
		private const logicXML														:Class;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function IntroScreen(mediatorName:String)
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
			sendReadyToStart();
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		override protected function getScreenAssetXML():XML { return null; }
		override protected function getScreenLogicXML():XML { return new XML(logicXML.data); }
		override protected function createGameScreenProxy():GameScreenProxy
		{
			return new IntroScreenProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		//==============================================================================================================
		// NOTIFICATION HANDLERS
		//==============================================================================================================

		protected override function handleTestButtonTriggered(testButtonData:Object):void
		{
			var data:IntroButtonDataVO = testButtonData as IntroButtonDataVO;
			ScreenHelpers.showScreen(data.getScreenName(), Constants.TRANSITION_SEQUENCE_NAME);
		}
	}
}