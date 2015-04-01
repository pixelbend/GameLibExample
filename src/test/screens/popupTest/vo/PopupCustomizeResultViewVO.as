package test.screens.popupTest.vo
{
	import test.screens.common.vo.ViewVO;

	public class PopupCustomizeResultViewVO extends ViewVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var textID										:String;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function PopupCustomizeResultViewVO(x:Number, y:Number, width:Number, height:Number, textID:String)
		{
			super(x, y, width, height);
			this.textID = textID;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getTextID():String
		{
			return textID;
		}
	}
}
