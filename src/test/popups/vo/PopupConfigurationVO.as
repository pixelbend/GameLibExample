package test.popups.vo
{
	public class PopupConfigurationVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		private var x										:int;
		private var y										:int;
		private var width									:int;
		private var height									:int;
		private var color									:int;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function PopupConfigurationVO(x:int, y:int, width:int, height:int, color:int)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.color = color;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getX():int
		{
			return x;
		}

		public function getY():int
		{
			return y;
		}

		public function getWidth():int
		{
			return width;
		}

		public function getHeight():int
		{
			return height;
		}

		public function getColor():int
		{
			return color;
		}
	}
}
