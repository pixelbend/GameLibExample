package test.screens.soundTest.vo
{
	import test.screens.common.vo.ViewVO;

	public class MasterVolumeViewVO extends ViewVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var textID								:String;
		private var textHeight							:Number;
		private var scrollY								:Number;
		private var scrollHeight						:Number;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function MasterVolumeViewVO(x:Number, y:Number, width:Number, height:Number, textID:String, textHeight:Number,
											scrollY:Number, scrollHeight:Number)
		{
			super(x, y, width, height);

			this.textID = textID;
			this.textHeight = textHeight;
			this.scrollY = scrollY;
			this.scrollHeight = scrollHeight;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getTextID():String
		{
			return textID;
		}

		public function getTextHeight():Number
		{
			return textHeight;
		}

		public function getScrollY():Number
		{
			return scrollY;
		}

		public function getScrollHeight():Number
		{
			return scrollHeight;
		}
	}
}
