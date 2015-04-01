package test.screens.popupTest.vo
{
	import com.pixelBender.model.vo.popup.PopupTranslucentLayerVO;

	public class CustomizationStateVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var stackPopups										:Boolean;
		private var translucentLayerVO								:PopupTranslucentLayerVO;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function CustomizationStateVO()
		{
			translucentLayerVO = new PopupTranslucentLayerVO();
		}

		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================

		public function getStackPopups():Boolean
		{
			return stackPopups;
		}

		public function setStackPopups(value:Boolean):void
		{
			stackPopups = value;
		}

		public function getTranslucentLayerVO():PopupTranslucentLayerVO
		{
			return translucentLayerVO;
		}
	}
}
