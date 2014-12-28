package test.screens.tweenTest
{
	import test.screens.common.model.AbstractScreenProxy;
	import test.screens.common.vo.IButtonDataVO;
	import test.screens.tweenTest.vo.TweenTestButtonVO;

	public class TweenTestProxy extends AbstractScreenProxy
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TweenTestProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			super(proxyName, screenName, screenLogicXML, screenAssetsXML);
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseButtonData(buttonDataXML:XML):IButtonDataVO
		{
			// Internals
			var tweenProperties:Object = {},
				tweenPropertyList:Array = String(buttonDataXML.@properties).split(";"),
				tweenPropertyString:String,
				tweenPropertyPair:Array;
			// Split and parse properties
			for each (tweenPropertyString in tweenPropertyList)
			{
				tweenPropertyPair = tweenPropertyString.split(":");
				tweenProperties[tweenPropertyPair[0]] = parseFloat(tweenPropertyPair[1]);
			}
			// Create button VO
			return new TweenTestButtonVO(
											String(buttonDataXML.@textID),
											String(buttonDataXML.@commandName),
											String(buttonDataXML.@tweenName),
											parseInt(String(buttonDataXML.@duration)),
											tweenProperties,
											String(buttonDataXML.@needsUpdating) == "true"
											);
		}
	}
}
