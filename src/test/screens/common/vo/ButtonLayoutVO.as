package test.screens.common.vo
{
	public class ButtonLayoutVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var fontSize										:int;
		private var columns											:int;
		private var width											:Number;
		private var height											:Number;
		private var ellipseDimension								:Number;
		private var horizontalGap									:Number;
		private var verticalGap										:Number;
		private var startX											:Number;
		private var startY											:Number;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function ButtonLayoutVO(fontSize:int, columns:int, width:Number, height:Number, ellipseDimension:Number,
											horizontalGap:Number, verticalGap:Number, startX:Number, startY:Number)
		{
			this.fontSize = fontSize;
			this.columns = columns;
			this.width = width;
			this.height = height;
			this.ellipseDimension = ellipseDimension;
			this.horizontalGap = horizontalGap;
			this.verticalGap = verticalGap;
			this.startX = startX;
			this.startY = startY;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getFontSize():int
		{
			return fontSize;
		}

		public function getColumns():int
		{
			return columns;
		}

		public function getWidth():Number
		{
			return width;
		}

		public function getHeight():Number
		{
			return height;
		}

		public function getEllipseDimension():Number
		{
			return ellipseDimension;
		}

		public function getHorizontalGap():Number
		{
			return horizontalGap;
		}

		public function getVerticalGap():Number
		{
			return verticalGap;
		}

		public function getStartX():Number
		{
			return startX;
		}

		public function getStartY():Number
		{
			return startY;
		}
	}
}
