package test.screens.common.model
{
	import com.pixelBender.model.GameScreenProxy;

	import test.screens.common.vo.ButtonLayoutVO;
	import test.screens.common.vo.IButtonDataVO;

	public class AbstractScreenProxy extends GameScreenProxy
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var buttonsData								:Vector.<IButtonDataVO>;
		protected var buttonLayout								:ButtonLayoutVO;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function AbstractScreenProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			super(proxyName, screenName, screenLogicXML, screenAssetsXML);
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		public override function dispose():void
		{
			buttonsData = null;
			buttonLayout = null;
			super.dispose();
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getButtonsData():Vector.<IButtonDataVO>
		{
			return buttonsData;
		}

		public function getButtonLayout():ButtonLayoutVO
		{
			return buttonLayout;
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseScreenLogicXML():void
		{
			var testLayoutXML:XML = screenLogicXML.buttonLayout[0],
				testButtonsList:XMLList = screenLogicXML.buttons.button;
			// Create button layout
			if (testLayoutXML)
			{
				buttonLayout = new ButtonLayoutVO(
														parseInt(String(testLayoutXML.@fontSize)),
														parseInt(String(testLayoutXML.@columns)),
														parseFloat(String(testLayoutXML.@width)),
														parseFloat(String(testLayoutXML.@height)),
														parseFloat(String(testLayoutXML.@ellipseDimension)),
														parseFloat(String(testLayoutXML.@horizontalGap)),
														parseFloat(String(testLayoutXML.@verticalGap)),
														parseFloat(String(testLayoutXML.@startX)),
														parseFloat(String(testLayoutXML.@startY))
													);
			}
			// Create button data
			buttonsData = new Vector.<IButtonDataVO>();
			for each (var testButtonXML:XML in testButtonsList)
			{
				buttonsData.push(parseButtonData(testButtonXML));
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function parseButtonData(buttonDataXML:XML):IButtonDataVO
		{
			return null;
		}
	}
}
