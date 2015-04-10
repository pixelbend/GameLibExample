package test.screens.localeTest
{
	import com.pixelBender.model.GameScreenProxy;

	import test.screens.common.vo.IButtonDataVO;
	import test.screens.localeTest.vo.LocaleTestButtonVO;

	public class LocaleTestProxy extends GameScreenProxy
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var buttonVO									:LocaleTestButtonVO;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function LocaleTestProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			super(proxyName, screenName, screenLogicXML, screenAssetsXML);
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function getButtonVO():LocaleTestButtonVO
		{
			return buttonVO;
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		public override function dispose():void
		{
			buttonVO = null;
			super.dispose();
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseScreenLogicXML():void
		{
			var node:XML = screenLogicXML.button[0];
			buttonVO = new LocaleTestButtonVO(
									parseFloat(String(node.@x)),
									parseFloat(String(node.@y)),
									parseFloat(String(node.@width)),
									parseFloat(String(node.@height)),
									String(node.@textID),
									String(node.@commandName)
							);
		}
	}
}
