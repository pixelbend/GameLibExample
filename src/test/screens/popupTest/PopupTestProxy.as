package test.screens.popupTest
{
	import test.screens.common.model.AbstractScreenProxy;
	import test.screens.common.vo.IButtonDataVO;
	import test.screens.popupTest.vo.PopupTestButtonVO;

	public class PopupTestProxy extends AbstractScreenProxy
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var translucentLayerAlphaValues							:Vector.<Number>;
		private var translucentLayerColorValues							:Vector.<int>;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function PopupTestProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			super(proxyName, screenName, screenLogicXML, screenAssetsXML);
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function getTranslucentLayerAlphaValues():Vector.<Number>
		{
			return translucentLayerAlphaValues.concat();
		}

		public function getTranslucentLayerColorValues():Vector.<int>
		{
			return translucentLayerColorValues.concat();
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseScreenLogicXML():void
		{
			var list:XMLList,
				node:XML;

			translucentLayerAlphaValues = new Vector.<Number>();
			list = screenLogicXML.transparentLayerAlphas.transparentLayerAlpha;
			for each (node in list)
			{
				translucentLayerAlphaValues.push(parseFloat(String(node.@alpha)));
			}

			translucentLayerColorValues = new Vector.<int>();
			list = screenLogicXML.transparentLayerColors.transparentLayerColor;
			for each (node in list)
			{
				translucentLayerColorValues.push(parseInt(String(node.@color)));
			}

			super.parseScreenLogicXML();
		}

		protected override function parseButtonData(buttonDataXML:XML):IButtonDataVO
		{
			// Create button VO
			return new PopupTestButtonVO(
											String(buttonDataXML.@textID),
											String(buttonDataXML.@commandName),
											String(buttonDataXML.@popupName)
										);
		}
	}
}
