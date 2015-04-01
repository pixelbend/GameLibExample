package test.screens.popupTest
{
	import com.pixelBender.helpers.PopupHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.popup.PopupTranslucentLayerVO;

	import constants.Constants;

	import test.screens.popupTest.vo.CustomizationStateVO;
	import test.screens.popupTest.vo.PopupButtonVO;
	import test.screens.popupTest.vo.PopupCustomizeResultViewVO;

	import test.screens.popupTest.vo.PopupCustomizeViewVO;

	public class PopupTestProxy extends GameScreenProxy
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const STACK_POPUPS								:String = "stackPopups";
		public static const TRANSLUCENT_LAYER_ENABLED					:String = "translucentLayerEnabled";
		public static const TRANSLUCENT_LAYER_COLOR						:String = "translucentLayerColor";
		public static const TRANSLUCENT_LAYER_ALPHA						:String = "translucentLayerAlpha";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var alphaIndex											:int;
		private var translucentLayerAlphaValues							:Vector.<Number>;

		private var colorIndex											:int;
		private var translucentLayerColorValues							:Vector.<int>;

		private var customizeVOs										:Vector.<PopupCustomizeViewVO>;
		private var resultViewVO										:PopupCustomizeResultViewVO;

		private var customizationStateVO								:CustomizationStateVO;
		private var buttonVO											:PopupButtonVO;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function PopupTestProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			super(proxyName, screenName, screenLogicXML, screenAssetsXML);
			customizationStateVO = new CustomizationStateVO();
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function getCustomizeVOs():Vector.<PopupCustomizeViewVO>
		{
			return customizeVOs;
		}

		public function getCustomizationStateVO():CustomizationStateVO
		{
			return customizationStateVO;
		}

		public function getResultViewVO():PopupCustomizeResultViewVO
		{
			return resultViewVO;
		}

		public function getButtonVO():PopupButtonVO
		{
			return buttonVO;
		}

		public function initializeState():void
		{
			var translucentLayerVO:PopupTranslucentLayerVO = customizationStateVO.getTranslucentLayerVO(),
				actualState:PopupTranslucentLayerVO = PopupHelpers.getTranslucentLayerProperties();

			alphaIndex = 0;
			colorIndex = 0;

			translucentLayerVO.setLayerEnabled(actualState.getLayerEnabled());
			translucentLayerVO.setLayerColor(actualState.getLayerColor());
			translucentLayerVO.setLayerAlpha(actualState.getLayerAlpha());

			customizationStateVO.setStackPopups(PopupHelpers.getStackPopups());
		}

		public function changeState(propertyToChange:String):void
		{
			var translucentLayerVO:PopupTranslucentLayerVO = customizationStateVO.getTranslucentLayerVO();

			switch (propertyToChange)
			{
				case STACK_POPUPS:
					customizationStateVO.setStackPopups(!customizationStateVO.getStackPopups());
					PopupHelpers.setStackPopups(customizationStateVO.getStackPopups());
					break;
				case TRANSLUCENT_LAYER_ENABLED:
					translucentLayerVO.setLayerEnabled(!translucentLayerVO.getLayerEnabled());
					PopupHelpers.setTranslucentLayerEnabled(translucentLayerVO.getLayerEnabled());
					break;
				case TRANSLUCENT_LAYER_COLOR:
					colorIndex = (++colorIndex) % translucentLayerColorValues.length;
					translucentLayerVO.setLayerColor(translucentLayerColorValues[colorIndex]);
					PopupHelpers.setTranslucentLayerColor(translucentLayerVO.getLayerColor());
					break;
				case TRANSLUCENT_LAYER_ALPHA:
					alphaIndex = (++alphaIndex) % translucentLayerAlphaValues.length;
					translucentLayerVO.setLayerAlpha(translucentLayerAlphaValues[alphaIndex]);
					PopupHelpers.setTranslucentLayerAlpha(translucentLayerVO.getLayerAlpha());
					break;
			}

			facade.sendNotification(Constants.POPUP_CUSTOMIZATION_STATE_CHANGED, customizationStateVO);
		}

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		public override function dispose():void
		{
			translucentLayerAlphaValues = null;
			translucentLayerColorValues = null;
			customizeVOs = null;
			customizationStateVO = null;
			resultViewVO = null;
			buttonVO = null;

			super.dispose();
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

			customizeVOs = new Vector.<PopupCustomizeViewVO>();
			list = screenLogicXML.popupCustomizeViews.popupCustomizeView;
			for each (node in list)
			{
				var viewVO:PopupCustomizeViewVO = new PopupCustomizeViewVO(
																				parseFloat(String(node.@x)),
																				parseFloat(String(node.@y)),
																				parseFloat(String(node.@width)),
																				parseFloat(String(node.@height)),
																				String(node.@id),
																				String(node.@type),
																				String(node.@textID),
																				String(node.@noteType)
																			);
				customizeVOs.push(viewVO);
			}

			node = screenLogicXML.popupCustomizeResultView[0];
			resultViewVO = new PopupCustomizeResultViewVO(
																	parseFloat(String(node.@x)),
																	parseFloat(String(node.@y)),
																	parseFloat(String(node.@width)),
																	parseFloat(String(node.@height)),
																	String(node.@textID)
															);

			node = screenLogicXML.button[0];
			buttonVO = new PopupButtonVO(
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
