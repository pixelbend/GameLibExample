package test.screens.common.vo
{
	public class TestTitleLayoutVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var x								:Number;
		private var textWidth						:Number;
		private var textHeight						:Number;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function TestTitleLayoutVO(x:Number, textWidth:Number, textHeight:Number)
		{
			this.x = x;
			this.textWidth = textWidth;
			this.textHeight = textHeight;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getX():Number
		{
			return x;
		}

		public function getTextWidth():Number
		{
			return textWidth;
		}

		public function getTextHeight():Number
		{
			return textHeight;
		}
	}
}
