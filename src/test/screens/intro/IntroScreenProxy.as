package test.screens.intro
{
	import test.screens.common.model.AbstractScreenProxy;
	import test.screens.common.vo.IButtonDataVO;
	import test.screens.intro.vo.IntroButtonDataVO;

	public class IntroScreenProxy extends AbstractScreenProxy
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function IntroScreenProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			super(proxyName, screenName, screenLogicXML, screenAssetsXML);
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseButtonData(buttonDataXML:XML):IButtonDataVO
		{
			return new IntroButtonDataVO(String(buttonDataXML.@screenName));
		}
	}
}
