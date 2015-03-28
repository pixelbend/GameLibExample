package test.screens.common.vo
{
	public class TestButtonLayoutVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var buttonWidth						:Number;
		private var buttonHeight					:Number;
		private var buttons							:Vector.<TestButtonVO>;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TestButtonLayoutVO(buttonWidth:Number, buttonHeight:Number, buttons:Vector.<TestButtonVO>)
		{
			this.buttonWidth = buttonWidth;
			this.buttonHeight = buttonHeight;
			this.buttons = buttons;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getButtonWidth():Number
		{
			return buttonWidth;
		}

		public function getButtonHeight():Number
		{
			return buttonHeight;
		}

		public function getButtons():Vector.<TestButtonVO>
		{
			return buttons;
		}
	}
}
