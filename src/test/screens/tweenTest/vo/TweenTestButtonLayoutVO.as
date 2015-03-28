package test.screens.tweenTest.vo
{
	public class TweenTestButtonLayoutVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var buttonWidth						:Number;
		private var buttonHeight					:Number;
		private var buttons							:Vector.<TweenTestButtonVO>;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TweenTestButtonLayoutVO(buttonWidth:Number, buttonHeight:Number, buttons:Vector.<TweenTestButtonVO>)
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

		public function getButtons():Vector.<TweenTestButtonVO>
		{
			return buttons;
		}
	}
}
