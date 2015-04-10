package test.screens.localeTest.vo
{
	import test.screens.common.vo.ViewVO;

	public class LocaleTestButtonVO extends ViewVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var textID												:String;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function LocaleTestButtonVO(x:Number, y:Number, width:Number, height:Number, textID:String, commandName:String)
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
