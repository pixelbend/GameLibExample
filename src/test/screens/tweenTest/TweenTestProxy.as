package test.screens.tweenTest
{
	import com.pixelBender.model.GameScreenProxy;

	import test.screens.common.vo.TestTitleLayoutVO;

	import test.screens.common.vo.TestButtonVO;

	import test.screens.tweenTest.vo.TweenTestSetupVO;
	import test.screens.common.vo.TestButtonLayoutVO;

	public class TweenTestProxy extends GameScreenProxy
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var titleLayout								:TestTitleLayoutVO;
		protected var buttonLayout								:TestButtonLayoutVO;
		protected var testSetups								:Vector.<TweenTestSetupVO>;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TweenTestProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
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

		public function getTestSetups():Vector.<TweenTestSetupVO>
		{
			return testSetups;
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseScreenLogicXML():void
		{
			var titleLayoutXML:XML = screenLogicXML.tweenTestTitleLayout[0],
				buttonLayoutXML:XML = screenLogicXML.tweenTestButtonLayout[0],
				buttonLayoutList:XMLList = buttonLayoutXML.button,
				setupsList:XMLList = screenLogicXML.tweenTestSetups.tweenTestSetup,
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

			testSetups = new Vector.<TweenTestSetupVO>();
			for each (var testButtonXML:XML in setupsList)
			{
				testSetups.push(parseTestSetup(testButtonXML));
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private static function parseTestSetup(testButtonXML:XML):TweenTestSetupVO
		{
			var propertyPairList:Array = String(testButtonXML.@properties).split(";"),
				properties:Object = {},
				propertyPair:Array,
				i:int;

			for (i=0; i<propertyPairList.length; i++)
			{
				propertyPair = propertyPairList[i].split(":");
				properties[propertyPair[0]] = parseFloat(propertyPair[1]);
			}

			return new TweenTestSetupVO(parseFloat(String(testButtonXML.@y)), properties,
										parseInt(String(testButtonXML.@duration)), String(testButtonXML.@tweenNameTextID));
		}
	}
}
