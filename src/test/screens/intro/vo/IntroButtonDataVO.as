package test.screens.intro.vo
{
	import constants.Constants;

	import test.screens.common.vo.IButtonDataVO;

	public class IntroButtonDataVO implements IButtonDataVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var screenName										:String;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function IntroButtonDataVO(screenName:String)
		{
			this.screenName = screenName;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getScreenName():String
		{
			return screenName;
		}

		public function getTextID():String
		{
			return screenName;
		}

		public function getButtonGraphics():String
		{
			return Constants.SIMPLE_BUTTON_GRAPHICS;
		}
	}
}
