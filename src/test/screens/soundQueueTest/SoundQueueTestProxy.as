package test.screens.soundQueueTest
{
	import test.screens.common.model.AbstractScreenProxy;
	import test.screens.common.vo.ButtonLayoutVO;
	import test.screens.common.vo.IButtonDataVO;
	import test.screens.soundQueueTest.vo.SoundQueueTestButtonVO;

	public class SoundQueueTestProxy extends AbstractScreenProxy
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function SoundQueueTestProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			super(proxyName, screenName, screenLogicXML, screenAssetsXML);
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseButtonData(buttonDataXML:XML):IButtonDataVO
		{
			return new SoundQueueTestButtonVO(
													String(buttonDataXML.@textID),
													String(buttonDataXML.@commandName),
													parseInt(String(buttonDataXML.@channelID)),
													String(buttonDataXML.@sounds).split(";")
												);
		}
	}
}
