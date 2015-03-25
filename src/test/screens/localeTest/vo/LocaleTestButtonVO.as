package test.screens.localeTest.vo
{
	import constants.Constants;

	import test.screens.common.vo.IButtonDataVO;

	public class LocaleTestButtonVO implements IButtonDataVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var textID												:String;
		private var commandName											:String;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function LocaleTestButtonVO(textID:String, commandName:String)
		{
			this.textID = textID;
			this.commandName = commandName;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getTextID():String
		{
			return textID;
		}

		public function getCommandName():String
		{
			return commandName;
		}

		public function getButtonGraphics():String
		{
			return Constants.SIMPLE_BUTTON_GRAPHICS;
		}
	}
}
