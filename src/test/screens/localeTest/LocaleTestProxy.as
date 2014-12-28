package test.screens.localeTest
{
	import test.screens.common.model.AbstractScreenProxy;
	import test.screens.common.vo.IButtonDataVO;
	import test.screens.localeTest.vo.LocaleTestButtonVO;

	public class LocaleTestProxy extends AbstractScreenProxy
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function LocaleTestProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			super(proxyName, screenName, screenLogicXML, screenAssetsXML);
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseButtonData(buttonDataXML:XML):IButtonDataVO
		{
			// Create button VO
			return new LocaleTestButtonVO(String(buttonDataXML.@textID), String(buttonDataXML.@commandName));
		}
	}
}
