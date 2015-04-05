package test.screens.soundTest
{
	import com.pixelBender.model.GameScreenProxy;

	import test.screens.common.vo.TestButtonLayoutVO;
	import test.screens.common.vo.TestButtonVO;
	import test.screens.common.vo.TestTitleLayoutVO;
	import test.screens.soundTest.vo.MasterVolumeViewVO;
	import test.screens.soundTest.vo.SoundTestSetupVO;
	import test.screens.soundTest.vo.StopAllSoundsViewVO;

	public class SoundTestProxy extends GameScreenProxy
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var titleLayout								:TestTitleLayoutVO;
		protected var buttonLayout								:TestButtonLayoutVO;
		protected var stopAllSoundsViewVO						:StopAllSoundsViewVO;
		protected var masterVolumeViewVO						:MasterVolumeViewVO;
		protected var testSetups								:Vector.<SoundTestSetupVO>;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundTestProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			super(proxyName, screenName, screenLogicXML, screenAssetsXML);
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		public override function dispose():void
		{
			testSetups = null;
			buttonLayout = null;
			titleLayout = null;
			stopAllSoundsViewVO = null;
			masterVolumeViewVO = null;
			super.dispose();
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getTitleLayout():TestTitleLayoutVO
		{
			return titleLayout;
		}

		public function getButtonLayout():TestButtonLayoutVO
		{
			return buttonLayout;
		}

		public function getTestSetups():Vector.<SoundTestSetupVO>
		{
			return testSetups;
		}

		public function getStopAllSoundsViewVO():StopAllSoundsViewVO
		{
			return stopAllSoundsViewVO;
		}

		public function getMasterVolumeViewVO():MasterVolumeViewVO
		{
			return masterVolumeViewVO;
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseScreenLogicXML():void
		{
			var titleLayoutXML:XML = screenLogicXML.testTitleLayout[0],
				buttonLayoutXML:XML = screenLogicXML.testButtonLayout[0],
				stopAllSoundsViewXML:XML = screenLogicXML.stopAllSoundsView[0],
				masterVolumeViewXML:XML = screenLogicXML.masterVolumeView[0],
				buttonLayoutList:XMLList = buttonLayoutXML.button,
				setupsList:XMLList = screenLogicXML.soundTestSetups.soundTestSetup,
				buttons:Vector.<TestButtonVO> = new Vector.<TestButtonVO>();

			titleLayout = new TestTitleLayoutVO(
					parseFloat(String(titleLayoutXML.@x)),
					parseFloat(String(titleLayoutXML.@textWidth)),
					parseFloat(String(titleLayoutXML.@textHeight))
			);

			for each (var buttonNode:XML in buttonLayoutList)
			{
				buttons.push(
						new TestButtonVO(
								parseFloat(String(buttonNode.@x)),
								String(buttonNode.@buttonID),
								String(buttonNode.@linkage)
						)
				);
			}

			buttonLayout = new TestButtonLayoutVO(
					parseFloat(String(buttonLayoutXML.@buttonWidth)),
					parseFloat(String(buttonLayoutXML.@buttonHeight)),
					buttons
			);

			stopAllSoundsViewVO = new StopAllSoundsViewVO(
					parseFloat(String(stopAllSoundsViewXML.@y)),
					parseFloat(String(stopAllSoundsViewXML.@textWidth)),
					parseFloat(String(stopAllSoundsViewXML.@textHeight)),
					parseFloat(String(stopAllSoundsViewXML.@buttonWidth)),
					parseFloat(String(stopAllSoundsViewXML.@buttonHeight)),
					parseFloat(String(stopAllSoundsViewXML.@buttonX)),
					String(stopAllSoundsViewXML.@textID),
					String(stopAllSoundsViewXML.@buttonLinkage)
			);

			masterVolumeViewVO = new MasterVolumeViewVO(
					parseFloat(String(masterVolumeViewXML.@x)),
					parseFloat(String(masterVolumeViewXML.@y)),
					parseFloat(String(masterVolumeViewXML.@width)),
					parseFloat(String(masterVolumeViewXML.@height)),
					String(masterVolumeViewXML.@textID),
					parseFloat(String(masterVolumeViewXML.@textHeight)),
					parseFloat(String(masterVolumeViewXML.@scrollY)),
					parseFloat(String(masterVolumeViewXML.@scrollHeight))
			);

			testSetups = new Vector.<SoundTestSetupVO>();
			for each (var testButtonXML:XML in setupsList)
			{
				testSetups.push(parseTestSetup(testButtonXML));
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private static function parseTestSetup(setupXML:XML):SoundTestSetupVO
		{
			return new SoundTestSetupVO(
					String(setupXML.@setupID),
					String(setupXML.@textID),
					parseFloat(String(setupXML.@y)),
					String(setupXML.@soundID),
					parseInt(String(setupXML.@channelID))
			);
		}
	}
}
