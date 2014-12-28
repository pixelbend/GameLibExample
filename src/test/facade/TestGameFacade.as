package test.facade
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.facade.GameFacade;
	
	import flash.display.DisplayObjectContainer;

	import starling.display.DisplayObjectContainer;

	import test.command.GlobalAssetPackageLoadedHandler;

	public class TestGameFacade extends GameFacade
	{

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function TestGameFacade()
		{
			super();
		}
		
		//==============================================================================================================
		// STATIC INSTANCE
		//==============================================================================================================
		
		/**
		 * 
		 * It will create an instance if it wasn't already created. Otherwise will return the former created instance
		 * 
		 * @return the instance of the TestGameFacade
		 */
		public static function getInstance():TestGameFacade
		{
			if (instance == null)
			{
				instance = new TestGameFacade();
			}
			return instance as TestGameFacade;
		}
		
		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================
		
		override public function dispose():void
		{
			this.removeCommand(GameConstants.GLOBAL_ASSET_PACKAGE_LOADED);
			super.dispose();
		}
		
		override public function init(root:flash.display.DisplayObjectContainer, globalLogic:XML, globalAssets:XML,
									  gameReadyCallback:Function, firstScreenName:String=null,
									  starlingRoot:starling.display.DisplayObjectContainer = null,
									  transitionSequenceName:String=null, locale:String=""):void
		{
			super.init(root, globalLogic, globalAssets, gameReadyCallback, firstScreenName, starlingRoot,
							transitionSequenceName, locale);
		}
		
		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		override protected function initializeController():void
		{
			super.initializeController();
			this.registerCommand(GameConstants.GLOBAL_ASSET_PACKAGE_LOADED, GlobalAssetPackageLoadedHandler);
		}
	}
}