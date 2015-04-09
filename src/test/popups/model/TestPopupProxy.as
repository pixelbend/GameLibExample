package test.popups.model
{
	import com.pixelBender.model.PopupProxy;
	import com.pixelBender.model.vo.game.GameSizeVO;

	import test.popups.vo.PopupConfigurationVO;

	public class TestPopupProxy extends PopupProxy
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var configurationVO								:PopupConfigurationVO;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TestPopupProxy(popupName:String)
		{
			super(popupName);
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getConfigurationVO():PopupConfigurationVO
		{
			return configurationVO;
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		protected override function parseLogicXML():void
		{
			var gameSize:GameSizeVO = gameFacade.getApplicationSize(),
				popupWidth:int = parseFloat(String(popupLogicXML.@width)) * gameSize.getWidth(),
				popupHeight:int = parseFloat(String(popupLogicXML.@height)) * gameSize.getHeight();

			configurationVO = new PopupConfigurationVO(
							(gameSize.getWidth() - popupWidth) >> 1,
							(gameSize.getHeight() - popupHeight) >> 1,
							popupWidth,
							popupHeight,
							parseInt(String(popupLogicXML.@color))
			);
		}
	}
}
