package starling
{
	import starling.display.Sprite;
	
	public class StarlingRootContainer extends Sprite
	{
		
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================
		
		public static var instance													:StarlingRootContainer;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function StarlingRootContainer()
		{
			super();
			instance = this;
		}
	}
}
