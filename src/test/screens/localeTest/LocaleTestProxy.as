package test.screens.localeTest
{
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.model.GameScreenProxy;

	import test.screens.localeTest.vo.AvailableLocaleVO;
	import test.screens.localeTest.vo.LocaleTestButtonVO;

	public class LocaleTestProxy extends GameScreenProxy
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var localeIndex									:int;
		private var availableLocaleVOs							:Vector.<AvailableLocaleVO>;
		private var buttonVO									:LocaleTestButtonVO;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function LocaleTestProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			super(proxyName, screenName, screenLogicXML, screenAssetsXML);
			localeIndex = 0;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function getButtonVO():LocaleTestButtonVO
		{
			return buttonVO;
		}

		public function switchLocale():void
		{
			localeIndex = (localeIndex + 1) % availableLocaleVOs.length;
			LocalizationHelpers.changeLocale(availableLocaleVOs[localeIndex].getLocale());
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

		protected override function parseScreenLogicXML():void
		{
			var list:XMLList,
				node:XML = screenLogicXML.button[0];
			buttonVO = new LocaleTestButtonVO(
									parseFloat(String(node.@x)),
									parseFloat(String(node.@y)),
									parseFloat(String(node.@width)),
									parseFloat(String(node.@height)),
									String(node.@textID),
									String(node.@commandName)
							);

			list = screenLogicXML.availableLocales.locale;
			availableLocaleVOs = new Vector.<AvailableLocaleVO>(list.length(), true);
			for (var i:int = 0; i<availableLocaleVOs.length; i++)
			{
				node = list[i];
				availableLocaleVOs[i] = new AvailableLocaleVO(String(node.@id));
			}
		}
	}
}
