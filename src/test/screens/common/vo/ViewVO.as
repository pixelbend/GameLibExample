package test.screens.common.vo
{
	public class ViewVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var x											:Number;
		protected var y											:Number;
		protected var width										:Number;
		protected var height									:Number;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function ViewVO(x:Number, y:Number, width:Number, height:Number)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getX():Number
		{
			return x;
		}

		public function getY():Number
		{
			return y;
		}

		public function getWidth():Number
		{
			return width;
		}

		public function getHeight():Number
		{
			return height;
		}
	}
}
