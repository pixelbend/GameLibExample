package test.screens.soundTest
{
	import test.screens.common.model.AbstractScreenProxy;
	import test.screens.common.vo.IButtonDataVO;
	import test.screens.soundTest.vo.SoundTestButtonDataVO;

	public class SoundTestProxy extends AbstractScreenProxy
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundTestProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			super(proxyName, screenName, screenLogicXML, screenAssetsXML);
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseButtonData(buttonDataXML:XML):IButtonDataVO
		{
			return new SoundTestButtonDataVO(
												String(buttonDataXML.@textID),
												String(buttonDataXML.@noteName),
												String(buttonDataXML.@type),
												String(buttonDataXML.@soundName),
												parseInt(String(buttonDataXML.@channelID)),
												parseInt(String(buttonDataXML.@priority))
											);
		}
	}
}
