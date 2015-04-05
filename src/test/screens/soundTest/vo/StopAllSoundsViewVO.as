package test.screens.soundTest.vo
{
	public class StopAllSoundsViewVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var y											:Number;
		protected var textWidth									:Number;
		protected var textHeight								:Number;
		protected var buttonX									:Number;
		protected var buttonWidth								:Number;
		protected var buttonHeight								:Number;
		protected var textID									:String;
		protected var buttonLinkage								:String;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function StopAllSoundsViewVO(y:Number, textWidth:Number, textHeight:Number, buttonWidth:Number, buttonHeight:Number,
											buttonX:Number, textID:String, buttonLinkage:String)
		{
			this.y = y;
			this.textWidth = textWidth;
			this.textHeight = textHeight;
			this.buttonWidth = buttonWidth;
			this.buttonHeight = buttonHeight;
			this.buttonX = buttonX;
			this.textID = textID;
			this.buttonLinkage = buttonLinkage;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getY():Number
		{
			return y;
		}

		public function getTextWidth():Number
		{
			return textWidth;
		}

		public function getTextHeight():Number
		{
			return textHeight;
		}

		public function getButtonX():Number
		{
			return buttonX;
		}

		public function getButtonWidth():Number
		{
			return buttonWidth;
		}

		public function getButtonHeight():Number
		{
			return buttonHeight;
		}

		public function getTextID():String
		{
			return textID;
		}

		public function getButtonLinkage():String
		{
			return buttonLinkage;
		}
	}
}
