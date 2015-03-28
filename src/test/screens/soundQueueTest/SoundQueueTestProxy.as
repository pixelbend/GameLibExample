package test.screens.soundQueueTest
{
	import com.pixelBender.model.GameScreenProxy;

	import test.screens.common.vo.TestButtonLayoutVO;
	import test.screens.common.vo.TestButtonVO;

	import test.screens.common.vo.TestTitleLayoutVO;
	import test.screens.soundQueueTest.vo.SoundQueueTestSetupVO;

	public class SoundQueueTestProxy extends GameScreenProxy
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var titleLayout								:TestTitleLayoutVO;
		protected var buttonLayout								:TestButtonLayoutVO;
		protected var testSetups								:Vector.<SoundQueueTestSetupVO>;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundQueueTestProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
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

		public function getTestSetups():Vector.<SoundQueueTestSetupVO>
		{
			return testSetups;
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseScreenLogicXML():void
		{
			var titleLayoutXML:XML = screenLogicXML.soundQueueTestTitleLayout[0],
				buttonLayoutXML:XML = screenLogicXML.soundQueueTestButtonLayout[0],
				buttonLayoutList:XMLList = buttonLayoutXML.button,
				setupsList:XMLList = screenLogicXML.soundQueueTestSetups.soundQueueTestSetup,
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

			testSetups = new Vector.<SoundQueueTestSetupVO>();
			for each (var testButtonXML:XML in setupsList)
			{
				testSetups.push(parseTestSetup(testButtonXML));
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private static function parseTestSetup(setupXML:XML):SoundQueueTestSetupVO
		{
			var soundIDsList:Array = String(setupXML.@soundIDs).split(";"),
				soundIDs:Vector.<String> = new Vector.<String>(soundIDsList.length, true);

			for (var i:int=0; i<soundIDsList.length; i++)
			{
				soundIDs[i] = soundIDsList[i];
			}

			return new SoundQueueTestSetupVO(
					String(setupXML.@setupID),
					String(setupXML.@textID),
					parseFloat(String(setupXML.@y)),
					soundIDs,
					parseInt(String(setupXML.@channelID))
			);
		}
	}
}
