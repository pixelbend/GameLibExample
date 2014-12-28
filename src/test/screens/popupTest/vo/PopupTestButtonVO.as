package test.screens.popupTest.vo
{
	import test.screens.common.vo.IButtonDataVO;

	public class PopupTestButtonVO implements IButtonDataVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var textID												:String;
		private var commandName											:String;
		private var popupName											:String;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function PopupTestButtonVO(textID:String, commandName:String, popupName:String)
		{
			this.textID = textID;
			this.commandName = commandName;
			this.popupName = popupName;
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

		public function getPopupName():String
		{
			return popupName;
		}
	}
}
